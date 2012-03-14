module Com::ConfigRelationMembersHelper
  def available_config_class()
    Com::ConfigClass.multilingual.enabled.collect{|v| [v[:name],v[:id]]}
  end
end
