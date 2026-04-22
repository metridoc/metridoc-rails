ActiveAdmin.register_page "By School", namespace: :keyserver do
  menu false

  breadcrumb do
    [link_to('Keyserver', :keyserver_root)]
  end

  content title: "Software Usage by School" do
    render partial: 'keyserver/analysis/by_school'
  end
end
