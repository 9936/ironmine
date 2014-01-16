# -*- coding: utf-8 -*-
class InitSomProduction < ActiveRecord::Migration
  def change
    som_product = Irm::ProductModule.new({:product_short_name=>"SOM",:installed_flag=>"Y",:not_auto_mult=>true})
    som_product.product_modules_tls.build({:name=>"Sales Opportunity Manager",:description=>"Sales Opportunity Manager",:language=>"en",:source_lang=>"en"})
    som_product.product_modules_tls.build({:name=>"销售线索管理",:description=>"销售线索管理",:language=>"zh",:source_lang=>"en"})
    som_product.save
  end
end
