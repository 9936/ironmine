class Irm::MailerLogsController < ApplicationController
  def index

  end

  def get_data
    @mailer_logs = Irm::MailerLog.order_by_created_at
    @mailer_logs, count = paginate(@mailer_logs)
    respond_to do |format|
      format.html  {
        @count = count
        @datas =@mailer_logs
      }
    end
  end

  def clear_logs
    time_period = params[:time_period]
    if time_period.present?
      if time_period.eql?('ALL')
        Irm::MailerLog.unscoped.delete_all
      else
        time_period = hand_period(time_period)
        Irm::MailerLog.unscoped.where("created_at <?", time_period).find_each(&:destroy)
      end

    end
    redirect_to({:action => "index"})
  end
end