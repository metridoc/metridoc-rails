ActiveAdmin.register Report::Template do
  actions :all

  menu false

  permit_params :name,
                :comments,
                :full_sql,
                :from_section,
                :where_section,
                :order_direction_section,
                :order_section,
                select_section: [],
                group_by_section: [],
                report_template_join_clauses_attributes: [:id, :_destroy, :keyword, :table, :on_keys]

  preserve_default_filters!
  remove_filter :report_template_join_clauses


  form partial:'form'

  index download_links: [:csv] do
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
      row :comments
      row :full_sql do |report_template|
        simple_format(report_template.full_sql) if report_template.full_sql.present?
      end
      row :select_section
      row :from_section
      row :join_section
      row :where_section
      row :group_by_section
      row :order_section
      row :order_direction_section
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  action_item I18n.t("phrases.report_template.run_as_query"),
              only: [:show, :edit],
              if: proc{ current_admin_user.authorized?('read-write', Report) } do
    link_to I18n.t("phrases.report_template.run_as_query"), run_as_query_admin_report_template_path(report_template)
  end

  member_action :run_as_query, method: :get do
    report_query = Report::TemplateService.run_template_as_query(template: resource, owner: current_admin_user)
    if report_query.errors.blank?
      redirect_to admin_report_query_path(report_query), notice: "Successfully queued template as query."
    else
      redirect_to resource_path, notice: "Failed to queue template as query: #{report_query.errors.full_messages.join(", ")}"
    end
  end

  controller do
    def update
      # required because the radio button can be unselected
      resource_params = updated_resource_params
      update!
    end

    private

    def updated_resource_params
      updated_params = resource_params.first
      order_section = updated_params[:order_section]
      updated_params[:order_section] = nil unless order_section
      [updated_params]
    end
  end

  csv do
    column :id
    column :name
    column(:select_section) { |template| template.select_section.join(" ") }
    column :from_section
    column(:join_section) { |template| template.join_section }
    column :where_section
    column(:group_by_section) { |template| template.group_by_section.join(" ") }
    column :order_section
    column :order_direction_section
    column :created_at
    column :updated_at
  end
end
