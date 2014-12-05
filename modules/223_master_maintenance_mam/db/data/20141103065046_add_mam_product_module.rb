# -*- coding: utf-8 -*-
class AddMamProductModule < ActiveRecord::Migration
  def up
    irm_product = Irm::ProductModule.new({:product_short_name=>"MAM",:installed_flag=>"Y",:not_auto_mult=>true})
    irm_product.product_modules_tls.build({:name=>"Master Maintenance",:description=>"Master Maintenance",:language=>"en",:source_lang=>"en"})
    irm_product.product_modules_tls.build({:name=>"Master Maintenance",:description=>"Master Maintenance",:language=>"zh",:source_lang=>"en"})
    irm_product.save
  end

  def down
  end
end
