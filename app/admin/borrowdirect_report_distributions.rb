ActiveAdmin.register Borrowdirect::ReportDistribution do
  menu false
  permit_params :email_addr, :institution_id, :bd_report_distribution_id, :version, :library_id
end