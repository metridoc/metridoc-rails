ActiveAdmin.register DataSource::Source, as: "Source" do
  menu if: proc{ authorized?(:read, DataSource::Source) }, parent: DataSource::Source.model_name.human(count: 2), priority: 2

  index do
    column :name
    column DataSource::Template.model_name.human do |source|
      source.template ? source.template.name : ""
    end
    column DataSource::SourceStep.model_name.human(count: 2) do |source|
      link_to DataSource::SourceStep.model_name.human(count: 2), 
                  admin_source_source_steps_path(source)
    end
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at

  show do |source|
      attributes_table do
        row :name
        row :institution_code
        row :source_adapter
        row :batch_size
        row :host
        row :port
        row :database
        row :username
        row :password
        row :export_folder
        row :import_folder
        row :batch_size
      end
      panel DataSource::SourceStep.model_name.human(count: 2) do
        table_for source.source_steps.order(:load_sequence) do
          column :load_sequence
          column :name

          column do |source_step|
            link_to "View", admin_source_source_step_path(source, source_step)
          end

        end
      end
  end

  permit_params :name,
                :data_source_template_id,
                :institution_code,
                :source_adapter,
                :host,
                :port,
                :database,
                :username,
                :password,
                :export_folder,
                :import_folder,
                :batch_size

end


