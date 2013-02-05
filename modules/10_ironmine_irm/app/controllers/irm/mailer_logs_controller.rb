class Irm::MailerLogsController < ApplicationController
  def index

  end

  def get_data
    mailer_logs_scope = Irm::MailerLog.order_by_created_at
    #根据查询参数进行搜索过滤
    mailer_logs_scope = mailer_logs_scope.match_value("#{Irm::MailerLog.table_name}.reference_target", params[:reference_target])
    mailer_logs_scope = mailer_logs_scope.match_value("#{Irm::MailerLog.table_name}.to_params", params[:to_params])
    mailer_logs_scope = mailer_logs_scope.match_value("#{Irm::MailerLog.table_name}.template_code", params[:template_code])
    mailer_logs_scope = mailer_logs_scope.match_value("#{Irm::MailerLog.table_name}.send_at", params[:send_at])

    @mailer_logs, count = paginate(mailer_logs_scope)
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