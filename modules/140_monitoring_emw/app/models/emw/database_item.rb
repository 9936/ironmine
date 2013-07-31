class Emw::DatabaseItem < ActiveRecord::Base
  set_table_name :emw_database_items

  belongs_to :database_item, :foreign_key => :database_id
  validates :name,:script,:script_type, :presence => true

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :query_by_database, lambda {|database_id|
    where("#{table_name}.database_id=?", database_id)
  }

  #获取执行的脚本
  def get_execute_script
    self.script
  end
end
