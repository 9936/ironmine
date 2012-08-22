class CreateIrmSequences < ActiveRecord::Migration
  def up
    create_table :irm_sequences, :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "object_name", :limit => 30
      t.integer  "seq_next", :null =>false, :default => 1, :limit => 11
      t.integer  "seq_length", :null => false, :default => 1
      t.integer  "seq_max", :null => false, :default => 1
      t.string   "rules", :limit => 150
      t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_sequences, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
  end
end
