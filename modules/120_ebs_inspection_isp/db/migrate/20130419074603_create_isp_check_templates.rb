class CreateIspCheckTemplates < ActiveRecord::Migration
  def change
    create_table :isp_check_templates, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :collate => "utf8_bin"
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "template_type", :limit => 30
      t.text "body"
      t.integer "display_sequence"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_check_templates, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "isp_check_templates", ["program_id"], :name => "ISP_CHECK_TEMPLATES_N1"

  end
end
