ActiveAdmin.register Illiad::Transaction do
  menu false
  permit_params :institution_id, :billing_amount, :call_number, :cited_in, :esp_number, :ifm_cost, :in_process_date, :issn, :lender_codes, :lending_library, :loan_author, :loan_date, :loan_edition, :loan_location, :loan_publisher, :loan_title, :location, :photo_article_author, :photo_article_title, :photo_journal_inclusive_pages, :photo_journal_issue, :photo_journal_month, :photo_journal_title, :photo_journal_volume, :photo_journal_year, :process_type, :reason_for_cancellation, :request_type, :system_id, :transaction_date, :transaction_number, :transaction_status, :user_id, :borrower_nvtgc, :original_nvtgc
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :billing_amount, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :call_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :cited_in, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :esp_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ifm_cost, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :in_process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :issn, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lender_codes, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lending_library, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :loan_author, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :loan_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :loan_edition, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :loan_location, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :loan_publisher, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :loan_title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :location, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_article_author, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_article_title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_journal_inclusive_pages, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_journal_issue, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_journal_month, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_journal_title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_journal_volume, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :photo_journal_year, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :reason_for_cancellation, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :system_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_status, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :user_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :borrower_nvtgc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :original_nvtgc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
