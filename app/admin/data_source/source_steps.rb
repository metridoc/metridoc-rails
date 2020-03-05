ActiveAdmin.register DataSource::SourceStep, as: "SourceStep" do
  belongs_to :source, class_name: "DataSource::Source"

  menu false

  # actions :index, :edit, :update, :show
  #
  config.sort_order = "load_sequence_asc"

  permit_params :name,
                :load_sequence,
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
                :legacy_filter_date_field,
                :file_name

  filter :load_sequence

  index do
    column :load_sequence
    column :name
    actions
  end

  form do |f|
    f.input :source
    f.input :name
    f.input :load_sequence
    f.input :select_distinct
    f.input :source_table
    f.input :column_mappings, as: :text
    f.input :filter_raw, as: :text
    f.input :export_file_name
    f.input :export_filter_date_sql, as: :text
    f.input :export_filter_date_range_sql, as: :text
    f.input :sqls, as: :text
    f.input :target_adapter
    f.input :truncate_before_load
    f.input :target_model
    f.input :transformations
    f.input :legacy_filter_date_field
    f.input :file_name
    f.actions
  end
  

end
