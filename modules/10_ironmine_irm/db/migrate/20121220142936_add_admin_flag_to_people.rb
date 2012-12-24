class AddAdminFlagToPeople < ActiveRecord::Migration
  def change
    add_column :irm_people,:admin_flag,:string,:limit=>1,:default=>"N",:after=>"vip_flag"
  end
end
