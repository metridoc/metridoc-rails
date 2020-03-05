ActiveAdmin.register DataSource::TemplateStep, as: "TemplateStep" do
  belongs_to :template, class_name: "DataSource::Template"

  menu false

  actions :index, :edit, :update, :show

  config.sort_order = "load_sequence_asc"

  permit_params :load_sequence,
                :select_distinct,
                :source_table,
                :column_mappings,
                :filter_raw,
                :export_file_name,
                :export_filter_date_sql,
                :export_filter_date_range_sql,
                :sqls,
                :target_adapter,
                :truncate_before_load,
                :target_model,
                :transformations,
                :legacy_filter_date_field
                :file_name

  filter :load_sequence

  index do
    column :load_sequence
    column :name
    actions
  end

end
