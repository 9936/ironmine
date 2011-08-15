class AddPasswordPoliciesTable < ActiveRecord::Migration
  def self.up
    create_table :irm_password_policies, :force => true do |t|
      t.string :id, :limit => 22, :null => false
      t.string :company_id, :limit => 22, :null => false
      t.string :expire_in, :limit => 30
      t.string :enforce_history, :limit => 30
      t.string :minimum_length, :limit => 30
      t.string :complexity_requirement, :limit => 30
      t.string :question_requirement, :limit => 30
      t.string :maximum_attempts, :limit => 30
      t.string :lockout_period, :limit => 30
      t.string   "status_code", :limit => 30, :default=>"ENABLED", :null => false
      t.string  "created_by", :null => false, :limit => 22
      t.string  "updated_by", :null => false, :limit => 22
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def self.down
    drop_table :irm_password_policies
  end
end
