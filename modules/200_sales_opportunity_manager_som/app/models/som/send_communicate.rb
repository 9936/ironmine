class Som::SendCommunicate < ActiveRecord::Base
  set_table_name 'som_send_communicates'
  acts_as_timetrigger
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  def perform
    #生成沟通报表附件
    xls=Som::CommunicateInfo.send_my_communicate(self.person_id,self.last_interval)
    #没有符合条件的沟通报表,不发送邮件
    unless xls.nil?
      tmp_folder = "#{Rails.root.to_s}/tmp/som/xls"
      file_name="/#{Time.now.strftime('%Y%m%d%H%M%S')}.xls"
      FileUtils.mkdir_p(tmp_folder, :mode => 0777) unless File.exist?(tmp_folder)
      save_path = tmp_folder+file_name
      File.open(save_path, 'wb') do |file|
        file << xls
      end

      params = {}
      # 加入附件信息
      mail_options = {}
      mail_options.merge!(:attachment=>file_name)
      params.merge!(:mail_options=>mail_options)
      #获取模板
      mail_template = Irm::MailTemplate.query_by_template_code('SOM_SEND_COMMUNICATE').first

      #记录到邮件发送日志表
      logger_options = {
          :reference_target => "BUSINESS_OBJECT:#{params}",
          :template_code => 'SOM_SEND_COMMUNICATE'
      }
      mail_template.deliver_to(params.merge(:to_person_ids => self.person_id,:logger_options => logger_options))
    end
  end
end
