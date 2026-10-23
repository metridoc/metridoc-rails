ActiveAdmin.register_page "User Profile",
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

      setup_date_range(Keyserver::ProductUsage)

      product_scope = filtered_scope(Keyserver::ProductUsage)
      program_scope = filtered_scope(Keyserver::ProgramUsage)
      session_scope = filtered_scope(Keyserver::Session)

      result = Keyserver::UserProfileSummary.new(
        product_scope: product_scope,
        program_scope: program_scope,
        session_scope: session_scope
      ).call

      @product_usage = result[:product_usage]
      @program_usage = result[:program_usage]
      @sessions      = result[:sessions]
    end
  end

    # General title for the page
  content title: "User Profile" do
    # Direct path to dashboard template
    render partial: 'keyserver/analysis/user_profile'
  end

end