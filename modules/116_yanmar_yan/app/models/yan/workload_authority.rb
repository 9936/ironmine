class Yan::WorkloadAuthority < ActiveRecord::Base
  set_table_name 'yan_workload_authorities'

  query_extend

  scope :with_object_type_and_id, lambda {|type, id|
      where("ob_type = '#{type}' and ob_id = '#{id}'")
  }

end
