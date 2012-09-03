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

  def self.list_all
    select("#{table_name}.*").with_bo(I18n.locale).with_mail_template(I18n.locale)
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
    person_ids.uniq
  end

  def perform(bo)
    recipient_ids = self.all_recipients(bo)
    # template params
    params = {:object_params=>Irm::BusinessObject.liquid_attributes(bo,true)}
    # mail options
    mail_options = {}
    mail_options.merge!(:from=>self.from_email) if self.from_email.present?
    mail_options.merge!(:message_id=>Irm::BusinessObject.mail_message_id(bo,"mailalert"))
    params.merge!(:mail_options=>mail_options)

    # header options
    header_options = {}
    header_options.merge!({"References"=>Irm::BusinessObject.mail_message_id(self)})
    params.merge!(:header_options=>header_options)

    # template 　
    mail_template = Irm::MailTemplate.query_by_template_code(self.mail_template_code).first

    # loop send mail
    bo_create_by = bo.respond_to?(:created_by)? bo.created_by : "nocreatedby" # do not send to creater
    recipient_ids.each do |pid|
      next if pid.eql?(bo_create_by)     # do not send to creater
      mail_template.deliver_to(params.merge(:to_person_ids=>[pid]))
    end
  end


end
