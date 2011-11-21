module Irm::LookupValuesHelper
  def available_lookup_type
    Irm::LookupType.multilingual
  end


  def available_lookup_type(lookup_type)
    Irm::LookupValue.query_by_lookup_type(lookup_type).multilingual.collect{|m| [m[:meaning], m.lookup_code]}
  end

  def lookup_field_flag(name,lookup_type,selected=nil,options={})
    values =  available_lookup_type(lookup_type)
    blank_select_tag(name,values,selected,options)
  end

end
