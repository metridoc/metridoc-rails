ActiveAdmin.register Keyserver::ProductUsage,
namespace: :keyserver do
  menu false
  actions :all, :except => [:new, :create, :edit, :update, :destroy]

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end

    # Set the title on the index page
  index title: "Product Usage" do

    id_column
    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if c == "id"

      case c
      when "duration"
        column :duration do |session|
          ActiveSupport::Duration.build(session.duration).iso8601
        end
      when "foreground"
        column :foreground do |session|
          ActiveSupport::Duration.build(session.foreground).iso8601
        end
      else
        column c.to_sym
      end
    end

    actions
  end
  
end