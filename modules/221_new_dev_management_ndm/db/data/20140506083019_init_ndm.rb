# -*- coding: utf-8 -*-
class InitNdm < ActiveRecord::Migration
  def up
    product = Irm::ProductModule.new({:product_short_name=>"NDM",:installed_flag=>"Y",:not_auto_mult=>true})
    product.product_modules_tls.build({:name=>"Development Management",:description=>"Development Management",:language=>"en",:source_lang=>"en"})
    product.product_modules_tls.build({:name=>"开发管理",:description=>"开发管理",:language=>"zh",:source_lang=>"en"})
    product.save
  end

  def down
  end
end
