# -*- coding: utf-8 -*-
class AddGroupAndOrgFunction < ActiveRecord::Migration
  def self.up
    Irm::FunctionGroup.where(:code=>"COMPANY").each do |fg|
      fg.destroy
    end

    Irm::FunctionGroup.where(:code=>"DEPARTMENT").each do |fg|
      fg.destroy
    end

    Irm::FunctionGroup.where(:code=>"SUPPORT_GROUP").each do |fg|
      fg.destroy
    end

    Irm::FunctionGroup.where(:code=>"ICM_GROUP_ASSIGNMENT").each do |fg|
      fg.destroy
    end

    irm_group= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'GROUP',:controller=>'irm/groups',:action=>'index',:not_auto_mult=>true)
    irm_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组',:description=>'组')
    irm_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Group',:description=>'Group')
    irm_group.save

    irm_operation_unit= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'OPERATION_UNIT',:controller=>'irm/operation_units',:action=>'edit',:not_auto_mult=>true)
    irm_operation_unit.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心',:description=>'运维中心')
    irm_operation_unit.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation Unit',:description=>'Operation Unit')
    irm_operation_unit.save

    icm_icm_support_group= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_SUPPORT_GROUP',:controller=>'icm/support_groups',:action=>'index',:not_auto_mult=>true)
    icm_icm_support_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'支持组',:description=>'支持组')
    icm_icm_support_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Support Group',:description=>'Support Group')
    icm_icm_support_group.save

    irm_group= Irm::Function.new(:function_group_code=>'GROUP',:code=>'GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理组',:description=>'管理组')
    irm_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Group',:description=>'Manage Group')
    irm_group.save
    irm_operation_unit= Irm::Function.new(:function_group_code=>'OPERATION_UNIT',:code=>'OPERATION_UNIT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_operation_unit.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理运维中心',:description=>'管理运维中心')
    irm_operation_unit.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Operation Unit',:description=>'Manage Operation Unit')
    irm_operation_unit.save
    icm_icm_support_group= Irm::Function.new(:function_group_code=>'ICM_SUPPORT_GROUP',:code=>'ICM_SUPPORT_GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_support_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理支持组',:description=>'管理支持组')
    icm_icm_support_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Support Group',:description=>'Manage Support Group')
    icm_icm_support_group.save

    Irm::LookupValue.where(:lookup_type=>"IRM_FUNCTION_GROUP_ZONE",:lookup_code=>"SYSTME_SETTING").update_all(:lookup_code=>"SYSTEM_SETTING")

    Irm::FunctionGroup.where(:zone_code=>'SYSTME_SETTING').update_all(:zone_code=>"SYSTEM_SETTING")

    Irm::Menu.where(:code =>"ORGANIZATION_MANAGEMENT").each do |org_menu|
      org_menu.menus_tls.each do |ml|
        if ml.language.eql?("zh")
          ml.update_attributes({:name=>"组织信息",:description=>"组织信息"})
        else
          ml.update_attributes({:name=>"Organization Information",:description=>"Organization Information"})
        end
      end
      Irm::MenuEntry.where(:sub_menu_id=>org_menu.id).each do |me|
        me.menu_entries_tls.each do |mel|
          if mel.language.eql?("zh")
            mel.update_attributes({:name=>"组织信息",:description=>"组织信息"})
          else
            mel.update_attributes({:name=>"Organization Information",:description=>"Organization Information"})
          end
        end
      end
    end


    menu_entiry_44= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'GROUP',:display_sequence=>30)
    menu_entiry_44.save
    menu_entiry_46= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'OPERATION_UNIT',:display_sequence=>10)
    menu_entiry_46.save
    menu_entiry_66= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_SUPPORT_GROUP',:display_sequence=>90)
    menu_entiry_66.save


    icm_view_watcher= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'VIEW_WATCHER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_watcher.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看观察者',:description=>'查看观察者')
    icm_view_watcher.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Watcher',:description=>'View Watcher')
    icm_view_watcher.save
    icm_edit_watcher= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_WATCHER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_watcher.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑观察者',:description=>'编辑观察者')
    icm_edit_watcher.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Watcher',:description=>'Edit Watcher')
    icm_edit_watcher.save


  end

  def self.down
  end
end
