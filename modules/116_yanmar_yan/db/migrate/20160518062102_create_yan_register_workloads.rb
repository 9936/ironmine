class CreateYanRegisterWorkloads < ActiveRecord::Migration
  def change
    create_table :yan_register_workloads do |t|
      t.string          "request_id",  :limit => 22
      t.string          "supporter_id",  :limit => 22
      t.text            "description"
      t.datetime        "start_date"
      t.datetime        "end_date"
      t.float           "workload"
      t.timestamps
    end
  end
end
