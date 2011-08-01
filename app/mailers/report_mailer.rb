class ReportMailer < ActionMailer::Base
  default :from => Irm::MailManager.default_email_from
  helper "irm/reports"

  def report_email(report_id,report_schedule_id,mail_options)

    @report = Irm::Report.multilingual.find(report_id)
    @report_schedule = Irm::ReportSchedule.find(report_schedule_id)
    send_options = mail_options
    subject = "#{@report[:name]}-#{@report_schedule.run_at.strftime('%Y-%m-%d %H:%M:%S')}"
    send_options.merge!(:subject=>subject)
    mail(send_options) do |format|
      format.html
    end
  end
end
