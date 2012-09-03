# -*- coding: utf-8 -*-
class AddDataShareRulesFunction < ActiveRecord::Migration
  def up
    irm_data_share_rule= Irm::Function.new(:function_group_code=>'DATA_ACCESS',:code=>'DATA_SHARE_RULE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_data_share_rule.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'数据共享规则',:description=>'数据共享规则')
    irm_data_share_rule.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Data Share Rules',:description=>'Data Share Rules')
    irm_data_share_rule.save

  end

  def down
  end
end
