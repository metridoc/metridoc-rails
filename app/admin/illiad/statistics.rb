ActiveAdmin.register_page "Statistics",
namespace: :illiad do

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "ILLiad Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "illiad_statistics" do
      # Direct path to dashboard template
      render partial: 'illiad/statistics'
    end
  end
end
