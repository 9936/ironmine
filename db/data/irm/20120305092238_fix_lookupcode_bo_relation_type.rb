# -*- coding: utf-8 -*-
class FixLookupcodeBoRelationType < ActiveRecord::Migration
  def up
    bo_attribute_relation_typejoin= Irm::LookupValue.where(:lookup_type=>'BO_ATTRIBUTE_RELATION_TYPE',:lookup_code=>'JOIN').first
    bo_attribute_relation_typejoin.lookup_values_tls.where(:lookup_value_id=>bo_attribute_relation_typejoin.id,:meaning=>'外连接',:description=>'外连接').first.
        update_attributes(:meaning=>'内连接',:description=>'内连接')


  end

  def down
  end
end
