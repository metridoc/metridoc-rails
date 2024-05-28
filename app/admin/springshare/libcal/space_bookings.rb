ActiveAdmin.register Springshare::Libcal::SpaceBooking,
as: "Libcal::SpaceBooking",
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

  # Explicitly define how to order the event column
  order_by(:event) do |order_clause|
    [
      Arel.sql("event ->> 'id'"),
      order_clause.order
    ].join(' ')
  end

  # Explicitly define how to order the answer column
  order_by(:answers) do |order_clause|
    [
      Arel.sql("answers #>> '{}'"),
      order_clause.order
    ].join(' ')
  end

  # Set the title the index page
  index title: "Space Bookings"
end
