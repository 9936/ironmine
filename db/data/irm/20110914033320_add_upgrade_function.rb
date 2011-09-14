# -*- coding: utf-8 -*-
class AddUpgradeFunction < ActiveRecord::Migration
  def up
    icm_upgrade_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'UPGRADE_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_upgrade_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'升级',:description=>'升级')
    icm_upgrade_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Upgrade',:description=>'Upgrade')
    icm_upgrade_incident_request.save
  end

  def down
  end
end
