class Irm::Kanban < ActiveRecord::Base
  set_table_name :irm_kanbans
  query_extend

  attr_accessor :name,:description
  has_many :kanbans_tls, :dependent => :destroy
  has_many :kanban_ranges, :dependent => :destroy

  validates_presence_of :kanban_code
  validates_uniqueness_of :kanban_code
  acts_as_multilingual

  scope :select_all, lambda{
    select("#{table_name}.*")
  }
end