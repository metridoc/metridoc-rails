ActiveAdmin.register_page "Overview",
namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root)
    ]
  end
  
  content title: "Gate Counts Overview" do
    render partial: 'gate_count/statistics/overview'
  end
end
