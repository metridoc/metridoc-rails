ActiveAdmin.register_page "Stale", namespace: :keyserver do
  menu false

  breadcrumb do
    [link_to('Keyserver', :keyserver_root)]
  end

  content title: "Stale & Dormant Products" do
    render partial: 'keyserver/analysis/stale'
  end
end
