class Irm::SystemParameterValue < ActiveRecord::Base
  set_table_name :irm_system_parameter_values
  has_attached_file :img
  validates_attachment_size :img , :less_than => Irm::SystemParametersManager.upload_file_limit.kilobytes

   #加入activerecord的通用方法和scope
   query_extend
   # 对运维中心数据进行隔离
   default_scope {default_filter}
   belongs_to :system_parameter #设置主从关系
end
