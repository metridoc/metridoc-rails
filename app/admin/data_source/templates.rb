ActiveAdmin.register DataSource::Template, as: "Template" do
  actions :index, :edit, :show

  menu false

  index do
    column :id
    column :name
    column DataSource::TemplateStep.model_name.human(count: 2) do |template|
      link_to DataSource::TemplateStep.model_name.human(count: 2), 
                    admin_template_template_steps_path(template)
    end
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at

  show do
      attributes_table do
        row :name
        row :source_adapter
        row :batch_size
      end
      panel DataSource::TemplateStep.model_name.human(count: 2) do
        table_for template.template_steps.order(:load_sequence) do
          column :load_sequence
          column :name

          column do |template_step|
            link_to "View", admin_template_template_step_path(template, template_step)
          end

        end
      end
  end

end
