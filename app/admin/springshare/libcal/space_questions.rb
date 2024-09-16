ActiveAdmin.register Springshare::Libcal::SpaceQuestion,
as: "Libcal::SpaceQuestion",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibCal', :springshare_libcal)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Explicitly define how to order the options column
  order_by(:options) do |order_clause|
    [
      Arel.sql("options #>> '{}'"),
      order_clause.order
    ].join(' ')
  end

  # Set the title the index page
  index title: "Space Booking Questions"
end
