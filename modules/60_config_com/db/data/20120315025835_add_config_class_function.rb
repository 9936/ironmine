# -*- coding: utf-8 -*-
class AddConfigClassFunction < ActiveRecord::Migration
  def up
    com_config_class= Irm::FunctionGroup.new(:zone_code=>'CONFIG_MANAGEMENT',:code=>'CONFIG_CLASS',:controller=>'com/config_classes',:action=>'index',:not_auto_mult=>true)
    com_config_class.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项分类',:description=>'配置项分类')
    com_config_class.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Class',:description=>'Config Class')
    com_config_class.save

    com_config_class= Irm::Function.new(:function_group_code=>'CONFIG_CLASS',:code=>'CONFIG_CLASS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    com_config_class.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项分类',:description=>'配置项分类')
    com_config_class.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Class',:description=>'Config Class')
    com_config_class.save

    menu_entiry_126= Irm::MenuEntry.new(:menu_code=>'CONFIG_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CONFIG_CLASS',:display_sequence=>30)
    menu_entiry_126.save


  end

  def down
  end
end
