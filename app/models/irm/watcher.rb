class Irm::Watcher < ActiveRecord::Base
  set_table_name :irm_watchers

  belongs_to :watchable, :polymorphic => true
  belongs_to :member,:polymorphic => true

  query_extend

  validates_uniqueness_of :member_id, :scope => [:member_type,:watchable_type, :watchable_id]

  scope :with_person,lambda{
    joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{table_name}.member_id").
        where("#{table_name}.member_type = ? ",Irm::Person.name).
        select("#{Irm::Person.table_name}.full_name person_name,#{Irm::Person.table_name}.id person_id")
  }
end