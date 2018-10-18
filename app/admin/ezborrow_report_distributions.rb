ActiveAdmin.register Ezborrow::ReportDistribution do
  menu false
  permit_params :email_addr, :institution_id, :ezb_report_distribution_id, :version, :library_id
end