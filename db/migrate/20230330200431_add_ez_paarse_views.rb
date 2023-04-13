class AddEzPaarseViews < ActiveRecord::Migration[5.2]
  def change
    create_table :ezpaarse_hourly_usages do |t|
      t.column :fiscal_year, :int
      t.column :date, :datetime
      t.column :day_of_week, :string
      t.column :dow_index, :int
      t.column :hour_of_day, :int
      t.column :requests, :int
      t.column :sessions, :int
    end

    create_table :ezpaarse_platforms do |t|
      t.column :fiscal_year, :int
      t.column :platform_name, :string
      t.column :rtype, :string
      t.column :mime, :string
      t.column :requests, :int
      t.column :sessions, :int
    end

    create_table :ezpaarse_user_profiles do |t|
      t.column :fiscal_year, :int
      t.column :user_group, :string
      t.column :school, :string
      t.column :country, :string
      t.column :state, :string
      t.column :requests, :int
      t.column :sessions, :int
    end

    rename_table :upenn_ezproxy_ezpaarse_jobs, :ezpaarse_logs
  end
end
