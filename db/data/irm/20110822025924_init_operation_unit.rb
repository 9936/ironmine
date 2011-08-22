# -*- coding: utf-8 -*-
class InitOperationUnit < ActiveRecord::Migration
  def self.up
    Irm::OperationUnit.create(:name=>"汉得运维中心",
                              :short_name=>"Hand",
                              :description=>"汉得运维中心",
                              :default_language_code=>"zh",
                              :default_time_zone_code=>"GMT_P0800_6")
  end

  def self.down
    Irm::OperationUnit.where(:name=>"汉得运维中心",
                              :short_name=>"Hand",
                              :description=>"汉得运维中心",
                              :default_language_code=>"zh",
                              :default_time_zone_code=>"GMT_P0800_6").destroy
  end
end
