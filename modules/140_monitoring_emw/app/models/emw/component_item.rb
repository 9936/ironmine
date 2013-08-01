class Emw::ComponentItem < ActiveRecord::Base
  set_table_name :emw_component_items
  validates :name,:presence => true
  belongs_to :component, :foreign_key => :component_id

  scope :query_by_component, lambda {|component_id|
    where("#{table_name}.component_id=?", component_id)
  }

  #获取执行的脚本
  def get_execute_script
    self.script
  end
end
