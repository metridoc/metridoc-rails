ActiveAdmin.register Log::JobExecutionStep do
  menu false
  actions :index, :show
  
  index do
    column :job_execution_id
    column :step_name
    column :started_at
    column :status
    column :status_set_at
    actions
  end
  
  show do
    attributes_table do
      row :job_execution_id
      row :step_name
      row :step_yml
      row :started_at
      row :status
      row :status_set_at
      row (:log_text) { |e| simple_format e.log_text }
    end
    active_admin_comments
  end

end
