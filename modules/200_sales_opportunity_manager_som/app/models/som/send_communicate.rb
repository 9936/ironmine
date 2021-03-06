class Som::SendCommunicate < ActiveRecord::Base
  set_table_name 'som_send_communicates'
  acts_as_timetrigger
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  def perform
    #取得所有销售负责人
    person_ids = Som::SalesOpportunity.select("charge_person").collect { |i| i.charge_person }
    return unless person_ids.any?
    person_ids.each do |person_id|
      #启用服务
      if self.communicate_enable_flag.eql?('Y')||self.communicate_enable_flag.eql?('1')
        #生成沟通报表附件
        xls, count=Som::CommunicateInfo.send_my_communicate(person_id, self.last_interval)
        #没有符合条件的沟通报表,不发送邮件
        unless xls.nil?
          file_name="#{Time.now.strftime('%Y%m%d%H%M%S')}.xls"

          #向邮件模板传送时间和需要沟通的预销售个数
          bo=Som::SalesOpportunity.new
          bo.created_at=Time.now.strftime('%Y-%m-%d')
          bo.content= count
          params = {:object_params => Irm::BusinessObject.liquid_attributes(bo, true)}

          # 加入附件信息
          mail_options = {:attachments=>{}}
          mail_options[:attachments][file_name] =xls
          params.merge!(:mail_options=>mail_options)

          #获取模板
          mail_template = Irm::MailTemplate.query_by_template_code('SALES_OPPORTUNITY_COMMUNICATE').first

          #记录到邮件发送日志表
          logger_options = {
              :reference_target => "BUSINESS_OBJECT:#{params}",
              :template_code => 'SALES_OPPORTUNITY_COMMUNICATE'
          }
          mail_template.deliver_to(params.merge(:to_person_ids => person_id, :logger_options => logger_options))
        end
      end
    end
  end
end
