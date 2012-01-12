class ReworkSurveyTables < ActiveRecord::Migration
  def up
    create_table "csi_surveys", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "title",               :limit => 150, :null => false
      t.string   "description",         :limit => 240
      t.string   "notify_flag",         :limit => 1
      t.string   "public_flag",         :limit => 1
      t.string   "security_filter_type",:limit => 30
      t.string   "publish_result_flag", :limit => 1
      t.string   "end_message",         :limit => 240
      t.date     "close_date"
      t.string   "incident_flag",       :limit => 1
      t.integer  "time_limit",          :limit => 1
      t.string   "password_flag",       :limit => 1
      t.string   "password",            :limit => 30
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :csi_surveys, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table "csi_survey_subjects", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "survey_id",           :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "name",                :limit => 150
      t.string   "description",         :limit => 240
      t.string   "required_flag",       :limit => 1
      t.string   "input_type",          :limit => 30
      t.string   "publish_result_flag", :limit => 1
      t.integer  "display_sequence"
      t.string   "other_input_flag"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :csi_survey_subjects, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "csi_survey_subjects", ["survey_id"], :name => "CSI_SURVEY_SUBJECTS_N1"


    create_table "csi_survey_subject_options", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "survey_subject_id",   :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "value",               :limit => 240
      t.integer  "display_sequence"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :csi_survey_subject_options, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "csi_survey_subject_options", ["survey_subject_id"], :name => "CSI_SURVEY_SUBJECT_OPTIONS_N1"


    create_table "csi_survey_responses", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "survey_id",           :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "person_id",           :limit => 22, :collate=>"utf8_bin"
      t.string   "ip_address",          :limit => 30
      t.string   "source_type",         :limit => 30
      t.datetime "start_at"
      t.datetime "end_at"
      t.integer  "elapse"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :csi_survey_responses, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "csi_survey_responses", ["survey_id"], :name => "CSI_SURVEY_RESPONSES_N1"

    create_table "csi_survey_results", :force => true do |t|
      t.string   "opu_id",                      :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "survey_response_id",          :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "survey_subject_id",           :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "result_type",                 :limit => 30
      t.string   "survey_subject_option_id",    :limit => 22, :collate=>"utf8_bin"
      t.string   "text_input",                  :limit => 240
      t.string   "status_code",                 :limit => 30, :null => false
      t.string   "created_by",                  :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",                  :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :csi_survey_results, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "csi_survey_results", ["survey_response_id","survey_subject_id"], :name => "CSI_SURVEY_RESULTS_N1"

  end

  def down
  end
end
