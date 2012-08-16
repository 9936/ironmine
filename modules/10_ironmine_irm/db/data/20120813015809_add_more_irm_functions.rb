# -*- coding: utf-8 -*-
class AddMoreIrmFunctions < ActiveRecord::Migration
  def up
    irm_reset_person_password= Irm::Function.new(:function_group_code=>'PERSON',:code=>'RESET_PERSON_PASSWORD',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_reset_person_password.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'重置用户密码',:description=>'重置用户密码')
    irm_reset_person_password.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Reset User Password',:description=>'Reset User Password')
    irm_reset_person_password.save

    irm_view_group= Irm::Function.new(:function_group_code=>'GROUP',:code=>'VIEW_GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看组',:description=>'查看组')
    irm_view_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Group',:description=>'View Group')
    irm_view_group.save

    irm_edit_person= Irm::Function.new(:function_group_code=>'PERSON',:code=>'EDIT_PERSON',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_person.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑用户',:description=>'编辑用户')
    irm_edit_person.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit User',:description=>'Edit User')
    irm_edit_person.save
  end

  def down
  end
end
