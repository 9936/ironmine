class ReportMailer < ActionMailer::Base
  default :from => Irm::MailManager.default_email_from
  helper "irm/reports"

  def report_email(report_id,report_schedule_id,mail_options)

    @report = Irm::Report.multilingual.find(report_id)

    if @report.filter_date_range_type.present? and !@report.filter_date_range_type.to_s.eql?('CUSTOM')
      from_and_to = Irm::ConvertTime.convert(@report.filter_date_range_type)
      @report.filter_date_from = from_and_to[:from]
      @report.filter_date_to = from_and_to[:to]
    end
    @report_schedule = Irm::ReportSchedule.find(report_schedule_id)
    send_options = mail_options
    subject = "#{@report[:name]}-#{@report_schedule.run_at.strftime('%Y-%m-%d %H:%M:%S')}"
    send_options.merge!(:subject=>subject)
    mail(send_options) do |format|
      format.html
    end
  end
end
