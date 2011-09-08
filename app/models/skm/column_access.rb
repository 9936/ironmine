class Skm::ColumnAccess < ActiveRecord::Base
  set_table_name :skm_column_accesses
  belongs_to :column

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.source_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.source_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }

  def source
    eval(self.source_type).where(:id => self.source_id).first
  end
end