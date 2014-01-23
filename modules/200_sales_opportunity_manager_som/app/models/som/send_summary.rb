class Som::SendSummary < ActiveRecord::Base
  set_table_name 'som_send_summaries'
  acts_as_timetrigger
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  def self.sales_summary_notify
    self.where(:summary_type=>"SOM_SALES_SUMMARY_NOTIFY").first||self.new(:summary_type=>"SOM_SALES_SUMMARY_NOTIFY")
  end

  def self.sales_communicate_notify
    self.where(:summary_type=>"SOM_SALES_COMMUNICATE_NOTIFY").first||self.new(:summary_type=>"SOM_SALES_COMMUNICATE_NOTIFY")
  end

  def self.sales_opportunity_notify
    self.where(:summary_type=>"SOM_SALES_OPPORTUNITY_NOTIFY").first||self.new(:summary_type=>"SOM_SALES_OPPORTUNITY_NOTIFY")
  end

  def perform
    #取得所有销售负责人
    person_ids = Som::SalesOpportunity.select("charge_person").collect{|i| i.charge_person}
    return unless person_ids.any?
    #Irm::Person.current = Irm::Person.find(person_ids.first)
    #启用服务
    if self.summary_enable_flag.eql?('Y')||self.summary_enable_flag.eql?('1')
      #生成汇总报表附件
      xls=Som::SalesOpportunity.send_summary_data
      file_name="#{Time.now.strftime('%Y%m%d%H%M%S')}.xls"

      #向邮件模板传送时间
      bo=Som::SalesOpportunity.new
      bo.created_at=Time.now.strftime('%Y-%m-%d')
      params = {:object_params=>Irm::BusinessObject.liquid_attributes(bo,true)}

      # 加入附件信息
      mail_options = {:attachments=>{}}
      mail_options[:attachments][file_name] =xls
      params.merge!(:mail_options=>mail_options)

      #获取模板
      mail_template = Irm::MailTemplate.query_by_template_code('SALES_OPPORTUNITY_SUMMARY').first

      #记录到邮件发送日志表
      logger_options = {
          :reference_target => "BUSINESS_OBJECT:#{params}",
          :template_code => 'SALES_OPPORTUNITY_SUMMARY'
      }
      mail_template.deliver_to(params.merge(:to_person_ids => person_ids,:logger_options => logger_options))
      #Delayed::Worker.logger.debug("---------------------SendSummary-#{Time.now}--------------------")
    end
  end
end
