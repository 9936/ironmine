class AddImpModule < ActiveRecord::Migration
  def up
    irm_product = Irm::ProductModule.new({:product_short_name=>"IMP",:installed_flag=>"Y",:not_auto_mult=>true})
    irm_product.product_modules_tls.build({:name=>"Import",:description=>"Import",:language=>"en",:source_lang=>"en"})
    irm_product.product_modules_tls.build({:name=>"Import",:description=>"Import",:language=>"zh",:source_lang=>"en"})
    irm_product.product_modules_tls.build({:name=>"Import",:description=>"Import",:language=>"ja",:source_lang=>"en"})
    irm_product.save
  end

  def down
  end
end
