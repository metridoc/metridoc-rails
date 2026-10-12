ActiveAdmin.register_page "Computer Activity",
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root),
    ]
  end

  controller do
    include KeyserverHelper
    include Keyserver::Filterable

    def index
      setup_date_range(Keyserver::Session)
      setup_division_list

      # Build scope and compute matrices
      session_scope = filtered_scope(Keyserver::Session)
      product_scope = filtered_scope(Keyserver::ProductUsage)
      program_scope = filtered_scope(Keyserver::ProgramUsage)

      matrix_result = Keyserver::DemographicMatrix.new(session_scope).call
      @raw_demo_matrix = apply_colors(matrix_result[:raw][:matrix], matrix_result[:raw][:max_cnt])
      @distinct_demo_matrix = apply_colors(matrix_result[:distinct][:matrix], matrix_result[:distinct][:max_cnt])

      division_result      = Keyserver::DivisionSummary.new(session_scope, start_date: @start_date, end_date: @end_date).call
      @division_records    = division_result[:records]
      @available_computers = division_result[:available]
      @peak_usage          = division_result[:peak_usage]

      # Evaluate top 10
      profile_result = Keyserver::UserProfileSummary.new(
        product_scope: product_scope,
        program_scope: program_scope,
        session_scope: session_scope
      ).call

      @product_usage = profile_result[:product_usage]
      @program_usage = profile_result[:program_usage]
      @sessions      = profile_result[:sessions]

      occupancy_result = Keyserver::OccupancySummary.new(filtered_occupancy_scope).call
      @avg_fleet_sessions = apply_colors(
        occupancy_result[:avg_fleet_sessions][:matrix], 
        occupancy_result[:avg_fleet_sessions][:max_cnt]
      )
      @avg_sessions_per_computer = apply_colors(
        occupancy_result[:avg_sessions_per_computer][:matrix],
        occupancy_result[:avg_sessions_per_computer][:max_cnt]
      )
      @avg_occupancy_per_computer = apply_colors(
        occupancy_result[:avg_occupancy_per_computer][:matrix],
        occupancy_result[:avg_occupancy_per_computer][:max_cnt]
      )

      @hours = (0..23).to_a
      @days = I18n.t("date.day_names")
    end
  end


  # General title for the page
  content title: "Computer Activity" do
    # Direct path to dashboard template
    render partial: 'keyserver/analysis/computer_activity'
  end
end