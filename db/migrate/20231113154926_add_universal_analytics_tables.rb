class AddUniversalAnalyticsTables < ActiveRecord::Migration[6.1]
  def change
    create_table :ga_ua_daily_reports do |t|
      t.integer :property
      t.integer :fiscal_year
      t.date :date
      t.integer :users
      t.integer :new_users
      t.integer :sessions
      t.numeric :sessions_per_user
      t.integer :bounces
      t.numeric :bounce_rate
      t.numeric :session_duration
      t.numeric :avg_session_duration
      t.integer :pageviews
      t.numeric :pageviews_per_session

      t.index ["property", "fiscal_year", "date"],
        unique: true, name: "ga_ua_daily_report_id"
      t.index ["property"]
      t.index ["fiscal_year"]
      t.index ["date"]
    end

    create_table :ga_ua_devices do |t|
      t.integer :property
      t.integer :fiscal_year
      t.date :date
      t.string :browser
      t.string :operating_system
      t.integer :users
      t.integer :new_users
      t.integer :sessions
      t.numeric :sessions_per_user
      t.integer :bounces
      t.numeric :bounce_rate
      t.numeric :session_duration
      t.numeric :avg_session_duration
      t.integer :pageviews
      t.numeric :pageviews_per_session

      t.index [
        "property", "fiscal_year",  "date",
        "browser", "operating_system"
      ],
        unique: true, name: "ga_ua_device_id"

      t.index ["property"]
      t.index ["fiscal_year"]
      t.index ["date"]
      t.index ["browser"]
      t.index ["operating_system"]
    end

    create_table :ga_ua_locations do |t|
      t.integer :property
      t.integer :fiscal_year
      t.date :date
      t.string :continent
      t.string :sub_continent
      t.string :country
      t.string :region
      t.string :metro
      t.string :city
      t.string :country_iso_code
      t.string :region_iso_code
      t.integer :users
      t.integer :new_users
      t.integer :sessions
      t.numeric :sessions_per_user
      t.integer :bounces
      t.numeric :bounce_rate
      t.numeric :session_duration
      t.numeric :avg_session_duration
      t.integer :pageviews
      t.numeric :pageviews_per_session


      t.index [
        "property", "fiscal_year", "date",
        "country_iso_code", "region_iso_code", "city"
      ],
        unique: true, name: "ga_ua_location_id"

      t.index ["property"]
      t.index ["fiscal_year"]
      t.index ["date"]
      t.index ["country_iso_code"]
      t.index ["region_iso_code"]
    end

    create_table :ga_ua_pageviews do |t|
      t.integer :property
      t.integer :fiscal_year
      t.date :date
      t.string :page_path
      t.integer :pageviews
      t.integer :unique_pageviews
      t.integer :entrances
      t.numeric :entrance_rate
      t.integer :exits
      t.numeric :exit_rate
      t.integer :bounces
      t.numeric :bounce_rate
      t.numeric :time_on_page
      t.numeric :avg_time_on_page

      t.index [
        "property", "fiscal_year", "date",
        "page_path"
      ],
        unique: true, name: "ga_ua_pageview_id"

      t.index ["property"]
      t.index ["fiscal_year"]
      t.index ["date"]
      t.index ["page_path"]
    end

    create_table :ga_ua_sources do |t|
      t.integer :property
      t.integer :fiscal_year
      t.date :date
      t.string :source
      t.integer :users
      t.integer :new_users
      t.integer :sessions
      t.numeric :sessions_per_user
      t.integer :bounces
      t.numeric :bounce_rate
      t.numeric :session_duration
      t.numeric :avg_session_duration
      t.integer :pageviews
      t.numeric :pageviews_per_session

      t.index [
        "property", "fiscal_year", "date",
        "source"
      ],
        unique: true, name: "ga_ua_source_id"

      t.index ["property"]
      t.index ["fiscal_year"]
      t.index ["date"]
      t.index ["source"]

    end

    create_table :ga_ua_properties do |t|
      t.integer :property
      t.string :name
      t.string :url
      t.string :description

      t.index ["property"], unique: true
    end
  end
end
