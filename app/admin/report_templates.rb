ActiveAdmin.register Report::Template do
  actions :all

  menu if: proc{ authorized?(:read, Report::Template) }, parent: I18n.t("phrases.reports")

  permit_params :name,
                :comments,
                :from_section,
                :join_section,
                :where_section,
                :order_direction_section,
                :order_section,
                select_section: [],
                group_by_section: []

  form partial:'form'

  index do
    column :name
    actions
  end

  controller do
    def update
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

end
