# -*- coding: utf-8 -*-
class InitSugProduction < ActiveRecord::Migration
  def change
    sug_product = Irm::ProductModule.new({:product_short_name=>"SUG",:installed_flag=>"Y",:not_auto_mult=>true})
    sug_product.product_modules_tls.build({:name=>"Sugon",:description=>"Sugon",:language=>"en",:source_lang=>"en"})
    sug_product.product_modules_tls.build({:name=>"中科曙光",:description=>"中科曙光",:language=>"zh",:source_lang=>"en"})
    sug_product.save
  end
end
