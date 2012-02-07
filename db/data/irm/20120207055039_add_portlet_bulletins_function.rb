# -*- coding: utf-8 -*-
class AddPortletBulletinsFunction < ActiveRecord::Migration
  def up
    irm_function_group_zoneportlet= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'PORTLET',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneportlet.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneportlet.id,:meaning=>'Portal窗口',:description=>'Portal窗口',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneportlet.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneportlet.id,:meaning=>'Portlet',:description=>'Portlet',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneportlet.save

    irm_bulletin_portlet= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'BULLETIN_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_bulletin_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看公告Portlet',:description=>'查看公告Portlet')
    irm_bulletin_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of Bulletins',:description=>'View Portlet of Bulletins')
    irm_bulletin_portlet.save
  end

  def down
  end
end
