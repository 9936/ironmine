# -*- coding: utf-8 -*-
class AddPortletEntryHeadersFunction < ActiveRecord::Migration
  def up
    irm_entry_header_portlet= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'ENTRY_HEADER_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_entry_header_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看我的知识库Portlet',:description=>'查看我的知识库Portlet')
    irm_entry_header_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of My Skm Entries',:description=>'View Portlet of My Skm Entries')
    irm_entry_header_portlet.save


  end

  def down
  end
end
