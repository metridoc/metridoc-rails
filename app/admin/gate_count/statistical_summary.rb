ActiveAdmin.register_page "Statistical Summary",
namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root)
    ]
  end

  content title: "Statistical Summary of Gate Counts" do
    render partial: 'gate_count/summary'
  end
end
