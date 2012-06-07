module Com::ConfigItemStatusesHelper
  def available_config_item_status()
    Com::ConfigItemStatus.multilingual.enabled.collect{|v| [v[:name],v[:id]]}
  end
end
