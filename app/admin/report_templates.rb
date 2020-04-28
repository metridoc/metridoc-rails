ActiveAdmin.register Report::Template do
  actions :all

  menu if: proc{ authorized?(:read, Report::Template) }, parent: I18n.t("phrases.reports")

  permit_params :name,
                :comments,
                :from_section,
                :join_section,
                :where_section,
                :order_direction_section,
                select_section: [],
                group_by_section: [],
                order_section: []

  form partial:'form'

  index do
    column :name
    actions
  end

end
