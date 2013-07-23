class Isp::CheckParameter < ActiveRecord::Base
  set_table_name :isp_check_parameters

  belongs_to :check_item, :foreign_key => :check_item_id
  validates_presence_of :name, :check_item_id, :param_type, :data_type, :object_symbol, :value

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_check_item, lambda{|check_item_id|
    where("#{table_name}.check_item_id=?", check_item_id)
  }
end
