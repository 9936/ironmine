# -*- coding: utf-8 -*-
class AddNewEditBulletinFunctions < ActiveRecord::Migration
  def self.up
    irm_edit_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'EDIT_BULLETIN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑公告',:description=>'编辑公告')
    irm_edit_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Bulletin',:description=>'Edit Bulletin')
    irm_edit_bulletin.save
    irm_new_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'NEW_BULLETIN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_new_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建公告',:description=>'新建公告')
    irm_new_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Bulletin',:description=>'New Bulletin')
    irm_new_bulletin.save

    irm_delete_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'DELETE_BULLETIN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_delete_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'删除公告',:description=>'删除公告')
    irm_delete_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Delete Bulletin',:description=>'Delete Bulletin')
    irm_delete_bulletin.save
  end

  def self.down
  end
end
