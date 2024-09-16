ActiveAdmin.register Springshare::Libcal::Appointment,
as: "Libcal::Appointment",
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

  # Explicitly define how to order the answer column
  order_by(:answers) do |order_clause|
    [
      Arel.sql("answers #>> '{}'"),
      order_clause.order
    ].join(' ')
  end

  # Set the title on the index page
  index title: "Appointment"
end
