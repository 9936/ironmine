class Yan::ParentPerson < ActiveRecord::Base
  set_table_name 'yan_parent_people'
  attr_accessor :temp_id_string
  validates_uniqueness_of :parent_person_id, :scope => [:person_id]
  query_extend
end
