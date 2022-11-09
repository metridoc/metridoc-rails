ActiveAdmin.register_page "ILLiad", namespace: :rsat do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root)
    ]
  end
  
  content title: "ILLiad" do
    render partial: 'index'
  end
end
