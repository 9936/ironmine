class CreateConsConsTypes < ActiveRecord::Migration
  def change
    create_table :cons_cons_types do |t|
      t.string :name,               :limit => 30,                        :null => false
      t.string :status,             :limit => 30, :default => "ENABLED"
      t.string :code,               :limit => 30,                        :null => false
      t.timestamps
    end
  end
end
