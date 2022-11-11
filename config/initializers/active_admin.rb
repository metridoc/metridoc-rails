ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "MetriDoc"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  config.site_title_link = "/admin/about"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Aim for an image that's 21px high so it fits in the header.
  #
  config.site_title_image = "logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the application controller.
  config.authentication_method = :authenticate_admin_user!

  # == User Authorization
  #
  # Active Admin will automatically call an authorization
  # method in a before filter of all controller actions to
  # ensure that there is a user with proper rights. You can use
  # CanCanAdapter or make your own. Please refer to documentation.
  config.authorization_adapter = "ActiveAdminAuthorization"

  # In case you prefer Pundit over other solutions you can here pass
  # the name of default policy class. This policy will be used in every
  # case when Pundit is unable to find suitable policy.
  # config.pundit_default_policy = "MyDefaultPunditPolicy"

  # You can customize your CanCan Ability class name here.
  # config.cancan_ability_class = "Ability"

  # You can specify a method to be called on unauthorized access.
  # This is necessary in order to prevent a redirect loop which happens
  # because, by default, user gets redirected to Dashboard. If user
  # doesn't have access to Dashboard, he'll end up in a redirect loop.
  # Method provided here should be defined in application_controller.rb.
  config.on_unauthorized_access = :access_denied

  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # (within the application controller) to return the currently logged in user.
  config.current_user_method = :current_admin_user

  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  config.logout_link_path = :logout_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get

  # == Root
  #
  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  #
  # Default:
  config.root_to = 'about#index'

  # == Admin Comments
  #
  # This allows your users to comment on any resource registered with Active Admin.
  #
  # You can completely disable comments:
  # config.comments = false
  #
  # You can change the name under which comments are registered:
  # config.comments_registration_name = 'AdminComment'
  #
  # You can change the order for the comments and you can change the column
  # to be used for ordering:
  # config.comments_order = 'created_at ASC'
  #
  # You can disable the menu item for the comments index page:
  config.comments_menu = false
  #
  # You can customize the comment menu:
  # config.comments_menu = { parent: 'Admin', priority: 1 }

  # == Batch Actions
  #
  # Enable and disable Batch Actions
  #
  config.batch_actions = true

  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources and pages from here.
  #
  # config.before_action :do_something_awesome

  # == Localize Date/Time Format
  #
  # Set the localize format to display dates and times.
  # To understand how to localize your app with I18n, read more at
  # https://github.com/svenfuchs/i18n/blob/master/lib%2Fi18n%2Fbackend%2Fbase.rb#L52
  #
  config.localize_format = :long

  # == Setting a Favicon
  #
  config.favicon = 'favicon.ico'

  # == Meta Tags
  #
  # Add additional meta tags to the head element of active admin pages.
  #
  # Add tags to all pages logged in users see:
  #   config.meta_tags = { author: 'My Company' }

  # By default, sign up/sign in/recover password pages are excluded
  # from showing up in search engine results by adding a robots meta
  # tag. You can reset the hash of meta tags included in logged out
  # pages:
  #   config.meta_tags_for_logged_out_pages = {}

  # == Removing Breadcrumbs
  #
  # Breadcrumbs are enabled by default. You can customize them for individual
  # resources or you can disable them globally from here.
  #
  # config.breadcrumb = false

  # == Create Another Checkbox
  #
  # Create another checkbox is disabled by default. You can customize it for individual
  # resources or you can enable them globally from here.
  #
  # config.create_another = true

  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  config.register_stylesheet 'vis-network.css'
  #
  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', media: :print
  #
  # To load a javascript file:
  config.register_javascript 'report_template.js'
  config.register_javascript 'report_query.js'

  # == Javascript for Chord diagrams
  config.register_javascript 'chord_diagram.js'
  config.register_javascript 'd3_chord/d3.layout.chord.sort.js'
  config.register_javascript 'd3_chord/d3.stretched.chord.js'

  # == CSV options
  #
  # Set the CSV builder separator
  # config.csv_options = { col_sep: ';' }
  #
  # Force the use of quotes
  # config.csv_options = { force_quotes: true }

  # == Menu System
  #
  # You can add a navigation menu to be used in your application, or configure a provided menu
  #
  # To change the default utility navigation to show a link to your website & a logout btn
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :utility_navigation do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #       admin.add_logout_button_to_menu menu
  #     end
  #   end
  #
  # If you wanted to add a static menu item to the default menu provided:
  #
  #   config.namespace :admin do |admin|

  #     admin.build_menu :default do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #     end
  #   end

  # == Download Links
  #
  # You can disable download links on resource listing pages,
  # or customize the formats shown per namespace/globally
  #
  # To disable/customize for the :admin namespace:
  #
  #   config.namespace :admin do |admin|
  #
  #     # Disable the links entirely
  #     admin.download_links = false
  #
  #     # Only show XML & PDF options
  #     admin.download_links = [:xml, :pdf]
  #
  #     # Enable/disable the links based on block
  #     #   (for example, with cancan)
  #     admin.download_links = proc { can?(:view_download_links) }
  #
  #   end

  # == Pagination
  #
  # Pagination is enabled by default for all resources.
  # You can control the default per page count for all resources here.
  #
  # config.default_per_page = 30
  #
  # You can control the max per page count too.
  #
  # config.max_per_page = 10_000

  # == Filters
  #
  # By default the index screen includes a "Filters" sidebar on the right
  # hand side with a filter for each attribute of the registered model.
  # You can enable or disable them for all resources here.
  #
  # config.filters = true

  config.before_action do
    left_sidebar! if respond_to?(:left_sidebar!)
  end
  #
  # By default the filters include associations in a select, which means
  # that every record will be loaded for each association.
  # You can enabled or disable the inclusion
  # of those filters by default here.
  #
  # config.include_default_association_filters = true

  # == Footer
  #
  # By default, the footer shows the current Active Admin version. You can
  # override the content of the footer here.
  #
  # config.footer = 'my custom footer text'

  # Creating navigation menus
  # Generate the head data menu
  def build_data_menu(namespace)
    namespace.build_menu do |menu|
      # Main drop down for all Data
      menu.add label: I18n.t("active_admin.resource_sharing"),
        priority: 1

      # Ares
      menu.add label: I18n.t("active_admin.ares.ares_menu"),
        url: :admin_ares_path,
        if: proc{ authorized?(:read, "Ares") },
        parent: I18n.t("active_admin.resource_sharing")

      # Consultation and Instruction
      menu.add label: I18n.t('active_admin.consultation.consultation_menu'),
        url: :admin_consultation_path,
        if: proc { authorized?(:read, 'Consultation') },
        parent: I18n.t('active_admin.resource_sharing')

      # EZ Proxy
      menu.add  label: I18n.t("active_admin.ezproxy.ezproxy_menu"),
        url: :admin_upenn_ezproxy_ezpaarse_jobs_path,
        if: proc{ authorized?(:read, "UpennEzproxy") },
        parent: I18n.t("active_admin.resource_sharing")

      # Gate Counts
      menu.add label: I18n.t("active_admin.gate_counts"),
        url: :admin_gatecount_path,
        if: proc{ authorized?(:read, "GateCount") },
        parent: I18n.t("active_admin.resource_sharing")

      # IPEDS
      menu.add label: I18n.t("active_admin.ipeds.ipeds_menu"),
        url: :ipeds_root_path,
        if: proc{ authorized?(:read, "Ipeds") },
        parent: I18n.t("active_admin.resource_sharing")

      # Keyserver
      menu.add label: I18n.t("active_admin.keyserver.keyserver_menu"),
        url: :admin_keyserver_path,
        if: proc{ authorized?(:read, "Keyserver") },
        parent: I18n.t("active_admin.resource_sharing")

      # Library Profiles
      menu.add label: I18n.t("active_admin.library_profiles_heading"),
        url: :admin_libraryprofile_path,
        if: proc{ authorized?(:read, "LibraryProfile") },
        parent: I18n.t("active_admin.resource_sharing")

      # RSAT Supplemental Data
      menu.add label: I18n.t("active_admin.supplemental_data"),
        url: :admin_supplementaldata_path,
        if: proc{ authorized?(:read, "SupplementalData") },
        parent: I18n.t("active_admin.resource_sharing")

      # RSAT: Borrowdirect
      menu.add label: I18n.t("active_admin.borrowdirect.borrowdirect_menu"),
        url: :borrowdirect_root_path,
        if: proc{ authorized?(:read, "Borrowdirect") },
        parent: I18n.t("active_admin.resource_sharing")

      # RSAT: ILLiad
      menu.add label: I18n.t("active_admin.illiad.illiad_menu"),
        url: :admin_illiad_path,
        if: proc{ authorized?(:read, "Illiad") },
        parent: I18n.t("active_admin.resource_sharing")

      # RSAT: PALCI
      menu.add label: I18n.t("active_admin.reshare.reshare_menu"),
        url: :admin_reshare_path,
        if: proc{ authorized?(:read, "Reshare") },
        parent: I18n.t("active_admin.resource_sharing")

    end
  end

  # Helper method to build the security drop down menu
  def build_admin_menu(namespace)
    namespace.build_menu do |menu|
      menu.add label: "Admin Users",
      url: :admin_admin_users_path,
      if: proc{ authorized?(:read, AdminUser) },
      parent: I18n.t("phrases.admin")

      # Add in Job Log information
      menu.add label: I18n.t("active_admin.log.log_menu"),
      url: :admin_log_path,
      if: proc{ authorized?(:read, "Log") },
      parent: I18n.t("phrases.admin")


      menu.add label: "User Roles",
      url: :admin_user_roles_path,
      if: proc{ authorized?(:read, Security::UserRole) },
      parent: I18n.t("phrases.admin")
    end
  end

  # Helper method to build the documentation drop down menu.
  def build_documentation_menu(namespace)
    namespace.build_menu do |menu|
      menu.add label: I18n.t("active_admin.documentation"), priority: 2 do |sites|
        sites.add label: I18n.t("active_admin.about"),
                  url: :admin_about_path

        sites.add label: I18n.t("active_admin.policies"),
                  url: :admin_policies_path

        sites.add label: I18n.t("active_admin.tutorials"),
                  url: :admin_tutorials_path
      end
    end

  end

  # Helper method to build the bookkeeping menu
  # This class may be deprecated?
  def build_bookkeeping_menu(namespace)
    namespace.build_menu do |menu|
      menu.add label: "Bookkeeping",
        url: :admin_bookkeeping_path,
        if: proc{ authorized?(:read, "Bookkeeping::DataLoad") },
        parent: I18n.t("active_admin.bookkeeping")
    end
  end

  # Helper method to build the report query menu
  def build_report_query_menu(namespace)
    namespace.build_menu do |menu|
      menu.add label: "Report Queries",
        url: :admin_report_queries_path,
        if: proc{ authorized?(:read, Report::Query) },
        parent: I18n.t("phrases.reports")

      menu.add label: "Report Templates",
        url: :admin_report_templates_path,
        if: proc{ authorized?(:read, Report::Template) },
        parent: I18n.t("phrases.reports")
    end
  end

  # Helper method to build the tools menu.
  def build_tools_menu(namespace)
    namespace.build_menu do |menu|
      menu.add label: I18n.t("active_admin.tools.file_upload_import"),
        url: :admin_tools_file_upload_imports_path,
        parent: I18n.t("phrases.tools"),
        if: proc{ authorized?(:read, Tools::FileUploadImport) }
    end
  end

  # Helper method to build the user menu
  def build_utility_navigation(namespace)
    namespace.build_menu :utility_navigation do |menu|
      user_menu = menu.add  label: proc { current_admin_user.full_name },
                            url: proc { edit_profile_admin_admin_users_url },
                            id: 'current_user',
                            if:  proc { current_active_admin_user }
      namespace.add_logout_button_to_menu user_menu, 100
    end
  end

  # Helper method to build the default menu
  def build_default_menu(namespace)
    build_utility_navigation(namespace)
    build_data_menu(namespace)
    build_admin_menu(namespace)
    build_bookkeeping_menu(namespace)
    build_report_query_menu(namespace)
    build_tools_menu(namespace)
    build_documentation_menu(namespace)

    # Add Penn Libraries Logo to menu bar
    namespace.build_menu do |menu|
      menu.add id: "penn_libraries",
      label: proc {
        image_tag(
          "penn_libraries_white.png",
          :alt => "Penn Libraries",
          :class => "penn_lib_logo"
        )
      },
      url: "https://www.library.upenn.edu/",
      priority: 99

    end
  end

  # List of namespaces that need menus
  namespaces = [:admin, :ipeds, :rsat, :borrowdirect]

  # Configure the menu for all namespaces
  namespaces.each do |namespace|
    config.namespace namespace do |space|
      build_default_menu(space)
    end
  end

  # == Sorting
  #
  # By default ActiveAdmin::OrderClause is used for sorting logic
  # You can inherit it with own class and inject it for all resources
  #
  # config.order_clause = MyOrderClause
end
