ActiveAdmin.register_page "Locations", namespace: :keyserver do
  menu false

  breadcrumb do
    [link_to('Keyserver', :keyserver_root)]
  end

  content title: "Location Usage" do
    render partial: 'keyserver/analysis/locations'
  end
end
