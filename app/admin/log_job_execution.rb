ActiveAdmin.register Log::JobExecution do
  menu if: proc{ authorized?(:read, "Log") }, parent: I18n.t("active_admin.resource_sharing")

  actions :index, :show

  index do
    column :id
    column :source_name
    column :job_type
    column :mac_address
    column :global_yml
    column :started_at
    column :status_set_at
    column :status
    actions
  end

  show do
    attributes_table do
      row :source_name
      row :job_type
      row :mac_address
      row :global_yml
      row :started_at
      row :status_set_at
      row :status
      row (:log_text) { |e| simple_format e.log_text }
      row (Log::JobExecutionStep.model_name.human(count: 2)) { |e| link_to I18n.t("active_admin.index_list.block"), admin_log_job_execution_steps_path("q[job_execution_id_equals]" => e.id) }
    end
    active_admin_comments
  end

end
