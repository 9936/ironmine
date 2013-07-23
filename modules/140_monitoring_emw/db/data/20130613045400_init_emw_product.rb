# -*- coding: utf-8 -*-
class InitEmwProduct < ActiveRecord::Migration
  def up
    emw_product = Irm::ProductModule.new({:product_short_name=>"EMW",:installed_flag=>"Y",:not_auto_mult=>true})
    emw_product.product_modules_tls.build({:name=>"EBS Monitoring Workbench",:description=>"EBS Monitoring Workbench",:language=>"en",:source_lang=>"en"})
    emw_product.product_modules_tls.build({:name=>"EBS监控工作台",:description=>"EBS监控工作台",:language=>"zh",:source_lang=>"en"})
    emw_product.save
  end

  def down
  end
end
