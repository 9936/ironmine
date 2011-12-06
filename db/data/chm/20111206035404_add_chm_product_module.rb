# -*- coding: utf-8 -*-
class AddChmProductModule < ActiveRecord::Migration
  def up
    chm_product = Irm::ProductModule.new({:product_short_name=>"CHM",:installed_flag=>"Y",:not_auto_mult=>true})
    chm_product.product_modules_tls.build({:name=>"Change Management",:description=>"Change Management",:language=>"en",:source_lang=>"en"})
    chm_product.product_modules_tls.build({:name=>"变更管理",:description=>"变更管理",:language=>"zh",:source_lang=>"en"})
    chm_product.save
  end

  def down
    chm_product = Irm::ProductModule.where({:product_short_name=>"CHM"}).first
    chm_product.destroy if chm_product
  end
end
