class CreateCccIndustries < ActiveRecord::Migration
  def change
    create_table "ccc_industries", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_industries",  ["code","opu_id"], :name => "ccc_industries_U1", :unique => true
    
    create_table "ccc_industries_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "industry_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_industries_tl", ["industry_id", "language"], :name => "ccc_industries_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_industries_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_industries t,ccc_industries_tl tl
                                                 WHERE t.id = tl.industry_id')
  end
end
