# -*- coding: utf-8 -*-
class AddIcmRelationPermissions < ActiveRecord::Migration
  def up
    icm_edit_relation= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_RELATION',
                                         :default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_relation.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑相关问题',:description=>'编辑相关问题')
    icm_edit_relation.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Relation',:description=>'Edit Relation')
    icm_edit_relation.save
  end

  def down
  end
end
