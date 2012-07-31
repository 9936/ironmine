class Irm::SearchLayoutColumn < ActiveRecord::Base
  set_table_name :irm_search_layout_columns

  belongs_to :object_attribute

  belongs_to :search_layout

  scope :query_business_object,lambda{|type,business_object_id,language|
    joins("JOIN #{Irm::SearchLayout.table_name} ON #{Irm::SearchLayout.table_name}.id = #{table_name}.search_layout_id").
        joins("JOIN #{Irm::ObjectAttribute.view_name} ON #{table_name}.object_attribute_id = #{Irm::ObjectAttribute.view_name}.id AND #{Irm::ObjectAttribute.view_name}.language = '#{language}'" ).
        where("#{Irm::SearchLayout.table_name}.business_object_id = ? AND #{Irm::SearchLayout.table_name}.code = ? ",business_object_id,type).
        select("#{Irm::ObjectAttribute.view_name}.attribute_name ,#{Irm::ObjectAttribute.view_name}.name,#{Irm::ObjectAttribute.view_name}.data_type,#{Irm::ObjectAttribute.view_name}.data_length,#{Irm::ObjectAttribute.view_name}.category")
  }

  def self.lookup_columns(business_object_id)
    self.query_business_object("LOOKUP",business_object_id,I18n.locale)
  end
end
