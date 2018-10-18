ActiveAdmin.register Borrowdirect::ReportDistributionTmp do
  menu false
  permit_params :email_addr, :institution_id, :bd_report_distribution_tmp_id, :version, :library_id
end