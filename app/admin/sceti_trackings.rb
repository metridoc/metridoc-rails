ActiveAdmin.register Sceti::Tracking do
  menu false
  permit_params :date_received_in_sceti, :date_returned, :deadline, :remove_from_project, :mms, :ark, :images, :pages_to_digitize, :file_location, :title, :patron_name, :sceti_project_id, :condition_notes, :general_notes, :qa, :imaged_by, :imaged_date, :uploaded_to_colenda_by, :uploaded_to_colenda_date, :qa_by, :qa_date, :metadata_created_by, :metadata_created_date, :web_qa_by, :web_qa_date

  index do
    column "Tracking ID", :id
    column :project
    column :title
    column :patron_name
    column :date_received_in_sceti
    column :date_returned
    column :deadline
    column "MMS ID", :mms
    column "ARK ID",:ark
    column "Image Count", :images
    column :pages_to_digitize
    column :file_location
    column :condition_notes
    column :general_notes
    column "QA", :qa
    column "QA By", :qa_by
    column "QA Date", :qa_date
    column :imaged_by
    column :imaged_date
    column :uploaded_to_colenda_by
    column :uploaded_to_colenda_date
    column :metadata_created_by
    column :metadata_created_date
    column :remove_from_project
    actions
  end

  filter :project
  filter :date_received_in_sceti
  filter :date_returned
  filter :deadline
  filter :remove_from_project
  filter :title
  filter :patron_name
  filter :qa
  filter :imaged_by
  filter :uploaded_to_colenda_by
  filter :qa_by
  filter :metadata_created_by
end
