class Ndm::DevManagement< ActiveRecord::Base
  set_table_name 'ndm_dev_managements'
  #加入activerecord的通用方法和scope
  query_extend

  validates_presence_of :name

  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :with_method, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vmethod ON vmethod.lookup_type = 'NDM_METHOD' AND vmethod.lookup_code = #{table_name}.method AND vmethod.language = '#{language}'").
        select("vmethod.meaning method_name")
  }

  scope :with_module, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vmodule ON vmodule.lookup_type = 'NDM_MODULE' AND vmodule.lookup_code = #{table_name}.module AND vmodule.language = '#{language}'").
        select("vmodule.meaning module_name")
  }

  scope :with_dev_difficulty, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vdifficulty ON vdifficulty.lookup_type = 'NDM_DIFFICULTY' AND vdifficulty.lookup_code = #{table_name}.dev_difficulty AND vdifficulty.language = '#{language}'").
        select("vdifficulty.meaning dev_difficulty_name")
  }

  scope :with_status, lambda{|language, status|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} v#{status} ON v#{status}.lookup_type = 'NDM_STATUS' AND v#{status}.lookup_code = #{table_name}.#{status} AND v#{status}.language = '#{language}'").
        select("v#{status}.meaning #{status}_name")
  }



end
