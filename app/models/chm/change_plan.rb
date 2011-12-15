class Chm::ChangePlan < ActiveRecord::Base
  set_table_name :chm_change_plans

  belongs_to :change_request

  belongs_to :change_plan_type


  validates_presence_of :planed_by

  validate :validate_plan_body


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  # 查询出提交人
  scope :with_planed_by,lambda{
    joins("JOIN #{Irm::Person.table_name} planed_by ON  planed_by.id = #{table_name}.planed_by").
    select("planed_by.full_name planed_by_name,planed_by.avatar_file_name ,planed_by.avatar_updated_at")
  }


  scope :query_by_request,lambda{|request_id|
    where(:change_request_id => request_id)
  }


  scope :default_order,lambda{order("#{table_name}.created_at")}

  def self.list_all
    select_all.with_planed_by
  end

  def attachments
    Irm::AttachmentVersion.where(:source_type=>self.class.name,:source_id=>self.id)
  end


  private

  def validate_plan_body
    str = Irm::Sanitize.sanitize(self.plan_body,'').strip
    if !str.present?||(str.length==1&&str.bytes.to_a.eql?([226, 128, 139]))
      self.errors.add(:plan_body,I18n.t(:label_icm_incident_journal_message_body_not_blank))
    end
  end

end
