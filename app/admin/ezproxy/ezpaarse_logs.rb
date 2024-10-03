ActiveAdmin.register Ezproxy::EzpaarseLog,
as: "Ezpaarse Logs",
namespace: :ezproxy do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EZProxy', :ezproxy_root)
    ]
  end

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


  index title: "EZPaarse Logs" do

    id_column
    # Loop through the columns and truncate the bib record for the index only
    self.resource_class.column_names.each do |c|
      next if c == "id"

      if ["url", "referer"].include? c
        column c.to_sym do |pr|
          pr[c].truncate 50 unless pr[c].nil?
        end
      else 
        column c.to_sym
      end

    end
    actions
  end
end
