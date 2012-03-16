module Com::ConfigAttributesHelper
  #获取所有的配置分类信息
  def available_classes
    Com::ConfigClass.multilingual.collect {|i|[i[:name], i[:id]] }
  end

  #更加config_class_id显示名称
  def get_config_class_name_by_id(id)
    Com::ConfigClass.multilingual.select("name").where(:id => id).first[:name]
  end

  #根据lookup_type 和lookup_code显示名称
  def get_meaning_by_type_code(lookup_type, lookup_code)
    Irm::LookupValue.get_meaning(lookup_type, lookup_code)
  end
end
