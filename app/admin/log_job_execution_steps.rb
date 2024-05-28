ActiveAdmin.register Log::JobExecutionStep do
  menu false
  actions :index, :show

  # Define a way to sort json column explicitly
  order_by(:step_yml) do |order_clause|
    [
      Arel.sql("step_yml->> 'config_folder', step_yml ->> 'single_step'"),
      order_clause.order
    ].join(' ')
  end

  index do
    column :job_execution_id
    column :step_name
    column :step_yml
    column :started_at
    column :status
    column :status_set_at
    actions
  end

  show title: :title do |job_execution_step|
    attributes_table do
      row :job_execution_id do
        link_to job_execution_step.job_execution_id, admin_log_job_execution_path(job_execution_step.job_execution_id)
      end
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
