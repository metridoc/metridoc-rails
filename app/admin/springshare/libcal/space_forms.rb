ActiveAdmin.register Springshare::Libcal::SpaceForm,
as: "Libcal::SpaceForm",
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

  # Explicitly define how to order the fields column
  order_by(:fields) do |order_clause|
    [
      Arel.sql("fields #>> '{}'"),
      order_clause.order
    ].join(' ')
  end

  # Set the title the index page
  index title: "Space Booking Forms"
end
