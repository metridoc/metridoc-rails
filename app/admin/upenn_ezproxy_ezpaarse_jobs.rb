ActiveAdmin.register UpennEzproxy::EzpaarseJob do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :datetime,
   :login,
   :platform,
   :platform_name,
   :rtype,
   :mime,
   :print_identifier,
   :online_identifier,
   :title_id,
   :doi,
   :publication,
   :publication_date,
   :unitid,
   :domain,
   :on_campus,
   :log_id,
   :geoip_country,
   :geoip_region,
   :geoip_city,
   :geoip_latitude,
   :geoip_longitude,
   :host,
   :method,
   :url,
   :status,
   :size,
   :referer,
   :session_id,
   :resource_name
end
