class ReportQueryMailer < ApplicationMailer

  def started_notice
    @report_query = params[:report_query]
    @owner = @report_query.owner
    mail(to: @owner.email, subject: 'File Export Started')
  end

  def finished_notice
    @report_query = params[:report_query]
    @owner = @report_query.owner
    mail(to: @owner.email, subject: 'File Export Finished')
  end

end
