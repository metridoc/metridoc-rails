ActiveAdmin.register_page "Monthly Statistics",
namespace: :illiad do

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "ILLiad Monthly Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "illiad_monthly_statistics" do
      # Direct path to dashboard template
      render partial: 'illiad/monthly_statistics'
    end
  end
end
