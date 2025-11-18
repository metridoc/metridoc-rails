ActiveAdmin.register GateCount::KislakSwipe,
as: "Kislak Swipes",
namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]
end