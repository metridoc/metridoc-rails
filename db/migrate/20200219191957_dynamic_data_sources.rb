class DynamicDataSources < ActiveRecord::Migration[5.1]
  def up

    create_table :data_source_templates do |t|
      t.string     :name, null: false

      t.string     :source_adapter
      t.integer    :batch_size

      t.timestamps null: false
    end

    create_table :data_source_template_steps do |t|
      t.belongs_to :data_source_template, null: false
      t.integer    :load_sequence, null: false
      t.string     :name, null: false

      t.string     :select_distinct
      t.string     :source_table
      t.string     :column_mappings
      t.string     :filter_raw
      t.string     :export_file_name
      t.string     :export_filter_date_sql
      t.string     :export_filter_date_range_sql
      t.string     :sqls
      t.string     :file_name

      t.string     :target_adapter
      t.string     :truncate_before_load
      t.string     :target_model
      t.string     :transformations
      t.string     :legacy_filter_date_field

      t.timestamps null: false
    end
    add_foreign_key :data_source_template_steps, :data_source_templates


    create_table :data_source_sources do |t|
      t.string     :name, null: false
      t.belongs_to :data_source_template

      t.string     :institution_code
      t.string     :source_adapter
      t.string     :host
      t.string     :port
      t.string     :database
      t.string     :username
      t.string     :password
      t.string     :export_folder
      t.string     :import_folder
      t.integer    :batch_size

      t.timestamps null: false
    end
    add_foreign_key :data_source_sources, :data_source_templates

    create_table :data_source_source_steps do |t|
      t.belongs_to :data_source_source, null: false
      t.integer    :load_sequence, null: false
      t.string     :name, null: false

      t.string     :select_distinct
      t.string     :source_table
      t.string     :column_mappings
      t.string     :filter_raw
      t.string     :export_file_name
      t.string     :export_filter_date_sql
      t.string     :export_filter_date_range_sql
      t.string     :sqls
      t.string     :file_name

      t.string     :target_adapter
      t.string     :truncate_before_load
      t.string     :target_model
      t.string     :transformations
      t.string     :legacy_filter_date_field

      t.timestamps null: false
    end
    add_foreign_key :data_source_source_steps, :data_source_sources

    #data source types
    data_sources_folder = 'config/data_sources'
    template_definitions = [  {folder: "brown_illiad", name: "illiad" } ]
    template_definitions.each do |template_definition|
      folder = template_definition[:folder]
      name = template_definition[:name].titlecase
      puts "Processing #{folder}"
      template = DataSource::Template.find_or_initialize_by(name: name)
      global_yml = YAML.load(ERB.new(File.read( File.join(data_sources_folder, folder, "global.yml") )).result)
      template.attributes = global_yml.select{|x| template.attribute_names.index(x)}
      template.save!

      Dir.glob( File.join(data_sources_folder, folder, "*.yml") ).select{|file| File.basename(file) != 'global.yml' }.each do |file|
        puts "file=#{file}"
        name = file.match(/\d+\_([^\d\.]+)\.[a-zA-Z]+/)[1]
        step_yml = YAML.load(ERB.new(File.read( file )).result)
        step_yml.merge!(global_yml)
        template_step = template.template_steps.find_or_initialize_by(name: name)
        template_step.attributes = step_yml.select{|x| template_step.attribute_names.index(x)}
        template_step.save!
      end
    end

    #data sources
    data_sources_folder = 'config/data_sources'
    Dir.entries(data_sources_folder).select {|folder| File.directory?( File.join(data_sources_folder, folder) ) && !(folder == '.' || folder == '..')   }.each do |folder|
      puts "Processing #{folder}"
      source = DataSource::Source.find_or_initialize_by(name: folder.titlecase)

      if source.name.downcase =~ /illiad/
        template_definition = template_definitions.detect{|d| d[:folder] == "brown_illiad" }
        if template_definition.present?
          template =  DataSource::Template.find_by_name(template_definition[:name].titlecase)
          source.data_source_template_id = template.id
        end
      end

      global_yml = YAML.load(ERB.new(File.read( File.join(data_sources_folder, folder, "global.yml") )).result)
      source.attributes = global_yml.select{|x| source.attribute_names.index(x)}
      source.save!

      Dir.glob( File.join(data_sources_folder, folder, "*.yml") ).select{|file| File.basename(file) != 'global.yml' }.each do |file|
        puts "file=#{file}"
        name = file.match(/\d+\_([^\d\.]+)\.[a-zA-Z]+/)[1].titlecase
        step_yml = YAML.load(ERB.new(File.read( file )).result)
        step_yml.merge!(global_yml)
        source_step = source.source_steps.find_or_initialize_by(name: name.titlecase)
        source_step.attributes = step_yml.select{|x| source_step.attribute_names.index(x)}
        source_step.save!
      end
    end

  end
  def down
    drop_table :data_source_source_steps
    drop_table :data_source_sources

    drop_table :data_source_template_steps
    drop_table :data_source_templates
  end
end
