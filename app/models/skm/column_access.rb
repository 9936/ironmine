class Skm::ColumnAccess < ActiveRecord::Base
  set_table_name :skm_column_accesses
  belongs_to :column

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.source_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.source_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }

  def source
    eval(self.source_type).where(:id => self.source_id).first
  end
end