class Irm::ProfileKanban < ActiveRecord::Base
  set_table_name :irm_profile_kanbans
  belongs_to :kanban
  belongs_to :profile

  validates_presence_of :kanban_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  scope :with_kanban, lambda{
    joins(",#{Irm::Kanban.view_name} kb").
        where("kb.id = #{table_name}.kanban_id").
        where("kb.language = ?", I18n.locale).
        select("kb.position_code position")
  }

  scope :query_by_position_and_profile, lambda{|position_code, profile_id|
    joins(",#{Irm::Kanban.view_name} kb").
        where("kb.id = #{table_name}.kanban_id").
        where("kb.language = ?", I18n.locale).
        where("kb.position_code=?", position_code).
        where("#{table_name}.profile_id =?", profile_id).
        select("kb.position_code position, kb.name kanban_name, kb.description kanban_description").
        select("kb.limit limit, kb.refresh_interval ")
  }

  def self.check_exists(profile_id, kanban_id, position_code)
    profile_kanbans = Irm::ProfileKanban.
        select_all.
        with_kanban.
        where("#{table_name}.profile_id = ?", profile_id).where("kb.position_code = ?", position_code)
    return profile_kanbans.first if profile_kanbans.any?
    false
  end
end