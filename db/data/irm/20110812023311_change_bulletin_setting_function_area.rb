# -*- coding: utf-8 -*-
class ChangeBulletinSettingFunctionArea < ActiveRecord::Migration
  def self.up
    bulletin_setting = Irm::FunctionGroup.where(:zone_code => "BULLETIN_SETTING").where(:code => "BULLETIN_COLUMN")
    if bulletin_setting.any?
      bulletin_setting.first.update_attribute(:zone_code, "SYSTEM_SETTING")
    end
  end

  def self.down
  end
end
