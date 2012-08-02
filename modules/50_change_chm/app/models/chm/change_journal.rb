class Chm::ChangeJournal < ActiveRecord::Base
  set_table_name :chm_change_journals

  belongs_to :change_request

  validates_presence_of :replied_by

  validate :validate_message_body


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  # 查询出提交人
  scope :with_replied_by,lambda{
    joins("JOIN #{Irm::Person.table_name} replied ON  replied.id = #{table_name}.replied_by").
    select("#{Irm::Person.name_to_sql(nil,'replied','replied_name')},replied.avatar_file_name ,replied.avatar_updated_at")
  }


  scope :query_by_request,lambda{|request_id|
    select("#{table_name}.*").where(:change_request_id => request_id)
  }


  scope :default_order,lambda{order("#{table_name}.created_at")}

  def self.list_all
    select_all.with_replied_by
  end


  private

  def validate_message_body
    str = Irm::Sanitize.sanitize(self.message_body,'').strip
    if !str.present?||(str.length==1&&str.bytes.to_a.eql?([226, 128, 139]))
      self.errors.add(:message_body,I18n.t(:label_icm_incident_journal_message_body_not_blank))
    end
  end

end
