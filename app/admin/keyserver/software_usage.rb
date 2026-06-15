ActiveAdmin.register_page "Software Usage", namespace: :keyserver do
  menu false

  breadcrumb do
    [link_to('Keyserver', :keyserver_root)]
  end

  content title: "Software Usage Profile" do
    render partial: 'keyserver/analysis/software_usage'
  end
end
