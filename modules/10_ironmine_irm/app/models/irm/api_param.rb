class Irm::ApiParam < ActiveRecord::Base
  set_table_name :irm_api_params

  belongs_to :permission, :foreign_key => :permission_id

  validates_presence_of :permission_id
  validates_uniqueness_of :permission_id, :scope => [:name]

  scope :with_permission_by_function, lambda {|function_id|
    joins("JOIN #{Irm::Permission.table_name} p ON p.id=#{table_name}.permission_id").
      where("p.function_id=? AND (#{table_name}.param_classify='INPUT' OR #{table_name}.param_classify='BOTH')", function_id)
  }
end