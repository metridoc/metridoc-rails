ActiveAdmin.register_page "Undergraduate Statistics",
namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root),
      link_to('Population Summary', :gate_count_population_penetration)
    ]
  end

  content title: "Undergraduate Statistics" do
    render partial: 'gate_count/statistics/undergraduate_statistics'
  end
end
