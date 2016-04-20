class Irm::WfMailAlert < ActiveRecord::Base
  set_table_name :irm_wf_mail_alerts

  has_many :wf_mail_recipients

  attr_accessor :recipient_str
  validates_presence_of :mail_alert_code,:name,:bo_code,:mail_template_code
  validates_uniqueness_of :mail_alert_code, :if => Proc.new { |i| !i.mail_alert_code.present? }
  validates_uniqueness_of :name, :if => Proc.new { |i| !i.name.present? }
  validates_format_of :mail_alert_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.mail_alert_code.present?},:message=>:code

  acts_as_urlable
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_bo,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} bo ON bo.business_object_code = #{table_name}.bo_code and bo.language='#{language}'").
    select("bo.name bo_name")
  }

  scope :with_mail_template,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::MailTemplate.view_name} mt ON mt.template_code = #{table_name}.mail_template_code and mt.language='#{language}'").
    select("mt.name mail_template_name")
  }

  scope :with_language,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Language.view_name} ON #{Irm::Language.view_name}.language_code=#{table_name}.language_code AND #{Irm::Language.view_name}.language = '#{language}'").
        select("#{Irm::Language.view_name}.description language_description")
  }

  def self.list_all
    select("#{table_name}.*").with_language(I18n.locale).with_bo(I18n.locale).with_mail_template(I18n.locale)
  end


  def sync_mail_recipients(code_array)
    code_array.values.each do |code|
      type_and_id = code.split("#")
      next unless type_and_id.size==2
      recipient = self.wf_mail_recipients.build(:bo_code=>self.bo_code,:recipient_type=>type_and_id[0],:recipient_id=>type_and_id[1])
      recipient.destroy  unless  recipient.valid?
    end
  end

  # create approver from str
  def create_recipient_from_str
    return unless self.recipient_str
    str_values = self.recipient_str.split(",").delete_if{|i| !i.present?}
    exists_values = Irm::WfMailRecipient.where(:wf_mail_alert_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.recipient_type}##{value.recipient_id}")
        str_values.delete("#{value.recipient_type}##{value.recipient_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.wf_mail_recipients.build(:bo_code=>self.bo_code,:recipient_type=>value[0],:recipient_id=>value[1])
    end
  end

  def get_recipient_str
    return @get_recipient_str if @get_recipient_str
    @get_recipient_str||= recipient_str
    @get_recipient_str||= Irm::WfMailRecipient.where(:wf_mail_alert_id=>self.id).collect{|value| "#{value.recipient_type}##{value.recipient_id}"}.join(",")
  end

  # step approvers
  def all_recipients(bo)
    person_ids = []
    person_ids += Irm::WfMailRecipient.where(:wf_mail_alert_id=>self.id).query_person_ids.collect{|i| i[:person_id]}

    Irm::WfMailRecipient.bo_attribute(self.id).each do |recipient|
      person_ids += recipient.person_ids(bo)
    end if bo.present?

    Irm::WfMailRecipient.bo_attribute1(self.id).each do |recipient|
      # 如果角色不是项目经理
      if !recipient.recipient_id.eql? "002N000B2kHazVX1VOtts8"
      person_ids += Irm::Person.where(:role_id=>recipient.recipient_id).collect{|i|
        if i.system_ids.index(bo.external_system_id)
          i[:id]
        end
      }
      else # 如果角色是项目经理则获取该事故单的项目经理id
        external_system = Irm::ExternalSystem.find(bo.external_system_id)
        if external_system.allow_notice_flag.eql? "Y"
          project_manager = external_system.project_manager
          if !project_manager.eql? ""
            login_name = project_manager.split("(")[1].split(")")[0]
            person_ids += Irm::Person.where(:login_name => login_name).collect{|i| i[:id]}
          end
        end
      end
    end if bo.present?

    person_ids.delete(nil)
    person_ids.uniq
  end

  def perform(bo)
    recipient_ids = self.all_recipients(bo)
    temp_recipient_ids = recipient_ids
    # template params
    current_locale = I18n.locale
    current_time_zone = Time.zone
    params = {:object_params=>Irm::BusinessObject.liquid_attributes(bo,true)}
    # mail options
    mail_options = {}
    mail_options.merge!(:from=>self.from_email) if self.from_email.present?
    mail_options.merge!(:message_id=>Irm::BusinessObject.mail_message_id(bo,"mailalert"))
    params.merge!(:mail_options=>mail_options)
    params.merge!(:requested_by=>bo.requested_by) if bo.class.to_s.eql?"Icm::IncidentRequest"
    params.merge!(:requested_by=>Icm::IncidentRequest.find(bo.incident_request_id).requested_by) if bo.class.to_s.eql?"Icm::IncidentJournal"

    # header options
    header_options = {}
    mail_message_id = Irm::BusinessObject.mail_message_id(self)
    header_options.merge!({"References"=>mail_message_id })
    params.merge!(:header_options=>header_options)

    # template 　
    mail_template = Irm::MailTemplate.query_by_template_code(self.mail_template_code).first

    # 如果邮件不是用于新建则不提醒Hotline
    if !self.mail_template_code.eql?("CREATE_INCIDENT_REQUEST") && !self.mail_template_code.eql?("WARNING_HOTLINE") && !self.mail_template_code.eql?("TIMEOUT_NEW")
      temp_person_ids = []
      recipient_ids.each do |r|
        temp_person = Irm::Person.with_role.find(r)
        if temp_person[:role_name].eql?("HOTLINE")
          temp_person_ids << r
        end
      end
      recipient_ids = recipient_ids - temp_person_ids
    end
    # 如果邮件是内部回复产生的则筛选掉客户
    if self.mail_alert_code.eql?("INNER_REPLY_NOTIC")
      temp_person_ids = []
      recipient_ids.each do |r|
        temp_person = Irm::Person.find(r)
        if temp_person.profile.user_license.eql?("REQUESTER")
          temp_person_ids << r
        end
      end
      recipient_ids = recipient_ids - temp_person_ids
    end
    # loop send mail
    # bo_update_by = bo.respond_to?(:updated_by)? bo.created_by : "nocreatedby" # do not send to creater
    bo_update_by = bo.respond_to?(:updated_by)? bo.updated_by : "noupdatedby"

    recipient_ids.delete_if{|i| i.eql?(bo_update_by)}

    #记录到邮件发送日志表
    logger_options = {
        :reference_target => "BUSINESS_OBJECT:#{params}",
        :template_code => self.mail_template_code
    }

    if temp_recipient_ids.any?
    # return unless recipient_ids.any?

      #检查是否需要进行合并发送
      if self.all_flag.eql?(Irm::Constant::SYS_YES)
        # 按第一个收件者的语言,时区设定标准 语言,时区
        person = Irm::Person.query(recipient_ids.first||"empty").first
        unless person.language_code.to_s.eql?(I18n.locale.to_s)&&person.time_zone.eql?(Time.zone)
          I18n.locale =  person.language_code
          Time.zone = person.time_zone
          params[:object_params] = Irm::BusinessObject.liquid_attributes(bo,true)
        end
        #合并发送中是否设置了模板语言
        if self.language_code
          mail_template.deliver_to(params.merge(:to_person_ids => recipient_ids,:template_lang => self.language_code, :logger_options => logger_options ))
        else
          mail_template.deliver_to(params.merge(:to_person_ids => recipient_ids,:logger_options => logger_options))
        end
      else
        recipient_ids.each do |pid|
          person = Irm::Person.find(pid)
          unless person.language_code.to_s.eql?(I18n.locale.to_s)&&person.time_zone.eql?(Time.zone)
            I18n.locale =  person.language_code
            Time.zone = person.time_zone
            params[:object_params] = Irm::BusinessObject.liquid_attributes(bo,true)
          end
          mail_template.deliver_to(params.merge(:to_person_ids => [pid], :logger_options => logger_options))
        end
      end
    else
      person = Irm::Person.current
      I18n.locale =  person.language_code
      Time.zone = person.time_zone
      params[:object_params] = Irm::BusinessObject.liquid_attributes(bo,true)
      mail_template.deliver_to(params.merge(:logger_options => logger_options))
    end

    I18n.locale =  current_locale
    Time.zone = current_time_zone
  end


end
