# -*- coding: utf-8 -*-
class InitRatingMenuFunction < ActiveRecord::Migration
  def up
    irm_rating_config= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'RATING_CONFIG',:controller=>'irm/rating_configs',:action=>'index',:not_auto_mult=>true)
    irm_rating_config.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'评价设置',:description=>'评价设置')
    irm_rating_config.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Rating',:description=>'Config Rating')
    irm_rating_config.save
    irm_rating_config= Irm::Function.new(:function_group_code=>'RATING_CONFIG',:code=>'RATING_CONFIG',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_rating_config.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'评价设置',:description=>'评价设置')
    irm_rating_config.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Rating',:description=>'Config Rating')
    irm_rating_config.save
    menu_entiry_129= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'RATING_CONFIG',:display_sequence=>80)
    menu_entiry_129.save
  end

  def down
  end
end
