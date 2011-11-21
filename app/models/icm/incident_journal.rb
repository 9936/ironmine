class Icm::IncidentJournal < ActiveRecord::Base
  set_table_name :icm_incident_journals

  belongs_to :incident_request

  after_save :process_after_save

  has_many :incident_histories,:foreign_key => "journal_id"

  validates_presence_of :replied_by
  validate :validate_message_body
  acts_as_recently_objects(:title => "title",
                           :target => "incident_request",
                           :target_controller => "icm/incident_journals",
                           :target_action => "new",
                           :target_id => "id",
                           :target_id_column => "request_id")

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  # 查询出提交人
  scope :with_replied_by,lambda{
    joins("JOIN #{Irm::Person.table_name} replied ON  replied.id = #{table_name}.replied_by").
    select("#{Irm::Person.name_to_sql(nil,'replied','replied_name')},replied.avatar_file_name ,replied.avatar_updated_at")
  }

  scope :with_replied_profile,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Profile.view_name} ON #{Irm::Profile.view_name}.id = replied.profile_id AND #{Irm::Profile.view_name}.language = '#{language}'").
    select("#{Irm::Profile.view_name}.name profile_name,#{Irm::Profile.view_name}.code profile_code,#{Irm::Profile.view_name}.user_license")
  }

  scope :query_by_request,lambda{|request_id|
    select("#{table_name}.*").where(:incident_request_id => request_id)
  }

  scope :select_all,lambda{select("#{table_name}.*")}

  scope :default_order,lambda{order("#{table_name}.created_at")}

  def self.list_all(request_id)
    query_by_request(request_id).with_replied_by
  end

  def self.generate_journal(incident_request,request_attributes,journal_attributes)
    incident_request_bak = incident_request.dup
    incident_journal = incident_request.incident_journals.build(journal_attributes)
    return nil unless incident_request.update_attributes(request_attributes)
    request_attributes.each do |key,value|
        ovalue = incident_request_bak.send(key)
        nvalue = incident_request.send(key)
          Icm::IncidentHistory.create({:journal_id=>incident_journal.id,
                                       :property_key=>key.to_s,
                                       :old_value=>ovalue,
                                       :new_value=>nvalue}) if !ovalue.eql?(nvalue)
    end
    return incident_journal
  end


  def watcher_person_ids
    self.incident_request.watcher_person_ids
  end

  private
  #
  def process_after_save
    last_journal = self.class.where("incident_request_id =? AND created_at < ?",self.incident_request_id,self.created_at).order("created_at desc").first
    current_journal = self.class.with_replied_by.with_replied_profile(I18n.locale).find(self.id)
    incident_request_attributes = {}
    case self.reply_type
      when "CUSTOMER_REPLY"
        incident_request_attributes[:last_request_date] = Time.now
        incident_request_attributes[:next_reply_user_license] = "SUPPORTER"
      when "SUPPORTER_REPLY"
        incident_request_attributes[:last_response_date] = Time.now
        incident_request_attributes[:next_reply_user_license] = "REQUESTER"
      when "PASS"
        incident_request_attributes[:last_response_date] = Time.now
        incident_request_attributes[:next_reply_user_license] = "SUPPORTER"
      when "UPGRADE"
        incident_request_attributes[:last_response_date] = Time.now
        incident_request_attributes[:next_reply_user_license] = "SUPPORTER"
      when "CLOSE"
        incident_request_attributes[:last_response_date] = Time.now
        incident_request_attributes[:next_reply_user_license] = "SUPPORTER"
      when "ASSIGN"
        incident_request_attributes[:last_response_date] = Time.now
        incident_request_attributes[:next_reply_user_license] = "SUPPORTER"

    end
    incident_request.update_attributes(incident_request_attributes)

    incident_histories = Icm::IncidentHistory.where(:journal_id=>incident_journal.id)

    elapse_options = {:incident_status_id=>incident_request.incident_status_id,:support_group_id=>incident_request.support_group_id}

    status_change_history = incident_histories.detect{|i| i.property_key.eql?("incident_status_id")}

    if status_change_history
      elapse_options.merge!({:incident_status_id=>status_change_history.old_value})
    end

    support_group_change_history = incident_histories.detect{|i| i.property_key.eql?("support_group_id")}

    if support_group_change_history
      elapse_options.merge!({:support_group_id=>support_group_change_history.old_value})
    end

    if last_journal
      Icm::IncidentJournalElapse.create(({:incident_journal_id=>self.id,:elapse_type=>self.reply_type,:start_at=>last_journal.created_at,:end_at=>self.created_at}).merge(elapse_options))
    else
      Icm::IncidentJournalElapse.create(({:incident_journal_id=>self.id,:elapse_type=>self.reply_type,:start_at=>incident_request.created_at,:end_at=>self.created_at}).merge(elapse_options))
    end
  end

  def validate_message_body
    str = Irm::Sanitize.sanitize(self.message_body,'').strip
    if !str.present?||(str.length==1&&str.bytes.to_a.eql?([226, 128, 139]))
      self.errors.add(:message_body,I18n.t(:label_icm_incident_journal_message_body_not_blank))
    end
  end

end
