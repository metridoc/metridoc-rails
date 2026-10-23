ActiveAdmin.register_page "Program Search",
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root),
    ]
  end

  controller do
    include Keyserver::Filterable
    include KeyserverHelper

    def index
      setup_date_range(Keyserver::ProgramUsage)
      setup_program_list

      scope  = filtered_scope(Keyserver::ProgramUsage)
      demographic_result = Keyserver::DemographicMatrix.new(scope).call

      @raw_demo_matrix = apply_colors(demographic_result[:raw][:matrix], demographic_result[:raw][:max_cnt])
      @distinct_demo_matrix = apply_colors(demographic_result[:distinct][:matrix], demographic_result[:distinct][:max_cnt])

      profile_result = Keyserver::UserProfileSummary.new(
        product_scope: scope,
        program_scope: scope,
        session_scope: scope
      ).call

      @product_usage = profile_result[:product_usage]
      @program_usage = profile_result[:program_usage]
      @sessions      = profile_result[:sessions]

      @most_recent_date = scope.maximum(:start_time)&.to_date
      @number_of_uses = scope.count
      @number_of_users = scope.distinct.count(:user_name)

    end
  end

  # General title for the page
  content title: "Program Search" do
    # Direct path to dashboard template
    render partial: 'keyserver/analysis/program_search'
  end
end
