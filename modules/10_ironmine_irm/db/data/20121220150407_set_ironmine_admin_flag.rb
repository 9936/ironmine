class SetIronmineAdminFlag < ActiveRecord::Migration
  def up
    Irm::Person.where(:login_name=>"ironmine").first.update_attributes(:admin_flag=>Irm::Constant::SYS_YES)
  end

  def down
  end
end
