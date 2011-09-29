# -*- coding: utf-8 -*-
class AddLoginStatusLookup < ActiveRecord::Migration
  def up
    irm_login_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_LOGIN_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_login_status.lookup_types_tls.build(:lookup_type_id=>irm_login_status.id,:meaning=>'登录状态',:description=>'登录状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_login_status.lookup_types_tls.build(:lookup_type_id=>irm_login_status.id,:meaning=>'Login Status',:description=>'Login Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_login_status.save

    login_statussuccess= Irm::LookupValue.new(:lookup_type=>'LOGIN_STATUS',:lookup_code=>'SUCCESS',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    login_statussuccess.lookup_values_tls.build(:lookup_value_id=>login_statussuccess.id,:meaning=>'成功',:description=>'成功',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    login_statussuccess.lookup_values_tls.build(:lookup_value_id=>login_statussuccess.id,:meaning=>'Success',:description=>'Success',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    login_statussuccess.save
    login_statusfailed= Irm::LookupValue.new(:lookup_type=>'LOGIN_STATUS',:lookup_code=>'FAILED',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    login_statusfailed.lookup_values_tls.build(:lookup_value_id=>login_statusfailed.id,:meaning=>'失败',:description=>'失败',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    login_statusfailed.lookup_values_tls.build(:lookup_value_id=>login_statusfailed.id,:meaning=>'Failed',:description=>'Failed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    login_statusfailed.save
    login_statuslocked= Irm::LookupValue.new(:lookup_type=>'LOGIN_STATUS',:lookup_code=>'LOCKED',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    login_statuslocked.lookup_values_tls.build(:lookup_value_id=>login_statuslocked.id,:meaning=>'被锁定',:description=>'被锁定',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    login_statuslocked.lookup_values_tls.build(:lookup_value_id=>login_statuslocked.id,:meaning=>'Locked',:description=>'Locked',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    login_statuslocked.save
  end

  def down
  end
end
