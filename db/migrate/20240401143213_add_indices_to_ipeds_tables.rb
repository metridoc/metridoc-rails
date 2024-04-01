class AddIndicesToIpedsTables < ActiveRecord::Migration[7.1]
  def change
    add_index(
      :ipeds_cipcodes,
      [:cip_code2010, :cip_code2020],
      name: "ipeds_cipcodes_unique_id",
      unique: true
    )
    add_index(
      :ipeds_completion_schema,
      :varname,
      name: "ipeds_completion_schema_unique_id",
      unique: true
    )
    add_index(
       :ipeds_completions,
      [:year, :unitid, :cipcode, :majornum, :awlevel],
      name: "ipeds_completions_unique_id",
      unique: true
    )
    add_index(
      :ipeds_directories,
      :unitid,
      name: "ipeds_directories_unique_id",
      unique: true
    )
    add_index(
      :ipeds_directory_schema,
      :varname,
      name: "ipeds_directory_schema_unique_id",
      unique: true
    )
    add_index(
      :ipeds_stem_cipcodes,
      :cip_code_2020,
      name: "iped_stem_cipcodes_unique_id",
      unique: true
    )
  end
end
