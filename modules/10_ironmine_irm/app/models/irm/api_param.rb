class Irm::ApiParam < ActiveRecord::Base
  set_table_name :irm_api_params

  belongs_to :rest_api, :foreign_key => :rest_api_id

  #validates_presence_of :rest_api_id
  #validates_uniqueness_of :rest_api, :scope => [:name]

  scope :query_input_params, lambda {|rest_api_id|
     where("#{table_name}.rest_api_id=? AND (#{table_name}.param_classify='INPUT' OR #{table_name}.param_classify='BOTH')", rest_api_id)
  }

  scope :with_permission_by_function, lambda {|function_id|
    joins("JOIN #{Irm::Permission.table_name} p ON p.id=#{table_name}.permission_id").
      where("p.function_id=? AND (#{table_name}.param_classify='INPUT' OR #{table_name}.param_classify='BOTH')", function_id)
  }

  scope :all_params, lambda{|rest_api_id|
    where("#{table_name}.rest_api_id=?", rest_api_id)
  }
end