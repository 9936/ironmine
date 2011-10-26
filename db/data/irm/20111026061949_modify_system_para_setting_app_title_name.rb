# -*- coding:utf-8 -*-
class ModifySystemParaSettingAppTitleName < ActiveRecord::Migration
  def up
    sp = Irm::SystemParameter.where("parameter_code = ?", 'APPLICATION_TITLE').first
    sp.system_parameters_tls.each do |t|
      if t.language.eql?('zh')
        t.update_attributes(:name => "系统名称", :description => "系统名称")
      elsif t.language.eql?('en')
        t.update_attributes(:name => "System Title", :description => "System Title")
      end
    end if sp
  end

  def down
  end
end
