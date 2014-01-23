class Som::SendSummary < ActiveRecord::Base
  set_table_name 'som_send_summaries'
  acts_as_timetrigger
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  def self.sales_summary_notify
    self.where(:summary_type => "SOM_SALES_SUMMARY_NOTIFY").first||self.new(:summary_type => "SOM_SALES_SUMMARY_NOTIFY")
  end

  def self.sales_communicate_notify
    self.where(:summary_type => "SOM_SALES_COMMUNICATE_NOTIFY").first||self.new(:summary_type => "SOM_SALES_COMMUNICATE_NOTIFY")
  end

  def self.sales_opportunity_notify
    self.where(:summary_type => "SOM_SALES_OPPORTUNITY_NOTIFY").first||self.new(:summary_type => "SOM_SALES_OPPORTUNITY_NOTIFY")
  end

  def perform
    case self.summary_type
      when "SOM_SALES_SUMMARY_NOTIFY"
        send_summary_report
      when "SOM_SALES_COMMUNICATE_NOTIFY"
        send_communicate_report
      when "SOM_SALES_OPPORTUNITY_NOTIFY"
        send_opportunity_report
    end
  end


  #汇总信息报表
  def send_summary_report
    #取得所有销售负责人
    person_ids = Som::SalesOpportunity.select("charge_person").collect { |i| i.charge_person }
    return unless person_ids.any?
    #启用服务
    if self.summary_enable_flag.eql?('Y')
      #生成报表信息
      html=Som::SalesOpportunity.send_summary_data

      #向邮件模板传送时间和html格式的报表内容
      bo=Som::SalesOpportunity.new
      bo.created_at=Time.now.strftime('%Y-%m-%d')
      bo.content=html
      params = {:object_params => Irm::BusinessObject.liquid_attributes(bo, true)}

      #获取模板
      mail_template = Irm::MailTemplate.query_by_template_code('SALES_OPPORTUNITY_SUMMARY').first

      #记录到邮件发送日志表
      logger_options = {
          :reference_target => "BUSINESS_OBJECT:#{params}",
          :template_code => 'SALES_OPPORTUNITY_SUMMARY'
      }
      mail_template.deliver_to(params.merge(:to_person_ids => person_ids, :logger_options => logger_options))
      #Delayed::Worker.logger.debug("---------------------SendSummary-#{Time.now}--------------------")
    end
  end

  #沟通销售报表
  def send_communicate_report
    #取得所有销售负责人
    person_ids = Som::SalesOpportunity.select("charge_person").collect { |i| i.charge_person }
    return unless person_ids.any?
    person_ids.each do |person_id|
      #启用服务
      if self.summary_enable_flag.eql?('Y')
        #生成沟通报表附件
        html, count=Som::CommunicateInfo.send_my_communicate(person_id, self.communicate_interval)
        #没有符合条件的沟通报表,不发送邮件
        unless html.nil?

          #向邮件模板传送时间和需要沟通的预销售个数
          bo=Som::SalesOpportunity.new
          bo.created_at=Time.now.strftime('%Y-%m-%d')
          bo.region= count
          bo.content= html
          params = {:object_params => Irm::BusinessObject.liquid_attributes(bo, true)}

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

  #销售信息明细报表
  def send_opportunity_report
    #取得所有销售负责人
    person_ids = Som::SalesOpportunity.select("charge_person").collect { |i| i.charge_person }
    return unless person_ids.any?
    #启用服务
    if self.summary_enable_flag.eql?('Y')
      #生成报表信息
      html=Som::SalesOpportunity.send_opportunity_data

      #向邮件模板传送时间和html格式的报表内容
      bo=Som::SalesOpportunity.new
      bo.created_at=Time.now.strftime('%Y-%m-%d')
      bo.content=html
      params = {:object_params => Irm::BusinessObject.liquid_attributes(bo, true)}

      #获取模板
      mail_template = Irm::MailTemplate.query_by_template_code('SALES_OPPORTUNITY').first

      #记录到邮件发送日志表
      logger_options = {
          :reference_target => "BUSINESS_OBJECT:#{params}",
          :template_code => 'SALES_OPPORTUNITY'
      }
      mail_template.deliver_to(params.merge(:to_person_ids => person_ids, :logger_options => logger_options))
      #Delayed::Worker.logger.debug("---------------------SendSummary-#{Time.now}--------------------")
    end
  end
end
