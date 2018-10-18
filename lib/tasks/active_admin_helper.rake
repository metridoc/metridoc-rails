desc "A better generator for our use of ActiveAdmin"
task :generate_active_admin_resources, %i[prefix] => [:environment] do |_t, args|
  prefix = args.prefix
  model_template = "ActiveAdmin.register %s do\n  menu false\n  permit_params %s\nend"

  files_in_prefix = Dir.new("#{Rails.root}/app/models/#{prefix}").select{|f| /\.rb$/.match(f) }
  files_in_prefix = files_in_prefix.map{|f| f.gsub(/\.rb/, '')}
  files_in_prefix.each do |file|
    puts "generating #{file}..."
    require "#{Rails.root}/app/models/#{prefix}/#{file}"
    klass = "#{prefix.camelize}::#{file.camelize}".constantize
    next if klass.abstract_class?
    columns = klass.column_names - ['id', 'created_at', 'updated_at']
    columns = columns.map{|n| n.split('').unshift(':').join('')}

    File.open("#{Rails.root}/app/admin/#{prefix}_#{file.pluralize}.rb", 'w') do |file|
     file.write(model_template % [klass.name, columns.join(', ')])
    end
  end

  File.open("#{Rails.root}/app/admin/#{prefix}.rb", 'w') do |file|
    file.write generator_index_template % [prefix.camelize, prefix.camelize]
  end

  puts "Generating index files..."
  FileUtils.mkdir_p("#{Rails.root}/app/views/admin/#{prefix}")
  File.open("#{Rails.root}/app/views/admin/#{prefix}/_index.html.haml", 'w') do |file|
    file.write <<-'EOF'
%ul
  - resources.each do |resource|
    %li= link_to resource.resource_name.human, "/admin/#{resource.resource_name.param_key.pluralize}"
EOF
  end
end

def generator_index_template
<<-EOF
ActiveAdmin.register_page "%s" do
  content do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^%s::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
EOF
end
