class Emw::Interface < ActiveRecord::Base
  set_table_name :emw_interfaces

  belongs_to :ebs_module, :foreign_key => :ebs_module_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_module, lambda{
    select("#{table_name}.*, em.name module_name, em.module_code").
        joins("JOIN #{Emw::EbsModule.table_name} em ON em.id=#{table_name}.ebs_module_id")
  }

end
