ActiveAdmin.register Springshare::Libanswers::Queue,
as: "Libanswers::Queue",
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
  index title: "Queue"
end