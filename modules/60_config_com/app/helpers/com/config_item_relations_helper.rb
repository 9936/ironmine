module Com::ConfigItemRelationsHelper
  def available_config_relation_type
    Com::ConfigRelationType.multilingual.collect{|i| [i[:name],i[:id]]}
  end
  def available_config_item
    Com::ConfigItem.enabled.all.collect{|i| [i[:item_number],i[:id]]}
  end
end
