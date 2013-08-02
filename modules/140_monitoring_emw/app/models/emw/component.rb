class Emw::Component < ActiveRecord::Base
  set_table_name :emw_components
  validates :name,:component_type,:presence => true
  has_many :component_items, :foreign_key => :component_id, :dependent => :destroy
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  #应用组件执行操作
  def execute
    scripts = []
    self.component_items.each do |item|
      scripts << item.get_execute_script
    end
    scripts
  end
end
