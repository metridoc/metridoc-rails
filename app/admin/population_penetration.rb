ActiveAdmin.register_page "Population & Penetration" do

  breadcrumb do
    [link_to('Admin',admin_root_path), link_to('Gate Counts',admin_gatecount_path)]
  end

  #Don't add to the top menu
  menu false

  #Action needed to define variables for frequency plots
  page_action :population, method: :get do
    @input_school = params[:school]
    @input_library = params[:libary]
  end

  def index
    ("admin_population_penetration_path").on("ajax:success",'admin_population_penetration_path', function(event, data, status, xhr) {
    var input_school=data.school;
    var input_library=data.library;
    alert("Response is => " + input_school + input_library);
    return input_school;
    return input_library};
  ).on("ajax:error", function(event, xhr, status, error) {
    var input_school="College of Arts and Sciences";
    var input_library="Van Pelt"});
  end
    
  #Title for the page
  content title: "Populations & Penetration" do
    render partial: 'admin/gatecount/population'
  end

  #Restrict the page view to the correct users:
  controller do
    private
    def authorize_access!
      authorize! :read, "GateCount"
    end
  end

end
