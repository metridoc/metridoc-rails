ActiveAdmin.register Report::Query do
  actions :all

  menu if: proc{ authorized?(:read, Report::Query) }, parent: I18n.t("phrases.reports")

  permit_params :name,
                :report_template_id,
                :owner_id,
                :comments,
                :select_section,
                :from_section,
                :where_section,
                :group_by_section,
                :order_section

  form do |f|
    f.inputs do
      f.input :name
      f.input :comments
      f.input :report_template_id, as: :select, collection: Report::Template.all.collect{|t| [t.name, t.id]}, include_blank: I18n.t("phrases.please_select")

      f.input :select_section, as: :text
      f.input :from_section, as: :text
      f.input :where_section, as: :text
      f.input :group_by_section, as: :text
      f.input :order_section, as: :text

      f.actions
    end
  end

  show do |report_query|
      attributes_table do
        row :name
        row :comments
        row :report_template_id do
          report_query.report_template_id.present? ? report_query.report_template.name : "-"
        end
        row :owner do
          report_query.owner ? report_query.owner.full_name : "-"
        end
        row :output_file_name do
          report_query.output_file_name.present? ? link_to(I18n.t("phrases.download"), download_admin_report_query_path(report_query), target: '_blank') : "-"
        end
        row :last_run_at do
          report_query.last_run_at.blank? ? "-" : I18n.l(report_query.last_run_at)
        end
        row :status do
          report_query.status.blank? ? I18n.t("phrases.report_query.statuses.pending") : I18n.t("phrases.report_query.statuses.#{report_query.status}")
        end
        row :last_error_message
      end
  end

  action_item I18n.t("phrases.process"),
              only: :show,
              if: proc{ resource.status.in?(['success', 'failure']) && current_admin_user.authorized?('read-write', Report) } do
    link_to I18n.t("phrases.process"), re_process_admin_report_query_path(report_query)
  end

  index do
    column :name
    column :owner
    actions
  end

  before_create do |report_query|
    report_query.owner = current_admin_user
  end

  member_action :download, method: :get do
    send_file "tmp/#{resource.output_file_name}"
  end

  member_action :re_process, method: :get do
    resource.re_process
    redirect_to resource_path, notice: "Your file is in queue."
  end

  scope("Your Queries", default: true) { |scope| scope.where(owner_id: current_admin_user.id) }

end
