module Com::ConfigAttributesHelper
  #获取所有的配置分类信息
  def available_classes
    Com::ConfigClass.multilingual.collect {|i|[i[:name], i[:id]] }
  end

  def get_config_class_name_by_id(id)
    Com::ConfigClass.multilingual.select("name").where(:id => id).first[:name]
  end
end
