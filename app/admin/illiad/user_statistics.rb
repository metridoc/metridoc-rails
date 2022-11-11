ActiveAdmin.register_page "User Statistics",
namespace: :illiad do

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "ILLiad User Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "illiad_user_statistics" do
      # Direct path to dashboard template
      render partial: 'illiad/user_statistics'
    end
  end
end
