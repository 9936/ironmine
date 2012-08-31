# -*- coding: utf-8 -*-
class AddApproveSkmEntryFunction < ActiveRecord::Migration
  def up
    skm_approve_skm_entries= Irm::Function.new(:function_group_code=>'KNOWLEDGE_MANAGEMENT',:code=>'APPROVE_SKM_ENTRIES',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_approve_skm_entries.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审核知识库文章',:description=>'审核知识库文章')
    skm_approve_skm_entries.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approve Skm Entries',:description=>'Approve Skm Entries')
    skm_approve_skm_entries.save

  end

  def down
  end
end
