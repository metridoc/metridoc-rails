ActiveAdmin.register_page "Graduate Statistics",
  namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root), 
      link_to('Population Summary', :gate_count_population_penetration)
    ]
  end

  content title: "Populations & Penetration" do
    render partial: 'gate_count/statistics/graduate_statistics'
  end
end
