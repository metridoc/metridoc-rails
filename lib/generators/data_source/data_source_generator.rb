require 'rails/generators'
require 'rails/generators/active_record'

# Generates the skeleton for a new Metridoc data source.
#
# Usage:
#   rails generate data_source NAME --tables=TABLE[,TABLE,...] [--adapter=ADAPTER]
#
# Arguments:
#   NAME     CamelCase name of the data source (e.g. GateCount, Keyserver)
#
# Options:
#   --tables   Required. Comma-separated table names in snake_case (e.g. events,sessions)
#   --adapter  Source/target adapter. One of: csv (default), xlsx, postgres, mssql
#
# Example:
#   rails generate data_source Keyserver --tables=events,sessions --adapter=xlsx
#
# What gets generated:
#   config/data_sources/<name>/global.yml          Connection / folder config
#   config/data_sources/<name>/NN_<name>_<t>.yml   One import config per table
#   app/models/<name>/base.rb                       Abstract base model
#   app/models/<name>/<table>.rb                    One model class per table
#   app/admin/<name>/about.rb                       ActiveAdmin landing page
#   app/admin/<name>/<table>.rb                     ActiveAdmin resource per table
#   app/views/admin/<name>/_index.html.haml         Landing page partial
#   db/migrate/<ts>_create_<name>_tables.rb         Migration stub
#
# Manual steps after generation (printed at the end):
#   1. Add :<name> to namespaces array in config/initializers/active_admin.rb
#   2. Add menu entry in build_data_menu pointing to :<name>_root_path
#   3. Run: rails db:migrate

class DataSourceGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  source_root File.expand_path('templates', __dir__)

  class_option :tables, type: :string, required: true,
    desc: "Comma-separated list of table names, e.g. events,sessions"

  class_option :adapter, type: :string, default: 'csv',
    desc: "Adapter type: csv (default), xlsx, postgres, mssql"

  # Rails migration timestamp support
  def self.next_migration_number(path)
    ActiveRecord::Generators::Base.next_migration_number(path)
  end

  def validate_options
    valid_adapters = %w[csv xlsx postgres mssql]
    unless valid_adapters.include?(options[:adapter])
      raise Thor::Error, "Unknown adapter '#{options[:adapter]}'. Choose from: #{valid_adapters.join(', ')}"
    end
    if table_names.empty?
      raise Thor::Error, "--tables is required and must not be empty"
    end
  end

  def create_config_files
    empty_directory "config/data_sources/#{file_name}"
    template 'config/global.yml.tt', "config/data_sources/#{file_name}/global.yml"
    table_names.each_with_index do |table, i|
      @current_table    = table
      @current_sequence = i + 1
      template 'config/table.yml.tt',
        "config/data_sources/#{file_name}/#{format('%02d', i + 1)}_#{file_name}_#{table.pluralize}.yml"
    end
  end

  def create_model_files
    empty_directory "app/models/#{file_name}"
    template 'models/base.rb.tt', "app/models/#{file_name}/base.rb"
    table_names.each do |table|
      @current_table = table
      template 'models/model.rb.tt', "app/models/#{file_name}/#{table}.rb"
    end
  end

  def create_admin_files
    empty_directory "app/admin/#{file_name}"
    template 'admin/about.rb.tt', "app/admin/#{file_name}/about.rb"
    empty_directory "app/views/admin/#{file_name}"
    template 'admin/index.html.haml.tt', "app/views/admin/#{file_name}/_index.html.haml"
    table_names.each do |table|
      @current_table = table
      template 'admin/resource.rb.tt', "app/admin/#{file_name}/#{table.pluralize}.rb"
    end
  end

  def generate_migration_file
    migration_template 'migrate/create_tables.rb.tt',
      "db/migrate/create_#{file_name}_tables.rb"
  end

  def print_manual_steps
    say ""
    say "=" * 60, :yellow
    say "  Manual steps required", :yellow
    say "=" * 60, :yellow
    say ""
    say "1. Register the ActiveAdmin namespace.", :cyan
    say "   In config/initializers/active_admin.rb, add :#{file_name}"
    say "   to the namespaces array near the bottom of the file:"
    say ""
    say "     namespaces = ["
    say "       ..., :#{file_name}"
    say "     ]"
    say ""
    say "2. Add a navigation menu entry.", :cyan
    say "   Inside build_data_menu in the same file, add:"
    say ""
    say "     menu.add label: '#{display_name}',"
    say "       url: :#{file_name}_root_path,"
    say "       if: proc{ authorized?(:read, '#{class_name}') },"
    say "       parent: I18n.t('active_admin.library_data')"
    say ""
    say "3. Run the migration.", :cyan
    say "   rails db:migrate"
    say ""
    say "4. Fill in migration column definitions.", :cyan
    say "   Edit db/migrate/*_create_#{file_name}_tables.rb"
    say "   and add the columns for each table."
    say ""
    say "5. Fill in import config column_mappings.", :cyan
    table_names.each_with_index do |t, i|
      say "   config/data_sources/#{file_name}/#{format('%02d', i+1)}_#{file_name}_#{t.pluralize}.yml"
    end
    say ""
  end

  private

  # Always work with singular snake_case names internally, matching Rails model convention.
  # Users may pass either "events" or "event" — both normalize to "event".
  # Use table.pluralize for DB table names and import file names.
  def table_names
    @table_names ||= options[:tables].split(',').map { |t| t.strip.underscore.singularize }
  end

  def display_name
    class_name.gsub(/(?<=[a-z])(?=[A-Z])/, ' ')
  end

  def table_prefix
    "#{file_name}_"
  end

  def db_adapter
    options[:adapter]
  end

  def file_based?
    %w[csv xlsx].include?(db_adapter)
  end
end
