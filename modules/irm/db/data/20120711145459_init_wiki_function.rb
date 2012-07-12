# -*- coding: utf-8 -*-
class InitWikiFunction < ActiveRecord::Migration
  def up
    irm_function_group_zone_irm_wiki= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'IRM_WIKI',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone_irm_wiki.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_irm_wiki.id,:meaning=>'Wiki',:description=>'Wiki',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_irm_wiki.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_irm_wiki.id,:meaning=>'Wiki',:description=>'Wiki',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_irm_wiki.save
    irm_irm_wiki= Irm::FunctionGroup.new(:zone_code=>'IRM_WIKI',:code=>'IRM_WIKI',:controller=>'irm/wikis',:action=>'index',:not_auto_mult=>true)
    irm_irm_wiki.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Wiki',:description=>'Wiki')
    irm_irm_wiki.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Wiki',:description=>'Wiki')
    irm_irm_wiki.save
    irm_view_wiki= Irm::Function.new(:function_group_code=>'IRM_WIKI',:code=>'VIEW_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看Wiki',:description=>'查看Wiki')
    irm_view_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Wiki',:description=>'View Wiki')
    irm_view_wiki.save
    irm_create_wiki= Irm::Function.new(:function_group_code=>'IRM_WIKI',:code=>'CREATE_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_create_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建Wiki',:description=>'新建Wiki')
    irm_create_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Wiki',:description=>'Create Wiki')
    irm_create_wiki.save
    irm_edit_wiki= Irm::Function.new(:function_group_code=>'IRM_WIKI',:code=>'EDIT_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑Wiki',:description=>'编辑Wiki')
    irm_edit_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Wiki',:description=>'New Wiki')
    irm_edit_wiki.save
    irm_manage_wiki= Irm::Function.new(:function_group_code=>'IRM_WIKI',:code=>'MANAGE_WIKI',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_manage_wiki.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Wiki',:description=>'管理Wiki')
    irm_manage_wiki.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Wiki',:description=>'Manage Wiki')
    irm_manage_wiki.save
  end

  def down
  end
end
