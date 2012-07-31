module Com::ConfigRelationMembersHelper
  def available_config_class()
    Com::ConfigClass.multilingual.enabled.where("#{Com::ConfigClass.table_name}.leaf_flag='Y'").collect{|v| [v[:name],v[:id]]}
  end
end
