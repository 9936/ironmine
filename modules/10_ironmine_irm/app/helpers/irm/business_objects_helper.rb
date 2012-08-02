module Irm::BusinessObjectsHelper
  def available_not_exists_model
    Rails.application.paths["app/models"].each{|model_path|
        Dir["#{Rails.root}/#{model_path}/*/*.rb"].each { |file| require file }
    } unless Rails.env.eql?("production")

    models = ActiveRecord::Base.send(:subclasses)

    models.delete_if{|m| m.table_name.end_with?("s_tl")}
    models = models.collect{|m| m.name}.sort
    exists_models = Irm::BusinessObject.all.collect{|bo| bo.bo_model_name}
    models.delete_if{|m| exists_models.include?(m)}
    models
  end

  def available_business_object
    Irm::BusinessObject.query_by_status_code("ENABLED").multilingual.order("business_object_code").collect{|i|[i[:name],i.business_object_code,{:bo_table_name=>i.bo_table_name}]}
  end

  def bo_name(bo_code)
    Irm::BusinessObject.multilingual.where(:business_object_code=>bo_code).first[:name]
  end

  def available_business_object_with_id
    Irm::BusinessObject.query_by_status_code("ENABLED").multilingual.collect{|i|[i[:name],i.id,{:bo_table_name=>i.bo_table_name}]}
  end
  def avaliable_relation_type
    Irm::LookupValue.query_by_lookup_type("BO_ATTRIBUTE_RELATION_TYPE").multilingual.collect{|i| [i[:meaning],i[:lookup_code]]}
  end

end
