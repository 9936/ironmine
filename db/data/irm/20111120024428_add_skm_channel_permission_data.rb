# -*- coding: utf-8 -*-
class AddSkmChannelPermissionData < ActiveRecord::Migration
  def up
    skm_skm_channel= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_CHANNEL',:controller=>'skm/channels',:action=>'index',:not_auto_mult=>true)
    skm_skm_channel.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库频道',:description=>'知识库频道')
    skm_skm_channel.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Channel',:description=>'Channel')
    skm_skm_channel.save

    skm_skm_channel= Irm::Function.new(:function_group_code=>'SKM_CHANNEL',:code=>'SKM_CHANNEL',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_channel.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库频道',:description=>'管理知识库频道')
    skm_skm_channel.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Skm Channel',:description=>'Manage Skm Channel')
    skm_skm_channel.save

    skm_edit_skm_channel= Irm::Function.new(:function_group_code=>'SKM_CHANNEL',:code=>'EDIT_SKM_CHANNEL',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_edit_skm_channel.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑知识库频道',:description=>'编辑知识库频道')
    skm_edit_skm_channel.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Skm Channel',:description=>'Edit Skm Channel')
    skm_edit_skm_channel.save
    
    menu_entiry_73= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_CHANNEL',:display_sequence=>60)
    menu_entiry_73.save
  end

  def down
  end
end
