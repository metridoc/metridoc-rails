ActiveAdmin.register MeeScan::Session,
  namespace: :mee_scan do

  menu false

  breadcrumb do
    [
      link_to('MeeScan', :mee_scan_root)
    ]
  end

  actions :all, except: [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :fiscal_year
  filter :name
  filter :kiosk_id
  filter :device_os
  filter :language_code

  index do
    column :created_at
    column :year
    column :month
    column :fiscal_year
    column :name
    column :item_count
    column :item_return
    column :language_code
    column :device_model
    column :device_os
    column :device_os_version
    column :app_version
    column :kiosk_id
    column :receipt_sent
  end

end
