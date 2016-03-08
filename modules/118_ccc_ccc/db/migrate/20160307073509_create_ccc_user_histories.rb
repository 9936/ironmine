class CreateCccUserHistories < ActiveRecord::Migration
  def change
    create_table :ccc_user_histories do |t|
      t.string   "opu_id",             :limit => 22,                       :null => false
      t.string   "login_person_id",    :limit => 50,                       :null => false #当前登录用户的id
      t.string   "external_system_id", :limit => 50,                       :null => false #项目的id
      t.string   "end_user_name",      :limit => 50,                       :null => false #最终用户姓名
      t.string   "end_user_phone",     :limit => 50
      t.string   "end_user_email",     :limit => 50
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
