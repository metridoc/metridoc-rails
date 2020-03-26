ActiveAdmin.register Report::Query do
  actions :all

  menu if: proc{ authorized?(:read, Report::Query) }, parent: I18n.t("phrases.reports")

  permit_params :name,
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

  index do
    column :name
    column :owner
    actions
  end

  before_create do |report_query|
    report_query.owner = current_admin_user
  end

end
