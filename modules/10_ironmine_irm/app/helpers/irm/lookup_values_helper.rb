module Irm::LookupValuesHelper
  #def available_lookup_type
  #  Irm::LookupType.multilingual
  #end


  def available_lookup_type(lookup_type)
    Irm::LookupValue.query_by_lookup_type(lookup_type).order_by_sequence.multilingual.collect{|m| [m[:meaning], m.lookup_code]}
  end

  def lookup_field_flag(name,lookup_type,selected=nil,options={})
    values =  available_lookup_type(lookup_type)
    blank_select_tag(name,values,selected,options)
  end

  def lookup(lookup_type)
    Irm::LookupValue.get_lookup_value(lookup_type).collect{|i| [i[:meaning],i.lookup_code]}
  end

end
