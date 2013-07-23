# -*- coding: utf-8 -*-
class InitIspProductionModule < ActiveRecord::Migration
  def up
    com_product = Irm::ProductModule.new({:product_short_name=>"ISP",:installed_flag=>"Y",:not_auto_mult=>true})
    com_product.product_modules_tls.build({:name=>"EBS inspection",:description=>"EBS inspection",:language=>"en",:source_lang=>"en"})
    com_product.product_modules_tls.build({:name=>"EBS巡检",:description=>"EBS巡检",:language=>"zh",:source_lang=>"en"})
    com_product.save
  end

  def down
  end
end