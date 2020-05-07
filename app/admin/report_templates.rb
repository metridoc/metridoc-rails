ActiveAdmin.register Report::Template do
  actions :all

  menu if: proc{ authorized?(:read, Report::Template) }, parent: I18n.t("phrases.reports")

  permit_params :name,
                :comments,
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

  controller do
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
