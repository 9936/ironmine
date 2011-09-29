
class AddLockFieldToPerson < ActiveRecord::Migration
  def change
    add_column :irm_people,:last_reset_password,:string,:limit=>60,:after=>:password_updated_at
    add_column :irm_people,:locked_flag,:string,:limit=>1,:after=>:last_assigned_date,:default=>"N"
    add_column :irm_login_records,:login_status,:string,:limit=>30,:after=>:login_at,:default=>"SUCCESS"
    change_column :irm_login_records, "session_id", :string,:limit=>60
  end
end
