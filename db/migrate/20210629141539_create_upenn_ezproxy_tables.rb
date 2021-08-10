class CreateUpennEzproxyTables < ActiveRecord::Migration[5.2]
  def change
    create_table :upenn_ezproxy_ezpaarse_jobs do |t|
      t.datetime :datetime
      t.string  :login
      t.string  :platform
      t.string  :platform_name
      t.string  :rtype
      t.string  :mime
      t.string  :print_identifier
      t.string  :online_identifier
      t.string  :title_id
      t.string  :doi
      t.string  :publication_title
      t.date    :publication_date
      t.string  :unitid
      t.string  :domain
      t.boolean :on_campus
      t.string  :geoip_country, limit: 4
      t.string  :geoip_region, limit: 4
      t.string  :geoip_city
      t.float   :geoip_latitude
      t.float   :geoip_longitude
      t.string  :host
      t.string  :method, limit: 8
      t.string  :url
      t.string  :status, limit: 3
      t.integer :size
      t.string  :referer
      t.string  :session_id
      t.string  :resource_name
    end

    add_index :upenn_ezproxy_ezpaarse_jobs, :platform
    add_index :upenn_ezproxy_ezpaarse_jobs, :platform_name
    add_index :upenn_ezproxy_ezpaarse_jobs, :rtype
    add_index :upenn_ezproxy_ezpaarse_jobs, :mime
    add_index :upenn_ezproxy_ezpaarse_jobs, :host

  end

  def down
    drop_table :upenn_ezproxy_ezpaarse_jobs

  end
end
