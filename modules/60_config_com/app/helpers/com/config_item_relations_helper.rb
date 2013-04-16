module Com::ConfigItemRelationsHelper
  def available_config_relation_type
    Com::ConfigRelationType.multilingual.collect{|i| [i[:name],i[:id]]}
  end
  def available_config_item(config_item)
    available_configs = Com::ConfigItem.enabled.available(config_item.id).uniq
    #排除掉已经添加的以及其上级级节点
    available_configs = available_configs - config_item.parent_nodes
    available_configs.collect{|i| [i[:item_number],i[:id]]}
  end
end
