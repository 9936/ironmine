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

  scope :with_dev_type, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vtype ON vtype.lookup_type = 'NDM_TYPE' AND vtype.lookup_code = #{table_name}.dev_type AND vtype.language = '#{language}'").
        select("vtype.meaning type_name")
  }

  scope :with_priority, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vpriority ON vpriority.lookup_type = 'NDM_PRIORITY' AND vpriority.lookup_code = #{table_name}.priority AND vpriority.language = '#{language}'").
        select("vpriority.meaning priority_name")
  }

  scope :with_dev_difficulty, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vdifficulty ON vdifficulty.lookup_type = 'NDM_DIFFICULTY' AND vdifficulty.lookup_code = #{table_name}.dev_difficulty AND vdifficulty.language = '#{language}'").
        select("vdifficulty.meaning dev_difficulty_name")
  }

  scope :with_status, lambda{|language, status|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} v#{status} ON v#{status}.lookup_type = 'NDM_PHASE_STATUS' AND v#{status}.lookup_code = #{table_name}.#{status} AND v#{status}.language = '#{language}'").
        select("v#{status}.meaning #{status}_name")
  }

  scope :with_project_relation, lambda{|current_person_id|
    joins("LEFT OUTER JOIN #{Ndm::ProjectPerson.table_name} npp ON npp.project_id = #{table_name}.project AND npp.person_id = '#{current_person_id}'").
    joins("LEFT OUTER JOIN #{Ndm::Project.table_name} np ON np.id = #{table_name}.project").
        select("npp.vi vi, npp.ed ed, npp.ad ad, npp.re re, npp.im im").
        select("np.name project_name")
  }

  def update_dev_status
    dev_status = "W MD020"
    dev_status_array =     [["gd", "W MD050"],["fd", "W MD050 Review"],["fdr", "W MD070"],
                            ["td", "W Coding"],["co", "W Testing"],["te", "W MD120"],["si", "W Inspect"],
                            ["at", "Accepted"],["go", "Golive"]]

    dev_status_array.each do |s|
      dev_status = s[1] if self[(s[0] + "_status").to_sym].eql?("NDM_PHASE_STATUS_COMPLETED")
    end

    self.update_attribute(:dev_status, dev_status)
  end

end
