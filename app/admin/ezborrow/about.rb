ActiveAdmin.register_page "EZBorrow", namespace: :rsat do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root)
    ]
  end

  content title: "EZBorrow" do
    render partial: 'index'
  end
end
