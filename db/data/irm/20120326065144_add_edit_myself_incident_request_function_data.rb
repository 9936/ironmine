# -*- coding: utf-8 -*-
class AddEditMyselfIncidentRequestFunctionData < ActiveRecord::Migration
  def up
    icm_edit_myself_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_MYSELF_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_myself_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑自己的事故单',:description=>'编辑自己的事故单')
    icm_edit_myself_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Myself Request',:description=>'Edit Myself Request')
    icm_edit_myself_request.save    
  end

  def down
  end
end
