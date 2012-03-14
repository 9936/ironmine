class InitComModule < ActiveRecord::Migration
  def up
    com_product = Irm::ProductModule.new({:product_short_name=>"COM",:installed_flag=>"Y",:not_auto_mult=>true})
    com_product.product_modules_tls.build({:name=>"Config Management",:description=>"Config Management",:language=>"en",:source_lang=>"en"})
    com_product.product_modules_tls.build({:name=>"配置管理",:description=>"配置管理",:language=>"zh",:source_lang=>"en"})
    com_product.save
  end

  def down
  end
end
