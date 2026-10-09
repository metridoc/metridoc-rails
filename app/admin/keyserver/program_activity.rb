ActiveAdmin.register_page "Program Activity",
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root),
    ]
  end

  controller do
    include Keyserver::Filterable

    def index
      setup_date_range(Keyserver::ProgramUsage)
      setup_division_list
      
      @records = Keyserver::ProgramActivitySummary.new(
        filtered_scope(Keyserver::ProgramUsage)
      ).call
    end

  end

  content title: "Program Activity" do
    render partial: 'keyserver/analysis/program_activity'
  end
end