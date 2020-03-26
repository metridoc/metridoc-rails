ActiveAdmin.register Report::Template do
  actions :all

  menu if: proc{ authorized?(:read, Report::Template) }, parent: I18n.t("phrases.reports")

  permit_params :name,
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

      f.input :select_section, as: :text
      f.input :from_section, as: :text
      f.input :where_section, as: :text
      f.input :group_by_section, as: :text
      f.input :order_section, as: :text

      f.actions
    end
  end

  index do
    column :name
    actions
  end

end
