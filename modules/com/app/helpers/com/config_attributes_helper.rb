module Com::ConfigAttributesHelper
  #获取所有的配置分类信息
  def available_classes
    Com::ConfigClass.multilingual.collect {|i|[i[:name], i[:id]] }
  end
end
