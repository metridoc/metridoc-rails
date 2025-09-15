ActiveAdmin.register_page "About",
namespace: :gate_count do

  menu false

  #Action needed to define variables for frequency plots
  page_action :population, method: :post do
    redirect_url = "/gate_count/population_penetration?"
    redirect_url += "year=#{params[:year]}"
    redirect_to redirect_url
  end

  content title: "GateCount" do
    render partial: 'index'
  end
end
