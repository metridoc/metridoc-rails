ActiveAdmin.register_page "Population & Penetration",
namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root)
    ]
  end

  content title: "Populations & Penetration" do
    render partial: 'gate_count/statistics/population'
  end
end
