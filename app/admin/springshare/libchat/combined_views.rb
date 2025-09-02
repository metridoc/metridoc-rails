ActiveAdmin.register Springshare::Libchat::CombinedView,
as: "Libchat::CombinedView",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibChat', :springshare_libchat)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Combined View" do
        id_column
    # Loop through the columns and truncate the bib record for the index only
    self.resource_class.column_names.each do |c|
      next if c == "chat_id"

      if c == "initial_question"
        column c.to_sym do |pr|
          pr.initial_question.truncate 50 unless pr.initial_question.nil?
        end
      else 
        column c.to_sym
      end

    end
    actions

  end
end