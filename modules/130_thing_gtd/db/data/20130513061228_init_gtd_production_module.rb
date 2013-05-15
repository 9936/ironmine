# -*- coding: utf-8 -*-
class InitGtdProductionModule < ActiveRecord::Migration
  def up
    com_product = Irm::ProductModule.new({:product_short_name=>"GTD",:installed_flag=>"Y",:not_auto_mult=>true})
    com_product.product_modules_tls.build({:name=>"Get Things Done",:description=>"Get Things Done",:language=>"en",:source_lang=>"en"})
    com_product.product_modules_tls.build({:name=>"日常任务",:description=>"日常任务",:language=>"zh",:source_lang=>"en"})
    com_product.save
  end

  def down
  end
end
