# -*- coding: utf-8 -*-
class InitWinProduction < ActiveRecord::Migration
  def change
    win_product = Irm::ProductModule.new({:product_short_name=>"WIN",:installed_flag=>"Y",:not_auto_mult=>true})
    win_product.product_modules_tls.build({:name=>"WinHere",:description=>"WinHere",:language=>"en",:source_lang=>"en"})
    win_product.product_modules_tls.build({:name=>"胜地",:description=>"胜地",:language=>"zh",:source_lang=>"en"})
    win_product.save
  end
end
