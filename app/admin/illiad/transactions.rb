ActiveAdmin.register Illiad::Transaction,
as: "Transaction",
namespace: :illiad do
  menu false

  permit_params :institution_id, :billing_amount, :call_number, :cited_in,
  :esp_number, :ifm_cost, :in_process_date, :issn, :lender_codes,
  :lending_library, :loan_author, :loan_date, :loan_edition, :loan_location,
  :loan_publisher, :loan_title, :location, :photo_article_author,
  :photo_article_title, :photo_journal_inclusive_pages, :photo_journal_issue,
  :photo_journal_month, :photo_journal_title, :photo_journal_volume,
  :photo_journal_year, :process_type, :reason_for_cancellation, :request_type,
  :system_id, :transaction_date, :transaction_number, :transaction_status,
  :user_id, :borrower_nvtgc, :original_nvtgc

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
end
