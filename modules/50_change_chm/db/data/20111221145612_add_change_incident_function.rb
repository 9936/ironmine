# -*- coding: utf-8 -*-
class AddChangeIncidentFunction < ActiveRecord::Migration
  def up
    chm_change_incident= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'CHANGE_INCIDENT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_incident.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更关联事故单',:description=>'变更关联事故单')
    chm_change_incident.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change relative to incident',:description=>'Change relative to incident')
    chm_change_incident.save
  end

  def down
  end
end
