class Emw::Database < ActiveRecord::Base
  set_table_name :emw_databases

  has_many :database_items, :foreign_key => :database_id, :dependent => :destroy
  validates :name, :presence => true
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  #数据库执行操作
  def execute
    scripts = []
    self.database_items.each do |item|
      scripts << item.get_execute_script
    end
    scripts
  end
end
