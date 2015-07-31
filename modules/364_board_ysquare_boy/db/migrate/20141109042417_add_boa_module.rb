class AddBoaModule < ActiveRecord::Migration
  def up
    irm_product = Irm::ProductModule.new({:product_short_name=>"BOY",:installed_flag=>"Y",:not_auto_mult=>true})
    irm_product.product_modules_tls.build({:name=>"BOY",:description=>"BOY",:language=>"en",:source_lang=>"en"})
    irm_product.product_modules_tls.build({:name=>"BOY",:description=>"BOY",:language=>"zh",:source_lang=>"en"})
    irm_product.save
  end

  def down
  end
end