class Irm::ProfileKanban < ActiveRecord::Base
  set_table_name :irm_profile_kanbans
  belongs_to :kanban
  belongs_to :profile

  validates_uniqueness_of :position_code, :scope => :profile_id
  validates_presence_of :position_code
  validates_presence_of :kanban_id
  validates_numericality_of :limit
  validates_numericality_of :refresh_interval

  query_extend

  scope :with_position_name, lambda{
    joins(",#{Irm::LookupValue.view_name} lv").
        where("lv.lookup_code = #{table_name}.position_code").
        where("lv.language=?", I18n.locale).
        select("lv.meaning position_name")
  }

  scope :select_all, lambda{
    select("#{table_name}.*")
  }
end