ActiveAdmin.register_page "By User Group", namespace: :keyserver do
  menu false

  breadcrumb do
    [link_to('Keyserver', :keyserver_root)]
  end

  content title: "Software Usage by User Group" do
    render partial: 'keyserver/analysis/by_user_group'
  end
end
