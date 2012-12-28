class Irm::MailerLogsController < ApplicationController
  def index

  end

  def get_data
    @mailer_logs = Irm::MailerLog
    @mailer_logs, count = paginate(@mailer_logs)
    respond_to do |format|
      format.html  {
        @count = count
        @datas =@mailer_logs
      }
    end
  end
end