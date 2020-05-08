ActiveAdmin.register Report::Query do
  actions :all

  menu if: proc{ authorized?(:read, Report::Query) }, parent: I18n.t("phrases.reports")

  permit_params :name,
                :report_template_id,
                :owner_id,
                :comments,
                :from_section,
                :where_section,
                :order_direction_section,
                :order_section,
                select_section: [],
                group_by_section: [],
                report_query_join_clauses_attributes: [:id, :_destroy, :keyword, :table, :on_keys]

  preserve_default_filters!
  remove_filter :report_query_join_clauses

  form partial:'form'

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
        row :progress do
          "<div _report_query_id=#{report_query.id} >#{report_query.progress_text}</div>".html_safe
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
              if: proc{ resource.status.in?(['success', 'failed', 'cancelled']) && current_admin_user.authorized?('read-write', Report) } do
    link_to I18n.t("phrases.process"), re_process_admin_report_query_path(report_query)
  end

  index download_links: [:csv] do
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
    redirect_to resource_path, notice: "Your export is in queue."
  end

  member_action :cancel, method: :get do
    resource.cancel
    redirect_to resource_path, notice: "Export has been cancelled."
  end

  scope("Your Queries", default: true) { |scope| scope.where(owner_id: current_admin_user.id) }

  controller do
    def new
      import_params_from_template if template_requested?
      new!
    end

    def update
      permitted_params = updated_permitted_params
      update!
    end

    private

    # required because the radio button can be unselected
    def updated_permitted_params
      updated_params = permitted_params
      order_section = updated_params[:order_section]
      updated_params[:order_section] = nil unless order_section
      updated_params
    end

    def template_requested?
      request.url.include?("template_id=")
    end

    def import_params_from_template
      template = Report::Template.find(params[:template_id])
      carryover_name = params[:name]
      carryover_comments = params[:comments]
      @report_query = Report::Query.new(
        name: carryover_name,
        comments: carryover_comments,
        report_template_id: template.id,
        select_section_with_aggregates: template.select_section,
        select_section: template.select_section,
        from_section: template.from_section,
        raw_join_clauses: template.join_clauses.to_json,
        where_section: template.where_section,
        group_by_section: template.group_by_section,
        order_section: template.order_section,
        order_direction_section: template.order_direction_section
      )
      # @report_query.raw_join_clauses(template.join_clauses.to_json)
    end
  end

  csv do
    column :id
    column :name
    column :report_template_id
    column(:select_section) { |template| template.select_section.join(" ") }
    column :from_section
    column(:join_section) { |template| template.join_section }
    column :where_section
    column(:group_by_section) { |template| template.group_by_section.join(" ") }
    column :order_section
    column :order_direction_section
    column :status
    column :last_run_at
    column :last_error_message
    column :output_file_name
    column :total_rows_to_process
    column :n_rows_processed
    column :created_at
    column :updated_at
  end
end
