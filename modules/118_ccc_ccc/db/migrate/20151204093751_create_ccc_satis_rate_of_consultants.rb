class CreateCccSatisRateOfConsultants < ActiveRecord::Migration
  def change
    create_table :ccc_satis_rate_of_consultants do |t|
      t.string   "opu_id",            :limit => 22,                        :null => false
      t.string   "supporter_id",      :limit => 50,                        :null => false
      t.string   "grade_type",        :limit => 30,                        :null => false
      t.integer   "grade_type_times", :limit => 10,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
