class Som::ParticipationInfo < ActiveRecord::Base
  set_table_name 'som_participation_infos'
  #沟通参与人信息表
  belongs_to :communicate_info
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
