ActiveAdmin.register Springshare::Libanswers::Ticket,
as: "Libanswers::Ticket",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibAnswers', :springshare_libanswers)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Tickets"
end