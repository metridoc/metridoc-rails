ActiveAdmin.register Report::Template do
  actions :all

  menu if: proc{ authorized?(:read, Report::Template) }, parent: I18n.t("phrases.reports")

  permit_params :name,
                :comments,
                :from_section,
                :join_section,
                :where_section,
                :group_by_section,
                :order_direction_section,
                select_section: [],
                order_section: []

  form do |f|
    f.inputs do
      f.input :name
      f.input :comments
      f.input :select_section, as: :check_boxes, :collection => f.object.checkbox_options_for_select_section, disabled: ["*"]
      f.input :from_section, as: :datalist , :collection => TableRetrieval.all_tables
      f.input :join_section, as: :text, input_html: {disabled: true, hidden: true}
      f.input :where_section, as: :text, input_html: {disabled: true}
      f.input :group_by_section, as: :text, input_html: {disabled: true}
      f.input :order_section, as: :radio, :collection => f.object.radio_options_for_order_section, input_html: {disabled: true}
      f.input :order_direction_section, as: :select, :collection => ["ASC", "DESC"], selected: f.object.order_direction_section, include_blank: false, input_html: {disabled: true}

      f.actions
    end
  end

  index do
    column :name
    actions
  end

end
