class InitYsquareModule < ActiveRecord::Migration
  def up
    irm_product = Irm::ProductModule.new({:product_short_name=>"YSQ",:installed_flag=>"Y",:not_auto_mult=>true})
    irm_product.product_modules_tls.build({:name=>"YSQ",:description=>"YSQ",:language=>"en",:source_lang=>"en"})
    irm_product.product_modules_tls.build({:name=>"YSQ",:description=>"YSQ",:language=>"zh",:source_lang=>"en"})
    irm_product.save
  end

  def down
  end
end
