class Ironmine15 < ActiveRecord::Migration
  def self.up
  create_table "csi_survey_members", :force => true do |t|
    t.string   "opu_id",          :limit => 22
    t.string   "survey_id",       :limit => 22
    t.string   "person_id",       :limit => 22
    t.string   "source_type"
    t.string   "source_id",       :limit => 22
    t.string   "required_flag",   :limit => 1
    t.string   "response_flag",   :limit => 1
    t.date     "end_date_active"
    t.string   "status_code",     :limit => 30, :default => "ENABLED"
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csi_survey_members", ["opu_id", "person_id", "response_flag"], :name => "CSI_SURVEY_MEMBERS_N4"
  add_index "csi_survey_members", ["opu_id", "person_id"], :name => "CSI_SURVEY_MEMBERS_N2"
  add_index "csi_survey_members", ["opu_id", "survey_id", "person_id"], :name => "CSI_SURVEY_MEMBERS_N3"
  add_index "csi_survey_members", ["opu_id", "survey_id"], :name => "CSI_SURVEY_MEMBERS_N1"

  create_table "csi_survey_ranges", :force => true do |t|
    t.string   "opu_id",        :limit => 22
    t.string   "survey_id",     :limit => 22
    t.string   "source_id",     :limit => 22
    t.string   "source_type",   :limit => 30
    t.string   "required_flag", :limit => 1
    t.string   "status_code",   :limit => 30, :default => "ENABLED"
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csi_survey_ranges", ["opu_id"], :name => "CSI_SURVEY_RANGES_N1"
  add_index "csi_survey_ranges", ["opu_id"], :name => "CSI_SURVEY_RANGES_N2"
  add_index "csi_survey_ranges", ["opu_id"], :name => "CSI_SURVEY_RANGES_N3"

  create_table "csi_survey_results", :force => true do |t|
    t.string   "opu_id",         :limit => 22,                          :null => false
    t.string   "person_id",      :limit => 22
    t.string   "ip_address",     :limit => 60
    t.string   "response_batch"
    t.string   "response_time"
    t.string   "subject_id",     :limit => 22
    t.string   "option_type",    :limit => 30
    t.string   "subject_result", :limit => 1000
    t.string   "status_code",    :limit => 30,   :default => "ENABLED"
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csi_survey_results", ["opu_id", "subject_id"], :name => "CSI_SURVEY_RESULTS_N1"
  add_index "csi_survey_results", ["response_batch", "subject_id"], :name => "CSI_SURVEY_RESULTS_N2"

  create_table "csi_survey_subject_options", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "subject_id",  :limit => 22,                        :null => false
    t.integer  "seq_num"
    t.string   "value",       :limit => 30
    t.string   "status_code", :limit => 30, :default => "ENABLED"
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csi_survey_subject_options", ["opu_id", "subject_id"], :name => "CSI_SURVEY_SUBJECT_OPTIONS_N1"

  create_table "csi_survey_subjects", :force => true do |t|
    t.string   "opu_id",        :limit => 22,                         :null => false
    t.string   "survey_id",     :limit => 22,                         :null => false
    t.string   "name",          :limit => 60,                         :null => false
    t.string   "prompt",        :limit => 60
    t.string   "required_flag", :limit => 1
    t.string   "input_type",    :limit => 30
    t.string   "uuid",          :limit => 22
    t.integer  "seq_num"
    t.string   "other_input",   :limit => 150
    t.string   "status_code",   :limit => 30,  :default => "ENABLED"
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csi_survey_subjects", ["opu_id", "survey_id"], :name => "CSI_SURVEY_SUBJECTS_N1"

  create_table "csi_surveys", :force => true do |t|
    t.string   "opu_id",                :limit => 22,                          :null => false
    t.string   "survey_code",           :limit => 30
    t.string   "title",                 :limit => 60,                          :null => false
    t.string   "description",           :limit => 150
    t.string   "email_notify",          :limit => 1
    t.string   "notify_url",            :limit => 150
    t.string   "notify_type",           :limit => 30
    t.string   "thanks_message",        :limit => 1000
    t.string   "publish_response",      :limit => 1
    t.string   "comment_flag",          :limit => 1
    t.string   "password",              :limit => 30
    t.date     "closed_datetime"
    t.string   "same_ip_allow_flag",    :limit => 1
    t.string   "with_incident_request", :limit => 1,    :default => "N"
    t.integer  "due_dates"
    t.string   "author_id",             :limit => 22
    t.string   "result_only_author",    :limit => 1,    :default => "N"
    t.string   "status_code",           :limit => 30,   :default => "ENABLED"
    t.string   "created_by",            :limit => 22
    t.string   "updated_by",            :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csi_surveys", ["opu_id", "title"], :name => "CSI_SURVEYS_N1"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",                 :default => 0
    t.integer  "attempts",                 :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "opu_id",      :limit => 22
    t.string   "created_by", :limit => 22
    t.string   "updated_by", :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "DELAYED_JOBS_N1"

  create_table "icm_close_reasons", :force => true do |t|
    t.string   "opu_id",      :limit => 22, :null => false
    t.string   "close_code",  :limit => 30, :null => false
    t.string   "status_code", :limit => 30, :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_close_reasons", ["close_code"], :name => "ICM_CLOSE_REASONS_N1"

  create_table "icm_close_reasons_tl", :force => true do |t|
    t.string   "opu_id",          :limit => 22
    t.string   "close_reason_id", :limit => 22
    t.string   "language",        :limit => 30,  :null => false
    t.string   "name",            :limit => 150
    t.string   "description",     :limit => 240
    t.string   "source_lang",     :limit => 30,  :null => false
    t.string   "status_code",     :limit => 30,  :null => false
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_close_reasons_tl", ["close_reason_id", "language"], :name => "ICM_CLOSE_REASONS_TL_U1", :unique => true
  add_index "icm_close_reasons_tl", ["close_reason_id"], :name => "ICM_CLOSE_REASONS_TL_N1"

  execute('CREATE OR REPLACE VIEW icm_close_reasons_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_close_reasons  t,icm_close_reasons_tl tl
                                             WHERE t.id = tl.close_reason_id')

  create_table "icm_group_assignments", :force => true do |t|
    t.string   "support_group_id", :limit => 22, :null => false
    t.string   "source_type",      :limit => 30, :null => false
    t.string   "source_id",        :limit => 22
    t.string   "opu_id",      :limit => 22
    t.string   "status_code",      :limit => 30, :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icm_impact_ranges", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                  :null => false
    t.string   "impact_code",      :limit => 60,                  :null => false
    t.integer  "display_sequence",               :default => 10
    t.string   "default_flag",     :limit => 1,  :default => "N"
    t.integer  "weight_values",                                   :null => false
    t.string   "status_code",      :limit => 30,                  :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_impact_ranges", ["impact_code"], :name => "ICM_IMPACT_RANGES_N1"

  create_table "icm_impact_ranges_tl", :force => true do |t|
    t.string   "opu_id",          :limit => 22
    t.string   "impact_range_id", :limit => 22
    t.string   "language",        :limit => 30,  :null => false
    t.string   "name",            :limit => 150, :null => false
    t.string   "description",     :limit => 240, :null => false
    t.string   "source_lang",     :limit => 30,  :null => false
    t.string   "status_code",     :limit => 30,  :null => false
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_impact_ranges_tl", ["impact_range_id", "language"], :name => "ICM_IMPACT_RANGES_TL_U1", :unique => true
  add_index "icm_impact_ranges_tl", ["impact_range_id"], :name => "ICM_IMPACT_RANGES_TL_N1"

  execute('CREATE OR REPLACE VIEW icm_impact_ranges_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_impact_ranges t,icm_impact_ranges_tl tl
                                             WHERE t.id = tl.impact_range_id')

  create_table "icm_incident_histories", :force => true do |t|
    t.string   "opu_id",       :limit => 22
    t.string   "request_id",   :limit => 22
    t.string   "journal_id",   :limit => 22
    t.string   "batch_number", :limit => 30
    t.string   "property_key", :limit => 60
    t.string   "old_value",    :limit => 60
    t.string   "new_value",    :limit => 60
    t.integer  "elapsed_time"
    t.string   "status_code",  :limit => 30, :null => false
    t.string   "created_by",   :limit => 22
    t.string   "updated_by",   :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_histories", ["journal_id"], :name => "ICM_INCIDENT_HISTORIES_N2"
  add_index "icm_incident_histories", ["request_id"], :name => "ICM_INCIDENT_HISTORIES_N1"

  create_table "icm_incident_journal_elapses", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                        :null => false
    t.string   "incident_journal_id", :limit => 22,                        :null => false
    t.string   "elapse_type",         :limit => 30
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "distance"
    t.integer  "real_distance"
    t.string   "status_code",         :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",          :limit => 22,                        :null => false
    t.string   "updated_by",          :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icm_incident_journals", :force => true do |t|
    t.string   "opu_id",              :limit => 22
    t.string   "incident_request_id", :limit => 22, :null => false
    t.string   "reply_type",          :limit => 30
    t.integer  "replied_by",                        :null => false
    t.text     "message_body",                      :null => false
    t.string   "status_code",         :limit => 30, :null => false
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_journals", ["incident_request_id"], :name => "ICM_INCIDENT_JOURNALS_N1"
  add_index "icm_incident_journals", ["replied_by"], :name => "ICM_INCIDENT_JOURNALS_N2"

  create_table "icm_incident_phases", :force => true do |t|
    t.string   "opu_id",           :limit => 22, :null => false
    t.string   "phase_code",       :limit => 30, :null => false
    t.integer  "display_sequence"
    t.string   "status_code",      :limit => 30, :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_phases", ["phase_code"], :name => "ICM_INCIDENT_PHASES_N1"

  create_table "icm_incident_phases_tl", :force => true do |t|
    t.string   "opu_id",            :limit => 22
    t.string   "incident_phase_id", :limit => 22
    t.string   "language",          :limit => 30,  :null => false
    t.string   "name",              :limit => 150
    t.string   "description",       :limit => 240
    t.string   "source_lang",       :limit => 30,  :null => false
    t.string   "status_code",       :limit => 30,  :null => false
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_phases_tl", ["incident_phase_id", "language"], :name => "ICM_INCIDENT_PHASES_TL_U1", :unique => true
  add_index "icm_incident_phases_tl", ["incident_phase_id"], :name => "ICM_INCIDENT_PHASES_TL_N1"

  execute('CREATE OR REPLACE VIEW icm_incident_phases_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_incident_phases t,icm_incident_phases_tl tl
                                             WHERE t.id = tl.incident_phase_id')

  create_table "icm_incident_requests", :force => true do |t|
    t.string   "request_number",          :limit => 30
    t.string   "title",                   :limit => 150, :null => false
    t.text     "summary",                                :null => false
    t.string   "external_system_id",      :limit => 22
    t.string   "service_code",            :limit => 30
    t.integer  "requested_by"
    t.string   "organization_id",         :limit => 22
    t.integer  "submitted_by"
    t.integer  "weight_value",                           :null => false
    t.string   "contact_id",              :limit => 22
    t.string   "contact_number",          :limit => 30
    t.string   "request_type_code",       :limit => 30
    t.string   "report_source_code",      :limit => 30
    t.string   "incident_status_id",      :limit => 22
    t.string   "priority_id",             :limit => 22
    t.string   "impact_range_id",         :limit => 22
    t.string   "urgence_id",              :limit => 22
    t.string   "close_reason_id",         :limit => 22
    t.string   "support_group_id",        :limit => 22
    t.string   "support_person_id",       :limit => 22
    t.string   "upgrade_group_id",        :limit => 22
    t.string   "upgrade_person_id",       :limit => 22
    t.string   "charge_group_id",         :limit => 22
    t.string   "charge_person_id",        :limit => 22
    t.datetime "submitted_date"
    t.datetime "last_request_date"
    t.datetime "last_response_date"
    t.string   "next_reply_user_license", :limit => 30
    t.string   "opu_id",                  :limit => 22,  :null => false
    t.string   "status_code",             :limit => 30,  :null => false
    t.string   "created_by",              :limit => 22
    t.string   "updated_by",              :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_requests", ["contact_id"], :name => "ICM_INCIDENT_REQUESTS_N3"
  add_index "icm_incident_requests", ["opu_id"], :name => "ICM_INCIDENT_REQUESTS_N4"
  add_index "icm_incident_requests", ["requested_by"], :name => "ICM_INCIDENT_REQUESTS_N2"
  add_index "icm_incident_requests", ["submitted_by"], :name => "ICM_INCIDENT_REQUESTS_N1"

  create_table "icm_incident_statuses", :force => true do |t|
    t.string   "opu_id",               :limit => 22,                  :null => false
    t.string   "incident_status_code", :limit => 30,                  :null => false
    t.string   "phase_code",           :limit => 30
    t.integer  "display_sequence"
    t.string   "default_flag",         :limit => 1,  :default => "N"
    t.string   "close_flag",           :limit => 1,  :default => "N", :null => false
    t.string   "status_code",          :limit => 30,                  :null => false
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_statuses", ["incident_status_code"], :name => "ICM_INCIDENT_STATUSES_N1"

  create_table "icm_incident_statuses_tl", :force => true do |t|
    t.string   "opu_id",             :limit => 22
    t.string   "incident_status_id", :limit => 22
    t.string   "language",           :limit => 30,  :null => false
    t.string   "name",               :limit => 150
    t.string   "description",        :limit => 240
    t.string   "source_lang",        :limit => 30,  :null => false
    t.string   "status_code",        :limit => 30,  :null => false
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_incident_statuses_tl", ["incident_status_id", "language"], :name => "ICM_INCIDENT_STATUSES_TL_U1", :unique => true
  add_index "icm_incident_statuses_tl", ["incident_status_id"], :name => "ICM_INCIDENT_STATUSES_TL_N1"

  execute('CREATE OR REPLACE VIEW icm_incident_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_incident_statuses t,icm_incident_statuses_tl tl
                                             WHERE t.id = tl.incident_status_id')

  create_table "icm_priority_codes", :force => true do |t|
    t.string   "opu_id",        :limit => 22, :null => false
    t.string   "priority_code", :limit => 60, :null => false
    t.integer  "weight_values",               :null => false
    t.string   "status_code",   :limit => 30, :null => false
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_priority_codes", ["priority_code"], :name => "ICM_PRIORITY_CODES_N1"

  create_table "icm_priority_codes_tl", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "priority_code_id", :limit => 22
    t.string   "language",         :limit => 30,  :null => false
    t.string   "name",             :limit => 150
    t.string   "description",      :limit => 240
    t.string   "source_lang",      :limit => 30,  :null => false
    t.string   "status_code",      :limit => 30,  :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_priority_codes_tl", ["priority_code_id", "language"], :name => "ICM_PRIORITY_CODES_TL_U1", :unique => true
  add_index "icm_priority_codes_tl", ["priority_code_id"], :name => "ICM_PRIORITY_CODES_TL_N1"

  execute('CREATE OR REPLACE VIEW icm_priority_codes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                       FROM icm_priority_codes t,icm_priority_codes_tl tl
                       WHERE t.id = tl.priority_code_id')

  create_table "icm_rule_settings", :force => true do |t|
    t.string   "opu_id",                 :limit => 22,                         :null => false
    t.string   "description",            :limit => 150
    t.string   "report_date_changable",  :limit => 1,   :default => "N"
    t.string   "respond_date_changable", :limit => 1,   :default => "N"
    t.string   "slove_date_changable",   :limit => 1,   :default => "N"
    t.string   "auto_assignable",        :limit => 1,   :default => "N"
    t.integer  "auto_closure_days",                     :default => 5
    t.string   "status_code",            :limit => 30,  :default => "ENABLED"
    t.string   "created_by",             :limit => 22
    t.string   "updated_by",             :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icm_status_transforms", :force => true do |t|
    t.string   "opu_id",         :limit => 22,                        :null => false
    t.string   "from_status_id", :limit => 22,                        :null => false
    t.string   "to_status_id",   :limit => 22,                        :null => false
    t.string   "event_code",     :limit => 30,                        :null => false
    t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",     :limit => 22,                        :null => false
    t.string   "updated_by",     :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_status_transforms", ["from_status_id", "to_status_id"], :name => "IRM_STATUS_TRANSFORMS", :unique => true

  create_table "icm_support_groups", :force => true do |t|
    t.string   "group_id",                :limit => 22,                        :null => false
    t.string   "assignment_process_code", :limit => 30,                        :null => false
    t.string   "vendor_flag",             :limit => 1,  :default => "N",       :null => false
    t.string   "oncall_flag",             :limit => 1,  :default => "N",       :null => false
    t.string   "opu_id",                  :limit => 22,                        :null => false
    t.string   "status_code",             :limit => 30, :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icm_urgence_codes", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                  :null => false
    t.string   "urgency_code",     :limit => 60,                  :null => false
    t.string   "default_flag",     :limit => 1,  :default => "N"
    t.integer  "display_sequence",               :default => 10
    t.integer  "weight_values",                                   :null => false
    t.string   "status_code",      :limit => 30,                  :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_urgence_codes", ["urgency_code"], :name => "ICM_URGENCE_CODES_N1"

  create_table "icm_urgence_codes_tl", :force => true do |t|
    t.string   "opu_id",          :limit => 22
    t.string   "urgence_code_id", :limit => 22
    t.string   "language",        :limit => 30,  :null => false
    t.string   "name",            :limit => 150, :null => false
    t.string   "description",     :limit => 240, :null => false
    t.string   "source_lang",     :limit => 30,  :null => false
    t.string   "status_code",     :limit => 30,  :null => false
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icm_urgence_codes_tl", ["urgence_code_id", "language"], :name => "ICM_URGENCE_CODES_TL_U1", :unique => true
  add_index "icm_urgence_codes_tl", ["urgence_code_id"], :name => "ICM_URGENCE_CODES_TL_N1"

  execute('CREATE OR REPLACE VIEW icm_urgence_codes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_urgence_codes t,icm_urgence_codes_tl tl
                                             WHERE t.id = tl.urgence_code_id')

  create_table "irm_application_tabs", :force => true do |t|
    t.string   "application_id", :limit => 22,                        :null => false
    t.string   "tab_id",         :limit => 22,                        :null => false
    t.string   "default_flag",   :limit => 1,  :default => "N",       :null => false
    t.integer  "seq_num",                                             :null => false
    t.string   "opu_id",          :limit => 22
    t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",     :limit => 22,                        :null => false
    t.string   "updated_by",     :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_application_tabs", ["application_id", "tab_id"], :name => "IRM_APPLICATION_TABS_U1", :unique => true

  create_table "irm_applications", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "code",        :limit => 30,                        :null => false
    t.string   "image_id",    :limit => 22
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_applications_tl", :force => true do |t|
    t.string   "application_id", :limit => 22,                         :null => false
    t.string   "language",       :limit => 30,                         :null => false
    t.string   "name",           :limit => 150,                        :null => false
    t.string   "description",    :limit => 240
    t.string   "source_lang",    :limit => 30,                         :null => false
    t.string   "opu_id",          :limit => 22
    t.string   "status_code",    :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",     :limit => 22,                         :null => false
    t.string   "updated_by",     :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_applications_tl", ["application_id", "language"], :name => "IRM_APPLICATIONS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_applications_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_applications t,irm_applications_tl tl
                                           WHERE t.id = tl.application_id')

  create_table "irm_attachment_versions", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                   :null => false
    t.string   "attachment_id",     :limit => 22,                   :null => false
    t.string   "description",       :limit => 240
    t.string   "private_flag",      :limit => 1
    t.string   "image_flag",        :limit => 1,   :default => "Y"
    t.string   "category_id",       :limit => 22
    t.string   "source_type",       :limit => 30
    t.string   "source_id",         :limit => 22
    t.string   "data_file_name",    :limit => 150
    t.string   "data_content_type", :limit => 30
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "status_code",    :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_attachments", :force => true do |t|
    t.string   "opu_id",            :limit => 22,  :null => false
    t.string   "description",       :limit => 240
    t.string   "private_flag",      :limit => 1
    t.string   "latest_version_id", :limit => 22
    t.string   "file_name",         :limit => 150
    t.integer  "file_category"
    t.integer  "file_size"
    t.string   "file_type",         :limit => 30
    t.string   "status_code",       :limit => 30
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_bu_columns", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                        :null => false
    t.string   "parent_column_id", :limit => 22
    t.string   "bu_column_code",   :limit => 30,                        :null => false
    t.string   "status_code",      :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",       :limit => 22,                        :null => false
    t.string   "updated_by",       :limit => 22,                        :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "irm_bu_columns", ["bu_column_code","opu_id"], :name => "IRM_BU_COLUMNS_U1", :unique => true

  create_table "irm_bu_columns_tl", :force => true do |t|
    t.string   "opu_id",       :limit => 22,                         :null => false
    t.string   "bu_column_id", :limit => 22,                         :null => false
    t.string   "name",         :limit => 150,                        :null => false
    t.string   "description",  :limit => 240
    t.string   "language",     :limit => 30,                         :null => false
    t.string   "source_lang",  :limit => 30,                         :null => false
    t.string   "status_code",  :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",   :limit => 22,                         :null => false
    t.string   "updated_by",   :limit => 22,                         :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "irm_bu_columns_tl", ["bu_column_id", "language"], :name => "IRM_BU_COLUMNS_TL_U1", :unique => true
  add_index "irm_bu_columns_tl", ["bu_column_id"], :name => "IRM_BU_COLUMNS_TL_N1"

  execute('CREATE OR REPLACE VIEW irm_bu_columns_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_bu_columns t,irm_bu_columns_tl tl
                                           WHERE t.id = tl.bu_column_id')

  create_table "irm_bulletin_accesses", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "bulletin_id", :limit => 22,                        :null => false
    t.string   "access_type",                                      :null => false
    t.string   "access_id",   :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED"
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_bulletin_columns", :force => true do |t|
    t.string   "opu_id",       :limit => 22,                        :null => false
    t.string   "bulletin_id",  :limit => 22,                        :null => false
    t.string   "bu_column_id", :limit => 22,                        :null => false
    t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",   :limit => 22,                        :null => false
    t.string   "updated_by",   :limit => 22,                        :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "irm_bulletins", :force => true do |t|
    t.string   "opu_id",         :limit => 22,                          :null => false
    t.string   "title",          :limit => 150,                         :null => false
    t.string   "summary",        :limit => 240
    t.string   "content",        :limit => 3000
    t.string   "author_id",      :limit => 22
    t.string   "important_code", :limit => 30
    t.string   "sticky_flag",    :limit => 30,   :default => "N"
    t.string   "highlight_flag", :limit => 30,   :default => "N"
    t.integer  "page_views"
    t.string   "status_code",    :limit => 30,   :default => "ENABLED"
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_business_objects", :force => true do |t|
    t.string   "opu_id",               :limit => 22,                         :null => false
    t.string   "business_object_code", :limit => 30,                         :null => false
    t.string   "bo_table_name",        :limit => 60,                         :null => false
    t.string   "bo_model_name",        :limit => 150
    t.string   "auto_generate_flag",   :limit => 1,   :default => "Y",       :null => false
    t.string   "multilingual_flag",    :limit => 1,   :default => "N",       :null => false
    t.text     "sql_cache"
    t.string   "status_code",          :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_flag",        :limit => 1,   :default => "N"
  end

  add_index "irm_business_objects", ["business_object_code"], :name => "IRM_BUSINESS_OBJECTS_N1"

  create_table "irm_business_objects_tl", :force => true do |t|
    t.string   "opu_id",             :limit => 22,                         :null => false
    t.string   "business_object_id", :limit => 22,                         :null => false
    t.string   "name",               :limit => 60,                         :null => false
    t.string   "description",        :limit => 150
    t.string   "status_code",        :limit => 30,  :default => "ENABLED", :null => false
    t.string   "language",           :limit => 30
    t.string   "source_lang",        :limit => 30
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_business_objects_tl", ["business_object_id", "language"], :name => "IRM_BUSINESS_OBJECTS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_business_objects_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_business_objects  t,irm_business_objects_tl tl
                                             WHERE t.id = tl.business_object_id')

  create_table "irm_calendars", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.integer  "assigned_to"
    t.string   "current",     :limit => 1
    t.string   "name",        :limit => 150,                         :null => false
    t.string   "description", :limit => 3000
    t.string   "status_code", :limit => 30,   :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_cards", :force => true do |t|
    t.string   "card_code",                  :limit => 30,                        :null => false
    t.string   "background_color",           :limit => 30
    t.string   "font_color",                 :limit => 30
    t.string   "bo_code",                    :limit => 30
    t.string   "rule_filter_id",             :limit => 22
    t.string   "system_flag",                :limit => 1,  :default => "N",       :null => false
    t.text     "card_url"
    t.string   "title_attribute_name",       :limit => 30
    t.string   "description_attribute_name", :limit => 30
    t.string   "date_attribute_name",        :limit => 30
    t.string   "opu_id",      :limit => 22
    t.string   "status_code",                :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",                 :limit => 22
    t.string   "updated_by",                 :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_cards", ["card_code","opu_id"], :name => "IRM_CARD_TYPE_U1", :unique => true

  create_table "irm_cards_tl", :force => true do |t|
    t.string   "card_id",     :limit => 22
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "opu_id",           :limit => 22
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_cards_tl", ["card_id", "language"], :name => "IRM_CARDS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_cards_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_cards  t,irm_cards_tl tl
                                           WHERE t.id = tl.card_id')

  create_table "irm_currencies", :force => true do |t|
    t.string   "currency_code", :limit => 30, :null => false
    t.integer  "precision"
    t.string   "opu_id",           :limit => 22
    t.string   "status_code",   :limit => 30, :null => false
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_currencies", ["currency_code"], :name => "IRM_CURRENCIES_U1"

  create_table "irm_currencies_tl", :force => true do |t|
    t.string   "currency_id", :limit => 22
    t.string   "language",    :limit => 30,  :null => false
    t.string   "name",        :limit => 150, :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,  :null => false
    t.string   "opu_id",           :limit => 22
    t.string   "status_code", :limit => 30,  :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_currencies_tl", ["currency_id", "language"], :name => "IRM_CURRENCIES_TL_U1"

  execute('CREATE OR REPLACE VIEW irm_currencies_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_currencies  t,irm_currencies_tl tl
                                             WHERE t.id = tl.currency_id')

  create_table "irm_delayed_job_log_items", :force => true do |t|
    t.string   "delayed_job_id", :limit => 22
    t.text     "content"
    t.string   "job_status",     :limit => 30
    t.string   "opu_id",           :limit => 22
    t.string   "status_code",    :limit => 30, :default => "ENABLED"
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_delayed_job_logs", :force => true do |t|
    t.string   "delayed_job_id", :limit => 22
    t.string   "instance_id",    :limit => 22
    t.string   "bo_code",        :limit => 30
    t.integer  "priority"
    t.integer  "attempts"
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "end_at"
    t.datetime "failed_at"
    t.datetime "locked_at"
    t.text     "locked_by"
    t.string   "opu_id",           :limit => 22
    t.string   "status_code",    :limit => 30, :default => "ENABLED"
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_delayed_jobs_record_items", :force => true do |t|
    t.text     "error_info"
    t.integer  "attempt"
    t.datetime "record_at"
    t.string   "pid",        :limit => 22
    t.string   "opu_id",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_delayed_jobs_records", :force => true do |t|
    t.integer  "priority",                     :default => 0
    t.text     "handler"
    t.text     "run_by"
    t.datetime "run_at"
    t.datetime "end_at"
    t.integer  "status"
    t.string   "delayed_job_id", :limit => 22
    t.string   "opu_id",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_events", :force => true do |t|
    t.string   "opu_id",             :limit => 22
    t.string   "event_code",         :limit => 30, :null => false
    t.string   "bo_code",            :limit => 30
    t.string   "business_object_id", :limit => 22
    t.string   "event_type",         :limit => 30
    t.text     "params"
    t.datetime "end_at"
    t.string   "last_error"
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_events", ["event_code"], :name => "IRM_EVENTS_N1"

  create_table "irm_external_system_people", :force => true do |t|
    t.string   "opu_id",             :limit => 22
    t.string   "external_system_id", :limit => 22
    t.string   "person_id",          :limit => 22
    t.string   "status_code",        :limit => 30, :default => "ENABLED"
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_external_systems", :force => true do |t|
    t.string   "opu_id",               :limit => 22,                         :null => false
    t.string   "external_system_code", :limit => 30
    t.string   "external_hostname",    :limit => 150
    t.string   "external_ip_address",  :limit => 30
    t.string   "status_code",          :limit => 30,  :default => "ENABLED"
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_external_systems", ["opu_id", "external_system_code"], :name => "IRM_EXTERNAL_SYSTEMS_N1"

  create_table "irm_external_systems_tl", :force => true do |t|
    t.string "opu_id",             :limit => 22,  :null => false
    t.string "external_system_id", :limit => 22
    t.string "system_name",        :limit => 30
    t.string "system_description", :limit => 150, :null => false
    t.string "language",           :limit => 30,  :null => false
    t.string "source_lang",        :limit => 30,  :null => false
    t.string "status_code",        :limit => 30,  :null => false
    t.string "created_by",         :limit => 22
    t.string "updated_by",         :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "irm_external_systems_tl", ["external_system_id", "language"], :name => "IRM_EXTERNAL_SYSTEMS_TL_N1"

  execute('CREATE OR REPLACE VIEW irm_external_systems_vl AS SELECT t.*,tl.id lang_id,tl.system_name,tl.system_description,tl.language,tl.source_lang
                                             FROM irm_external_systems  t,irm_external_systems_tl tl
                                             WHERE t.id = tl.external_system_id')

  create_table "irm_flex_value_sets", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "flex_value_set_name", :limit => 150,                        :null => false
    t.string   "description",         :limit => 240
    t.string   "validation_type",     :limit => 30
    t.string   "status_code",         :limit => 30,  :default => "ENABLED"
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_flex_values", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "flex_value_set_id", :limit => 22,                        :null => false
    t.string   "flex_value",        :limit => 30,                        :null => false
    t.integer  "display_sequence",                :default => 10
    t.datetime "start_date_active"
    t.datetime "end_date_active"
    t.string   "status_code",       :limit => 30, :default => "ENABLED"
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_flex_values", ["flex_value","opu_id"], :name => "IRM_FLEX_VALUES_U1", :unique => true

  create_table "irm_flex_values_tl", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "flex_value_id",      :limit => 22,                         :null => false
    t.string   "flex_value_meaning", :limit => 150,                        :null => false
    t.string   "description",        :limit => 240
    t.string   "language",           :limit => 30,                         :null => false
    t.string   "source_lang",        :limit => 30,                         :null => false
    t.string   "status_code",        :limit => 30,  :default => "ENABLED"
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_flex_values_tl", ["flex_value_id", "language"], :name => "IRM_FLEX_VALUES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_flex_values_vl AS SELECT t.*,tl.id lang_id,tl.flex_value_meaning,tl.description,tl.language,tl.source_lang
                                             FROM irm_flex_values  t,irm_flex_values_tl tl
                                             WHERE t.id = tl.flex_value_id')

  create_table "irm_formula_functions", :force => true do |t|
    t.string   "opu_id",        :limit => 22,                         :null => false
    t.string   "function_code", :limit => 30,                         :null => false
    t.string   "parameters",    :limit => 150
    t.string   "function_type", :limit => 30,                         :null => false
    t.string   "status_code",   :limit => 30,  :default => "ENABLED"
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_formula_functions", ["function_code","opu_id"], :name => "IRM_FORMULA_FUNCTIONS_U1", :unique => true

  create_table "irm_formula_functions_tl", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                         :null => false
    t.string   "formula_function_id", :limit => 22,                         :null => false
    t.string   "description",         :limit => 150
    t.string   "language",            :limit => 30
    t.string   "source_lang",         :limit => 30
    t.string   "status_code",         :limit => 30,  :default => "ENABLED"
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_formula_functions_tl", ["formula_function_id", "language"], :name => "IRM_FORMULA_FUNCTIONS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_formula_functions_vl AS SELECT t.*,tl.id lang_id,tl.description,tl.language,tl.source_lang
                                                 FROM irm_formula_functions t,irm_formula_functions_tl tl
                                                 WHERE t.id = tl.formula_function_id')


  create_table "irm_function_groups", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "zone_code",   :limit => 30,                        :null => false
    t.string   "code",        :limit => 30,                        :null => false
    t.string   "controller",  :limit => 60,                        :null => false
    t.string   "action",      :limit => 30,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_function_groups", ["code","opu_id"], :name => "IRM_FUNCTION_GROUPS_U1", :unique => true

  create_table "irm_function_groups_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "function_group_id", :limit => 22,                         :null => false
    t.string   "language",          :limit => 30,                         :null => false
    t.string   "name",              :limit => 150,                        :null => false
    t.string   "description",       :limit => 240
    t.string   "source_lang",       :limit => 30,                         :null => false
    t.string   "status_code",       :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",        :limit => 22,                         :null => false
    t.string   "updated_by",        :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_function_groups_tl", ["function_group_id", "language"], :name => "IRM_FUNCTION_GROUPS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_function_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_function_groups t,irm_function_groups_tl tl
                                             WHERE t.id = tl.function_group_id')

  create_table "irm_functions", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                        :null => false
    t.string   "function_group_id", :limit => 22,                        :null => false
    t.string   "code",              :limit => 30,                        :null => false
    t.string   "login_flag",        :limit => 1,  :default => "N",       :null => false
    t.string   "public_flag",       :limit => 1,  :default => "N",       :null => false
    t.string   "default_flag",      :limit => 1,  :default => "N",       :null => false
    t.string   "status_code",       :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",        :limit => 22,                        :null => false
    t.string   "updated_by",        :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_functions", ["code","opu_id"], :name => "IRM_FUNCTIONS_U1", :unique => true

  create_table "irm_functions_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "function_id", :limit => 22,                         :null => false
    t.string   "language",    :limit => 30,                         :null => false
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,                         :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                         :null => false
    t.string   "updated_by",  :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_functions_tl", ["function_id", "language"], :name => "IRM_FUNCTIONS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_functions_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_functions  t,irm_functions_tl tl
                                             WHERE t.id = tl.function_id')

  create_table "irm_general_categories", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "category_type",   :limit => 30
    t.string   "segment1",        :limit => 30
    t.string   "segment2",        :limit => 30
    t.string   "segment3",        :limit => 30
    t.string   "concact_segment", :limit => 90
    t.string   "status_code",     :limit => 30, :default => "ENABLED"
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "irm_group_explosions", :force => true do |t|
    t.string   "parent_group_id",        :limit => 22,                        :null => false
    t.string   "direct_parent_group_id", :limit => 22,                        :null => false
    t.string   "group_id",               :limit => 22,                        :null => false
    t.string   "opu_id",                 :limit => 22,                        :null => false
    t.string   "status_code",            :limit => 30, :default => "ENABLED"
    t.string   "created_by",             :limit => 22,                        :null => false
    t.string   "updated_by",             :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_group_explosions", ["parent_group_id", "direct_parent_group_id", "group_id"], :name => "IRM_GROUP_EXPLOSIONS_U1", :unique => true

  create_table "irm_group_members", :force => true do |t|
    t.string   "group_id",    :limit => 22,                        :null => false
    t.string   "person_id",   :limit => 22,                        :null => false
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_group_members", ["group_id", "person_id"], :name => "IRM_GROUP_MEMBERS_U1", :unique => true

  create_table "irm_groups", :force => true do |t|
    t.string   "parent_group_id", :limit => 22,                        :null => false
    t.string   "code",            :limit => 30,                        :null => false
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "status_code",     :limit => 30, :default => "ENABLED"
    t.string   "created_by",      :limit => 22,                        :null => false
    t.string   "updated_by",      :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_groups_tl", :force => true do |t|
    t.string   "group_id",    :limit => 22,                         :null => false
    t.string   "name",        :limit => 30,                         :null => false
    t.string   "description", :limit => 150
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "opu_id",      :limit => 22,                         :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_groups_tl", ["group_id", "language"], :name => "IRM_GROUPS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_groups t,irm_groups_tl tl
                                                 WHERE t.id = tl.group_id')

  create_table "irm_id_flex_segments", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "id_flex_code",        :limit => 30,                   :null => false
    t.integer  "id_flex_num",                                         :null => false
    t.integer  "segment_num",                                         :null => false
    t.string   "segment_name",        :limit => 150,                  :null => false
    t.string   "display_flag",        :limit => 1,   :default => "Y"
    t.integer  "display_size"
    t.string   "default_type",        :limit => 30
    t.string   "default_value",       :limit => 240
    t.string   "flex_value_set_name", :limit => 30
    t.string   "status_code",         :limit => 30
    t.string   "created_by",          :limit => 22,                   :null => false
    t.string   "updated_by",          :limit => 22,                   :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "irm_id_flex_segments", ["segment_name","opu_id"], :name => "IRM_ID_FLEX_SEGMENTS_U1", :unique => true

  create_table "irm_id_flex_segments_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "segment_name",      :limit => 150, :null => false
    t.string   "form_left_prompt",  :limit => 150
    t.string   "form_above_prompt", :limit => 150
    t.string   "description",       :limit => 240
    t.string   "language",          :limit => 30
    t.string   "source_lang",       :limit => 30
    t.string   "status_code",       :limit => 30
    t.string   "created_by",        :limit => 22,  :null => false
    t.string   "updated_by",        :limit => 22,  :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  execute('CREATE OR REPLACE VIEW irm_flex_segments_vl AS SELECT t.*,tl.id lang_id, tl.form_left_prompt, tl.form_above_prompt,tl.description,tl.language,tl.source_lang
                                             FROM irm_id_flex_segments  t,irm_id_flex_segments_tl tl
                                             WHERE t.segment_name = tl.segment_name')

  create_table "irm_id_flex_structures", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "id_flex_code",                   :limit => 30, :null => false
    t.integer  "id_flex_num",                                  :null => false
    t.string   "id_flex_structure_code",         :limit => 30, :null => false
    t.string   "concatenated_segment_delimiter"
    t.string   "freeze_flex_definition_flag"
    t.string   "status_code",                    :limit => 30
    t.string   "created_by",                     :limit => 22, :null => false
    t.string   "updated_by",                     :limit => 22, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "irm_id_flex_structures", ["id_flex_structure_code","opu_id"], :name => "IRM_ID_FLEX_STRUCTURES_U1", :unique => true

  create_table "irm_id_flex_structures_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "id_flex_structure_id",   :limit => 22
    t.string   "id_flex_structure_name", :limit => 150, :null => false
    t.string   "description",            :limit => 240
    t.string   "language",               :limit => 30
    t.string   "source_lang",            :limit => 30
    t.string   "status_code",            :limit => 30
    t.string   "created_by",             :limit => 22,  :null => false
    t.string   "updated_by",             :limit => 22,  :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "irm_id_flex_structures_tl", ["language", "id_flex_structure_id"], :name => "IRM_ID_FLEX_STRUCTURES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_id_flex_structures_vl AS SELECT t.*,tl.id lang_id,tl.id_flex_structure_name,
                                             tl.description,tl.language,tl.source_lang
                                             FROM irm_id_flex_structures  t,irm_id_flex_structures_tl tl
                                             WHERE t.id = tl.id_flex_structure_id')

  create_table "irm_id_flexes", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "id_flex_code", :limit => 30,  :null => false
    t.string   "id_flex_name", :limit => 150
    t.string   "description",  :limit => 240
    t.string   "status_code",  :limit => 30
    t.string   "created_by",   :limit => 22,  :null => false
    t.string   "updated_by",   :limit => 22,  :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "irm_id_flexes", ["id_flex_code","opu_id"], :name => "IRM_ID_FLEXES_U1", :unique => true

  create_table "irm_kanban_lanes", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "kanban_id",        :limit => 22
    t.string   "lane_id",          :limit => 22
    t.integer  "display_sequence",               :default => 1,         :null => false
    t.string   "status_code",      :limit => 30, :default => "ENABLED", :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_kanban_ranges", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "kanban_id",   :limit => 22,                        :null => false
    t.string   "range_type",  :limit => 30,                        :null => false
    t.string   "range_id",    :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_kanbans", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.integer  "limit",                          :default => 5
    t.integer  "refresh_interval",               :default => 5
    t.string   "kanban_code",      :limit => 30,                        :null => false
    t.string   "status_code",      :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position_code",    :limit => 30
  end

  add_index "irm_kanbans", ["kanban_code","opu_id"], :name => "IRM_KANBAN_TYPE_U1", :unique => true

  create_table "irm_kanbans_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "kanban_id",   :limit => 22
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_kanbans_tl", ["kanban_id", "language"], :name => "IRM_KANBANS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_kanbans_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_kanbans  t,irm_kanbans_tl tl
                                           WHERE t.id = tl.kanban_id')

  create_table "irm_lane_cards", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "lane_id",     :limit => 22
    t.string   "card_id",     :limit => 22
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_lanes", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "lane_code",   :limit => 30,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_lanes", ["lane_code","opu_id"], :name => "IRM_LANE_TYPE_U1", :unique => true

  create_table "irm_lanes_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "lane_id",     :limit => 22
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_lanes_tl", ["lane_id", "language"], :name => "IRM_LANES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_lanes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_lanes  t,irm_lanes_tl tl
                                           WHERE t.id = tl.lane_id')

  create_table "irm_languages", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "language_code",  :limit => 30, :null => false
    t.string   "installed_flag", :limit => 1,  :null => false
    t.string   "status_code",    :limit => 30, :null => false
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_languages", ["language_code"], :name => "IRM_LANGUAGES_U1", :unique => true

  create_table "irm_languages_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "language_id", :limit => 22,  :null => false
    t.string   "description", :limit => 150, :null => false
    t.string   "language",    :limit => 30,  :null => false
    t.string   "source_lang", :limit => 30,  :null => false
    t.string   "status_code", :limit => 30,  :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_languages_tl", ["language_id", "language"], :name => "IRM_LANGUAGES_TL_N1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_languages_vl AS SELECT t.*,tl.id lang_id,tl.description,tl.language,tl.source_lang
                                             FROM irm_languages  t,irm_languages_tl tl
                                             WHERE t.id = tl.language_id')

  create_table "irm_ldap_auth_attributes", :force => true do |t|
    t.string "ldap_auth_header_id", :limit => 22,  :null => false
    t.string "local_attr",          :limit => 60,  :null => false
    t.string "attr_type",           :limit => 60
    t.string "ldap_attr",           :limit => 60,  :null => false
    t.string "opu_id",              :limit => 22,  :null => false
    t.string "description",         :limit => 150
    t.string "status_code",         :limit => 30,  :null => false
    t.string "created_by",          :limit => 22
    t.string "updated_by",          :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  create_table "irm_ldap_auth_headers", :force => true do |t|
    t.string "ldap_source_id",          :limit => 22,  :null => false
    t.string "name",                    :limit => 60,  :null => false
    t.string "auth_cn",                                :null => false
    t.string "ldap_login_name_attr",    :limit => 30,  :null => false
    t.string "ldap_email_address_attr", :limit => 30
    t.string "template_person_id",      :limit => 22
    t.string "opu_id",                  :limit => 22,  :null => false
    t.string "description",             :limit => 150
    t.string "status_code",             :limit => 30,  :null => false
    t.string "created_by",              :limit => 22
    t.string "updated_by",              :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  create_table "irm_ldap_sources", :force => true do |t|
    t.string  "type",             :limit => 30
    t.string  "name",             :limit => 150, :null => false
    t.string  "host",             :limit => 150, :null => false
    t.integer "port",                            :null => false
    t.string  "account",          :limit => 60,  :null => false
    t.string  "account_password", :limit => 60,  :null => false
    t.string  "base_dn"
    t.string  "opu_id",           :limit => 22,  :null => false
    t.string  "description",      :limit => 150
    t.string  "status_code",      :limit => 30,  :null => false
    t.string  "created_by",       :limit => 22
    t.string  "updated_by",       :limit => 22
    t.date    "created_at"
    t.date    "updated_at"
  end

  create_table "irm_ldap_syn_attributes", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string "ldap_syn_header_id", :limit => 22,  :null => false
    t.string "local_attr",         :limit => 60,  :null => false
    t.string "local_attr_type",    :limit => 30
    t.string "ldap_attr",          :limit => 60,  :null => false
    t.string "ldap_attr_type",     :limit => 30
    t.string "object_type",        :limit => 30,  :null => false
    t.string "null_able",          :limit => 10,  :null => false
    t.string "language_code",      :limit => 10
    t.string "opu_id",             :limit => 22,  :null => false
    t.string "description",        :limit => 150
    t.string "status_code",        :limit => 30,  :null => false
    t.string "created_by",         :limit => 22
    t.string "updated_by",         :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  create_table "irm_ldap_syn_headers", :force => true do |t|
    t.string  "name",                :limit => 60,                   :null => false
    t.string  "ldap_source_id",      :limit => 22,                   :null => false
    t.string  "base_dn",             :limit => 150
    t.string  "comp_filter",         :limit => 150
    t.string  "comp_object",         :limit => 30,                   :null => false
    t.integer "comp_level",                         :default => 1
    t.string  "comp_desc",           :limit => 150
    t.string  "comp_syn_flag",       :limit => 1,   :default => "Y"
    t.string  "org_filter",          :limit => 150
    t.string  "org_object",          :limit => 30,                   :null => false
    t.string  "org_syn_flag",        :limit => 1,   :default => "Y"
    t.integer "org_level",                          :default => 2
    t.string  "org_desc",            :limit => 150
    t.string  "dept_filter",         :limit => 150
    t.string  "dept_object",         :limit => 30,                   :null => false
    t.string  "dept_syn_flag",       :limit => 1,   :default => "Y"
    t.integer "dept_level",                         :default => 3
    t.string  "dept_desc",           :limit => 150
    t.string  "peo_syn_flag",        :limit => 1,   :default => "N"
    t.integer "peo_level",                          :default => 4
    t.string  "ldap_auth_header_id", :limit => 22
    t.string  "opu_id",              :limit => 22,                   :null => false
    t.string  "status_code",         :limit => 30
    t.string  "created_by",          :limit => 22
    t.string  "updated_by",          :limit => 22
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "language",            :limit => 30
    t.string  "source_lang",         :limit => 30
    t.string  "syn_status",          :limit => 20
  end

  create_table "irm_ldap_syn_interface", :force => true do |t|
    t.string   "process_id",            :limit => 22
    t.string   "comp_short_name",       :limit => 30
    t.string   "comp_company_type",     :limit => 30
    t.string   "comp_time_zone",        :limit => 30
    t.string   "comp_currency_code",    :limit => 30
    t.string   "comp_cost_center_code", :limit => 30
    t.string   "comp_budget_code",      :limit => 30
    t.string   "comp_hotline",          :limit => 30
    t.string   "comp_home_page",        :limit => 60
    t.integer  "comp_support_manager"
    t.string   "comp_type",             :limit => 60
    t.string   "comp_name",             :limit => 150
    t.string   "comp_description",      :limit => 240
    t.string   "comp_status_code",      :limit => 30
    t.string   "comp_dn",               :limit => 150
    t.string   "org_short_name",        :limit => 30
    t.string   "org_status_code",       :limit => 30
    t.string   "org_name",              :limit => 150
    t.string   "org_description",       :limit => 240
    t.string   "org_dn",                :limit => 150
    t.string   "dept_short_name",       :limit => 30
    t.string   "dept_status_code",      :limit => 30
    t.string   "dept_name",             :limit => 150
    t.string   "dept_description",      :limit => 240
    t.string   "dept_dn",               :limit => 150
    t.string   "language",              :limit => 30
    t.string   "source_lang",           :limit => 30
    t.string   "process_status",        :limit => 30
    t.string   "created_by",            :limit => 22
    t.string   "updated_by",            :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "opu_id",                :limit => 22
    t.string   "organization_id",       :limit => 22
    t.string   "department_id",         :limit => 22
  end

  create_table "irm_ldap_syn_peo_interface", :force => true do |t|
    t.string   "process_id",                   :limit => 22
    t.string   "opu_id",                       :limit => 22
    t.string   "organization_id",              :limit => 22
    t.string   "department_id",                :limit => 22
    t.string   "title",                        :limit => 30
    t.string   "first_name",                   :limit => 30
    t.string   "last_name",                    :limit => 30
    t.string   "job_title",                    :limit => 30
    t.string   "vip_flag",                     :limit => 1,   :default => "N"
    t.string   "support_staff_flag",           :limit => 1,   :default => "N"
    t.string   "assignment_availability_flag", :limit => 1,   :default => "N"
    t.string   "email_address",                :limit => 150
    t.string   "home_phone",                   :limit => 30
    t.string   "home_address",                 :limit => 30
    t.string   "mobile_phone",                 :limit => 30
    t.string   "fax_number",                   :limit => 30
    t.string   "bussiness_phone",              :limit => 30
    t.string   "region_code",                  :limit => 30
    t.string   "site_group_code",              :limit => 30
    t.string   "site_code",                    :limit => 30
    t.string   "function_group_code",          :limit => 30
    t.string   "avatar_path",                  :limit => 150
    t.string   "avatar_file_name",             :limit => 30
    t.string   "avatar_content_type",          :limit => 30
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "identity_id",                  :limit => 22
    t.string   "approve_request_mail",         :limit => 30
    t.string   "manager",                      :limit => 30
    t.string   "delegate_approver",            :limit => 30
    t.string   "last_login_at",                :limit => 30
    t.string   "type",                         :limit => 30
    t.string   "language_code",                :limit => 30
    t.string   "auth_source_id",               :limit => 22
    t.string   "hashed_password",              :limit => 60
    t.string   "login_name",                   :limit => 30
    t.string   "unrestricted_access_flag",     :limit => 30
    t.string   "notification_lang",            :limit => 30
    t.string   "notification_flag",            :limit => 30
    t.string   "capacity_rating",              :limit => 30
    t.integer  "open_tickets"
    t.string   "task_capacity_rating",         :limit => 30
    t.integer  "open_tasks"
    t.datetime "last_assigned_date"
    t.string   "ldap_dn",                      :limit => 200
    t.string   "status_code",                  :limit => 30,  :default => "ENABLED"
    t.string   "created_by",                   :limit => 22
    t.string   "updated_by",                   :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_ldap_syn_people", :force => true do |t|
    t.string "ldap_name",                    :limit => 100
    t.string "ldap_dn",                      :limit => 150
    t.string "auth_source_id",               :limit => 22
    t.string "filter",                       :limit => 200
    t.string "description",                  :limit => 155
    t.string "opu_id",                       :limit => 22
    t.string "organization_id",              :limit => 22
    t.string "department_id",                :limit => 22
    t.string "vip_flag",                     :limit => 1,   :default => "N"
    t.string "unrestricted_access_flag",     :limit => 30
    t.string "assignment_availability_flag", :limit => 1,   :default => "N"
    t.string "region_code",                  :limit => 30
    t.string "site_group_code",              :limit => 30
    t.string "site_code",                    :limit => 30
    t.string "function_group_code",          :limit => 30
    t.string "notification_lang",            :limit => 30
    t.string "notification_flag",            :limit => 30
    t.string "role_id",                      :limit => 22
    t.string "created_by",                   :limit => 22
    t.string "updated_by",                   :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  create_table "irm_license_functions", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "license_id",  :limit => 22,                        :null => false
    t.string   "function_id", :limit => 22,                        :null => false
    t.string   "opu_id",      :limit => 22
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_license_functions", ["license_id", "function_id"], :name => "IRM_LICENSE_FUNCTIONS_U1", :unique => true

  create_table "irm_licenses", :force => true do |t|
    t.string   "code",        :limit => 30
    t.string   "opu_id",      :limit => 22
    t.string   "status_code", :limit => 30, :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_licenses_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "license_id",  :limit => 22,                         :null => false
    t.string   "name",        :limit => 30,                         :null => false
    t.string   "description", :limit => 150
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "opu_id",      :limit => 22
    t.string   "status_code", :limit => 30,  :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_licenses_tl", ["license_id", "language"], :name => "IRM_LICENSES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_licenses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_licenses t,irm_licenses_tl tl
                                                 WHERE t.id = tl.license_id')

  create_table "irm_list_of_values", :force => true do |t|
    t.string   "opu_id",                :limit => 22,                         :null => false
    t.string   "lov_code",              :limit => 30,                         :null => false
    t.string   "bo_code",               :limit => 30,                         :null => false
    t.text     "where_clause"
    t.text     "query_clause"
    t.text     "addition_clause"
    t.string   "id_column",             :limit => 30,                         :null => false
    t.string   "value_column",          :limit => 30,                         :null => false
    t.string   "value_column_width",    :limit => 30
    t.string   "desc_column",           :limit => 30
    t.string   "desc_column_width",     :limit => 30
    t.string   "addition_column",       :limit => 150
    t.string   "addition_column_width", :limit => 150
    t.string   "listable_flag",         :limit => 1,   :default => "Y",       :null => false
    t.string   "status_code",           :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",            :limit => 22
    t.string   "updated_by",            :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_list_of_values", ["lov_code"], :name => "IRM_LIST_OF_VALUES_N1"

  create_table "irm_list_of_values_tl", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                         :null => false
    t.string   "list_of_value_id", :limit => 22,                         :null => false
    t.string   "name",             :limit => 60,                         :null => false
    t.string   "description",      :limit => 150
    t.string   "value_title",      :limit => 60
    t.string   "desc_title",       :limit => 60
    t.string   "addition_title",   :limit => 150
    t.string   "status_code",      :limit => 30,  :default => "ENABLED", :null => false
    t.string   "language",         :limit => 30
    t.string   "source_lang",      :limit => 30
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_list_of_values_tl", ["list_of_value_id", "language"], :name => "IRM_LIST_OF_VALUES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_list_of_values_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.value_title,tl.desc_title,tl.addition_title,tl.language,tl.source_lang
                                           FROM irm_list_of_values  t,irm_list_of_values_tl tl
                                           WHERE t.id = tl.list_of_value_id')


  create_table "irm_locations", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "organization_id", :limit => 22
    t.string   "department_id",   :limit => 22
    t.string   "site_group_code", :limit => 30
    t.string   "site_code",       :limit => 30,                        :null => false
    t.string   "status_code",     :limit => 30, :default => "ENABLED"
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_locations", ["opu_id", "site_code"], :name => "IRM_LOCATIONS_U1", :unique => true

  create_table "irm_login_records", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "identity_id",    :limit => 22,   :null => false
    t.string   "session_id",     :limit => 22,   :null => false
    t.string   "user_ip",        :limit => 60
    t.string   "user_agent",     :limit => 1000
    t.string   "browser",        :limit => 30
    t.string   "operate_system", :limit => 30
    t.datetime "login_at"
    t.datetime "logout_at"
    t.string   "status_code",    :limit => 30,   :null => false
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_lookup_types", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string "product_id",   :limit => 22
    t.string "lookup_level", :limit => 30, :null => false
    t.string "lookup_type",  :limit => 30, :null => false
    t.string "status_code",  :limit => 30, :null => false
    t.string "created_by",   :limit => 22
    t.string "updated_by",   :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "irm_lookup_types", ["lookup_type"], :name => "IRM_LOOKUP_TYPES_N1"

  create_table "irm_lookup_types_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string "product_id",     :limit => 22
    t.string "lookup_type_id", :limit => 22
    t.string "meaning",        :limit => 60,  :null => false
    t.string "description",    :limit => 150, :null => false
    t.string "language",       :limit => 30,  :null => false
    t.string "source_lang",    :limit => 30,  :null => false
    t.string "status_code",    :limit => 30,  :null => false
    t.string "created_by",     :limit => 22
    t.string "updated_by",     :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "irm_lookup_types_tl", ["lookup_type_id", "language"], :name => "IRM_LOOKUP_TYPES_TL_N1"

  execute('CREATE OR REPLACE VIEW irm_lookup_types_vl AS SELECT t.*,tl.id lang_id,tl.meaning,tl.description,tl.language,tl.source_lang
                                             FROM irm_lookup_types t,irm_lookup_types_tl tl
                                             WHERE t.id = tl.lookup_type_id')

  create_table "irm_lookup_values", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string "lookup_type",       :limit => 30, :null => false
    t.string "lookup_code",       :limit => 30, :null => false
    t.date   "start_date_active"
    t.date   "end_date_active"
    t.string "status_code",       :limit => 30, :null => false
    t.string "created_by",        :limit => 22
    t.string "updated_by",        :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "irm_lookup_values", ["lookup_type", "lookup_code"], :name => "IRM_LOOKUP_VALUES_N1"

  create_table "irm_lookup_values_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string "lookup_value_id", :limit => 22,  :null => false
    t.string "language",        :limit => 30,  :null => false
    t.string "source_lang",     :limit => 30,  :null => false
    t.string "meaning",         :limit => 60,  :null => false
    t.string "description",     :limit => 150, :null => false
    t.string "status_code",     :limit => 30,  :null => false
    t.string "created_by",      :limit => 22
    t.string "updated_by",      :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "irm_lookup_values_tl", ["lookup_value_id", "language"], :name => "IRM_LOOKUP_VALUES_TL_N1"

  execute('CREATE OR REPLACE VIEW irm_lookup_values_vl AS SELECT t.*,tl.id lang_id,tl.meaning,tl.description,tl.language,tl.source_lang
                                           FROM irm_lookup_values t,irm_lookup_values_tl tl
                                           WHERE t.id = tl.lookup_value_id')


  create_table "irm_machine_codes", :force => true do |t|
    t.string   "opu_id",       :limit => 22, :null => false
    t.string   "machine_addr", :limit => 17, :null => false
    t.string   "machine_code", :limit => 4
    t.string   "created_by",   :limit => 22, :null => false
    t.string   "updated_by",   :limit => 22, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_machine_codes", ["machine_addr"], :name => "IRM_MACHINE_CODES_U1", :unique => true
  add_index "irm_machine_codes", ["machine_code"], :name => "IRM_MACHINE_CODES_U2", :unique => true

  create_table "irm_mail_templates", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "template_code", :limit => 30, :null => false
    t.string   "template_type", :limit => 30
    t.string   "status_code",   :limit => 30, :null => false
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_mail_templates", ["template_code"], :name => "IRM_MAIL_TEMPLATES_N1"

  create_table "irm_mail_templates_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "template_id",     :limit => 22
    t.string   "language",        :limit => 30,  :null => false
    t.string   "name",            :limit => 150, :null => false
    t.string   "description",     :limit => 240
    t.string   "subject",         :limit => 150, :null => false
    t.text     "mail_body",                      :null => false
    t.text     "parsed_template"
    t.string   "source_lang",     :limit => 30,  :null => false
    t.string   "status_code",     :limit => 30,  :null => false
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_mail_templates_tl", ["template_id", "language"], :name => "IRM_MAIL_TEMPLATES_TL_N1"

  execute('CREATE OR REPLACE VIEW irm_mail_templates_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.subject,tl.mail_body,tl.parsed_template,tl.description,tl.language,tl.source_lang
                                             FROM irm_mail_templates  t,irm_mail_templates_tl tl
                                             WHERE t.id = tl.template_id')

  create_table "irm_menu_entries", :force => true do |t|
    t.string   "opu_id",                :limit => 22,                        :null => false
    t.string   "menu_id",               :limit => 22,                        :null => false
    t.string   "sub_menu_id",           :limit => 22
    t.string   "sub_function_group_id", :limit => 22
    t.integer  "display_sequence"
    t.string   "status_code",           :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",            :limit => 22,                        :null => false
    t.string   "updated_by",            :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_menu_entries", ["menu_id"], :name => "IRM_MENU_ENTRIES_N1"

  create_table "irm_menu_entries_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "menu_entry_id", :limit => 22,                         :null => false
    t.string   "language",      :limit => 30,                         :null => false
    t.string   "name",          :limit => 150,                        :null => false
    t.string   "description",   :limit => 240
    t.string   "source_lang",   :limit => 30,                         :null => false
    t.string   "status_code",   :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",    :limit => 22,                         :null => false
    t.string   "updated_by",    :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_menu_entries_tl", ["menu_entry_id", "language"], :name => "IRM_MENU_ENTRIES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_menu_entries_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_menu_entries  t,irm_menu_entries_tl tl
                                             WHERE t.id = tl.menu_entry_id')

  create_table "irm_menus", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "code",        :limit => 30,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_menus", ["code"], :name => "IRM_MENUS_U1", :unique => true

  create_table "irm_menus_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "menu_id",     :limit => 22,                         :null => false
    t.string   "language",    :limit => 30,                         :null => false
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,                         :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                         :null => false
    t.string   "updated_by",  :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_menus_tl", ["menu_id", "language"], :name => "IRM_MENUS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_menus_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_menus  t,irm_menus_tl tl
                                           WHERE t.id = tl.menu_id')


  create_table "irm_object_attributes", :force => true do |t|
    t.string   "opu_id",                    :limit => 22,                               :null => false
    t.string   "business_object_code",      :limit => 30,                               :null => false
    t.string   "approval_page_field_flag",  :limit => 1,  :default => "Y",              :null => false
    t.string   "filter_flag",               :limit => 1,  :default => "N"
    t.string   "person_flag",               :limit => 1,  :default => "N"
    t.string   "update_flag",               :limit => 1,  :default => "N"
    t.string   "attribute_name",            :limit => 30,                               :null => false
    t.string   "attribute_type",            :limit => 30, :default => "TABLE_COLUMN",   :null => false
    t.string   "field_type",                :limit => 30, :default => "CUSTOMED_FIELD"
    t.string   "exists_relation_flag",      :limit => 1,  :default => "N"
    t.string   "relation_bo_code",          :limit => 30
    t.string   "relation_table_alias_name", :limit => 30
    t.string   "relation_column",           :limit => 30
    t.string   "relation_type",             :limit => 30
    t.text     "where_clause"
    t.string   "lov_code",                  :limit => 30
    t.string   "data_type",                 :limit => 30
    t.string   "data_length",               :limit => 30
    t.string   "nullable_flag",             :limit => 30
    t.string   "key_type",                  :limit => 30
    t.string   "default_value",             :limit => 30
    t.string   "extra_info",                :limit => 30
    t.string   "status_code",               :limit => 30, :default => "ENABLED",        :null => false
    t.string   "created_by",                :limit => 22
    t.string   "updated_by",                :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_object_attributes", ["business_object_code"], :name => "IRM_OBJECT_ATTRIBUTES_N1"

  create_table "irm_object_attributes_tl", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                         :null => false
    t.string   "object_attribute_id", :limit => 22,                         :null => false
    t.string   "name",                :limit => 60,                         :null => false
    t.string   "description",         :limit => 150
    t.string   "status_code",         :limit => 30,  :default => "ENABLED", :null => false
    t.string   "language",            :limit => 30
    t.string   "source_lang",         :limit => 30
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_object_attributes_tl", ["object_attribute_id", "language"], :name => "IRM_OBJECT_ATTRIBUTES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                             WHERE t.id = tl.object_attribute_id')

  create_table "irm_object_codes", :force => true do |t|
    t.string   "opu_id",            :limit => 22, :null => false
    t.string   "object_table_name",               :null => false
    t.string   "object_code",       :limit => 4
    t.string   "created_by",        :limit => 22, :null => false
    t.string   "updated_by",        :limit => 22, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_object_codes", ["object_code"], :name => "IRM_OBJECT_CODES_U2", :unique => true
  add_index "irm_object_codes", ["object_table_name"], :name => "IRM_OBJECT_CODES_U1", :unique => true

  create_table "irm_operation_units", :force => true do |t|
    t.string   "short_name",             :limit => 30
    t.string   "primary_person_id",      :limit => 22
    t.string   "license_id",             :limit => 22
    t.string   "default_language_code",  :limit => 22
    t.string   "default_time_zone_code", :limit => 30
    t.string   "opu_id",                 :limit => 22
    t.string   "status_code",            :limit => 30, :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_operation_units_tl", :force => true do |t|
    t.string   "operation_unit_id", :limit => 22,                         :null => false
    t.string   "name",              :limit => 30,                         :null => false
    t.string   "description",       :limit => 150
    t.string   "language",          :limit => 30
    t.string   "source_lang",       :limit => 30
    t.string   "opu_id",            :limit => 22
    t.string   "status_code",       :limit => 30,  :default => "ENABLED"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_operation_units_tl", ["operation_unit_id", "language"], :name => "IRM_OPERATION_UNIT_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_operation_units_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                               FROM irm_operation_units t,irm_operation_units_tl tl
                                               WHERE t.id = tl.operation_unit_id')

  create_table "irm_organization_explosions", :force => true do |t|
    t.string   "parent_org_id",        :limit => 22,                        :null => false
    t.string   "direct_parent_org_id", :limit => 22,                        :null => false
    t.string   "organization_id",      :limit => 22,                        :null => false
    t.string   "opu_id",               :limit => 22,                        :null => false
    t.string   "status_code",          :limit => 30, :default => "ENABLED"
    t.string   "created_by",           :limit => 22,                        :null => false
    t.string   "updated_by",           :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_organization_explosions", ["parent_org_id", "direct_parent_org_id", "organization_id"], :name => "IRM_ORGANIZATION_EXPLOSIONS_U1", :unique => true

  create_table "irm_organizations", :force => true do |t|
    t.string   "opu_id",        :limit => 22
    t.string   "parent_org_id", :limit => 22
    t.string   "short_name",    :limit => 30,  :null => false
    t.string   "status_code",   :limit => 30,  :null => false
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ldap_dn",       :limit => 200
  end

  add_index "irm_organizations", ["opu_id", "short_name"], :name => "IRM_ORGANIZATIONS_U1"

  create_table "irm_organizations_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "organization_id", :limit => 22
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

  add_index "irm_organizations_tl", ["organization_id", "language"], :name => "IRM_ORGANIZATIONS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_organizations_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_organizations t,irm_organizations_tl tl
                                                 WHERE t.id = tl.organization_id')

  create_table "irm_password_policies", :force => true do |t|
    t.string   "opu_id",                 :limit => 22,                        :null => false
    t.string   "expire_in",              :limit => 30
    t.string   "enforce_history",        :limit => 30
    t.string   "minimum_length",         :limit => 30
    t.string   "complexity_requirement", :limit => 30
    t.string   "question_requirement",   :limit => 30
    t.string   "maximum_attempts",       :limit => 30
    t.string   "lockout_period",         :limit => 30
    t.string   "status_code",            :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",             :limit => 22,                        :null => false
    t.string   "updated_by",             :limit => 22,                        :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  create_table "irm_people", :force => true do |t|
    t.string   "opu_id",                       :limit => 22,                         :null => false
    t.string   "organization_id",              :limit => 22
    t.string   "department_id",                :limit => 22
    t.string   "role_id",                      :limit => 22
    t.string   "profile_id",                   :limit => 22
    t.string   "title",                        :limit => 30
    t.string   "first_name",                   :limit => 30,                         :null => false
    t.string   "last_name",                    :limit => 30
    t.string   "full_name_pinyin",             :limit => 60
    t.string   "full_name",                    :limit => 60
    t.string   "job_title",                    :limit => 30
    t.string   "vip_flag",                     :limit => 1,   :default => "N"
    t.string   "support_staff_flag",           :limit => 1,   :default => "N"
    t.string   "assignment_availability_flag", :limit => 1,   :default => "N"
    t.string   "email_address",                :limit => 150
    t.string   "home_phone",                   :limit => 30
    t.string   "home_address",                 :limit => 30
    t.string   "mobile_phone",                 :limit => 30
    t.string   "fax_number",                   :limit => 30
    t.string   "bussiness_phone",              :limit => 30
    t.string   "region_code",                  :limit => 30
    t.string   "site_group_code",              :limit => 30
    t.string   "site_code",                    :limit => 30
    t.string   "function_group_code",          :limit => 30
    t.string   "avatar_path",                  :limit => 150
    t.string   "avatar_file_name",             :limit => 30
    t.string   "avatar_content_type",          :limit => 30
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "identity_id",                  :limit => 22
    t.string   "approve_request_mail",         :limit => 30
    t.string   "manager",                      :limit => 30
    t.string   "delegate_approver",            :limit => 30
    t.string   "last_login_at",                :limit => 30
    t.string   "type",                         :limit => 30
    t.string   "language_code",                :limit => 30
    t.string   "auth_source_id",               :limit => 22
    t.string   "hashed_password",              :limit => 60
    t.string   "login_name",                   :limit => 30
    t.string   "unrestricted_access_flag",     :limit => 30
    t.string   "notification_lang",            :limit => 30
    t.string   "notification_flag",            :limit => 30
    t.string   "capacity_rating",              :limit => 30
    t.integer  "open_tickets"
    t.string   "task_capacity_rating",         :limit => 30
    t.integer  "open_tasks"
    t.datetime "last_assigned_date"
    t.datetime "locked_until_at"
    t.integer  "locked_time",                                 :default => 0
    t.datetime "password_updated_at"
    t.string   "status_code",                  :limit => 30,  :default => "ENABLED"
    t.string   "created_by",                   :limit => 22
    t.string   "updated_by",                   :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ldap_dn",                      :limit => 200
  end

  add_index "irm_people", ["identity_id"], :name => "IRM_PEOPLE_N1"
  add_index "irm_people", ["opu_id"], :name => "IRM_PEOPLE_N2"

  create_table "irm_permissions", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "function_id",     :limit => 22,                        :null => false
    t.string   "product_id",      :limit => 22,                        :null => false
    t.string   "code",            :limit => 120,                        :null => false
    t.string   "controller",      :limit => 60,                        :null => false
    t.string   "action",          :limit => 60,                        :null => false
    t.integer  "params_count",                  :default => 0,         :null => false
    t.string   "direct_get_flag", :limit => 1,  :default => "Y",       :null => false
    t.string   "status_code",     :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",      :limit => 22,                        :null => false
    t.string   "updated_by",      :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_permissions", ["function_id", "controller", "action"], :name => "IRM_PERMISSIONS_U1", :unique => true
  add_index "irm_permissions", ["function_id"], :name => "IRM_PERMISSIONS_N1"

  create_table "irm_product_modules", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "product_short_name", :limit => 30, :null => false
    t.string   "installed_flag",     :limit => 1
    t.string   "status_code",        :limit => 30, :null => false
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_product_modules_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "product_id",  :limit => 22,  :null => false
    t.string   "language",    :limit => 30,  :null => false
    t.string   "name",        :limit => 150, :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,  :null => false
    t.string   "status_code", :limit => 30,  :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  execute('CREATE OR REPLACE VIEW irm_product_modules_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_product_modules  t,irm_product_modules_tl tl
                                           WHERE t.id = tl.product_id')


  create_table "irm_profile_applications", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "profile_id",     :limit => 22,                        :null => false
    t.string   "application_id", :limit => 22,                        :null => false
    t.string   "default_flag",   :limit => 1,  :default => "N",       :null => false
    t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",     :limit => 22,                        :null => false
    t.string   "updated_by",     :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_profile_applications", ["profile_id", "application_id"], :name => "IRM_PROFILE_APPLICATIONS_U1", :unique => true

  create_table "irm_profile_functions", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "profile_id",  :limit => 22,                        :null => false
    t.string   "function_id", :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_profile_functions", ["profile_id", "function_id"], :name => "IRM_PROFILE_FUNCTIONS_U1", :unique => true

  create_table "irm_profile_kanbans", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "profile_id",  :limit => 22,                        :null => false
    t.string   "kanban_id",   :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_profiles", :force => true do |t|
    t.string   "opu_id",       :limit => 22,                        :null => false
    t.string   "user_license", :limit => 30,                        :null => false
    t.string   "code",         :limit => 30,                        :null => false
    t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",   :limit => 22,                        :null => false
    t.string   "updated_by",   :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kanban_id",    :limit => 22
  end

  add_index "irm_profiles", ["code","opu_id"], :name => "IRM_PROFILES_U1", :unique => true

  create_table "irm_profiles_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "profile_id",  :limit => 22,                         :null => false
    t.string   "language",    :limit => 30,                         :null => false
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,                         :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                         :null => false
    t.string   "updated_by",  :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_profiles_tl", ["profile_id", "language"], :name => "IRM_PROFILES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_profiles_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_profiles t,irm_profiles_tl tl
                                           WHERE t.id = tl.profile_id')

  create_table "irm_recently_objects", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "source_type", :limit => 30
    t.string   "source_id",   :limit => 22
    t.string   "status_code", :limit => 30, :default => "ENABLED"
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_regions", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "region_code", :limit => 30, :null => false
    t.string   "status_code", :limit => 30, :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_regions", ["region_code"], :name => "IRM_REGIONS_U1"

  create_table "irm_regions_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "region_id",   :limit => 22
    t.string   "language",    :limit => 30,  :null => false
    t.string   "name",        :limit => 150, :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,  :null => false
    t.string   "status_code", :limit => 30,  :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_regions_tl", ["region_id", "language"], :name => "IRM_REGIONS_TL_U1"

  execute('CREATE OR REPLACE VIEW irm_regions_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_regions t,irm_regions_tl tl
                                           WHERE t.id = tl.region_id')

  create_table "irm_report_columns", :force => true do |t|
    t.string   "opu_id",       :limit => 22, :null => false
    t.string   "report_id",    :limit => 22, :null => false
    t.string   "field_id",     :limit => 22, :null => false
    t.integer  "seq_num",                    :null => false
    t.string   "summary_type", :limit => 30
    t.string   "status_code",  :limit => 30, :null => false
    t.string   "created_by",   :limit => 22
    t.string   "updated_by",   :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_columns", ["field_id"], :name => "IRM_REPORT_COLUMNS_N2"
  add_index "irm_report_columns", ["report_id"], :name => "IRM_REPORT_COLUMNS_N1"

  create_table "irm_report_criterions", :force => true do |t|
    t.string   "opu_id",        :limit => 22,  :null => false
    t.string   "report_id",     :limit => 22,  :null => false
    t.string   "field_id",      :limit => 22,  :null => false
    t.integer  "seq_num",                      :null => false
    t.string   "operator_code", :limit => 30
    t.string   "filter_value",  :limit => 150
    t.string   "status_code",   :limit => 30,  :null => false
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_criterions", ["field_id"], :name => "IRM_REPORT_CRITERIONS_N2"
  add_index "irm_report_criterions", ["report_id"], :name => "IRM_REPORT_CRITERIONS_N1"

  create_table "irm_report_folder_members", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                        :null => false
    t.string   "report_folder_id", :limit => 22,                        :null => false
    t.string   "member_type",      :limit => 30,                        :null => false
    t.string   "member_id",        :limit => 22,                        :null => false
    t.string   "status_code",      :limit => 30, :default => "ENABLED"
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_report_folders", :force => true do |t|
    t.string   "opu_id",      :limit => 22, :null => false
    t.string   "code",        :limit => 30, :null => false
    t.string   "access_type", :limit => 22, :null => false
    t.string   "member_type", :limit => 30, :null => false
    t.string   "status_code", :limit => 30, :null => false
    t.string   "created_by",  :limit => 22, :null => false
    t.string   "updated_by",  :limit => 22, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_folders", ["code","opu_id"], :name => "IRM_REPORT_FOLDERS_U1", :unique => true

  create_table "irm_report_folders_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "report_folder_id", :limit => 22,  :null => false
    t.string   "language",         :limit => 30,  :null => false
    t.string   "name",             :limit => 150, :null => false
    t.string   "description",      :limit => 240
    t.string   "source_lang",      :limit => 30,  :null => false
    t.string   "status_code",      :limit => 30,  :null => false
    t.string   "created_by",       :limit => 22,  :null => false
    t.string   "updated_by",       :limit => 22,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_folders_tl", ["report_folder_id", "language"], :name => "IRM_REPORT_FOLDERS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_report_folders_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                         FROM irm_report_folders  t,irm_report_folders_tl tl
                                         WHERE t.id = tl.report_folder_id')


  create_table "irm_report_receivers", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                        :null => false
    t.string   "report_trigger_id", :limit => 22,                        :null => false
    t.string   "receiver_type",     :limit => 30,                        :null => false
    t.string   "receiver_id",       :limit => 22,                        :null => false
    t.string   "status_code",       :limit => 30, :default => "ENABLED"
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_report_schedules", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                        :null => false
    t.string   "report_trigger_id", :limit => 22,                        :null => false
    t.datetime "run_at",                                                 :null => false
    t.string   "run_at_str",        :limit => 30
    t.string   "run_status",        :limit => 30, :default => "PENDING"
    t.string   "status_code",       :limit => 30, :default => "ENABLED"
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "irm_report_triggers", :force => true do |t|
    t.string   "opu_id",        :limit => 22,                        :null => false
    t.string   "report_id",     :limit => 22,                        :null => false
    t.string   "person_id",     :limit => 22,                        :null => false
    t.string   "receiver_type", :limit => 22,                        :null => false
    t.text     "time_mode",                                          :null => false
    t.date     "start_at",                                           :null => false
    t.date     "end_at",                                             :null => false
    t.datetime "start_time"
    t.string   "status_code",   :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",    :limit => 22,                        :null => false
    t.string   "updated_by",    :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_triggers", ["report_id"], :name => "IRM_REPORT_TRIGGERS_N1"

  create_table "irm_report_type_categories", :force => true do |t|
    t.string   "opu_id",     :limit => 22, :null => false
    t.string   "code",       :limit => 30, :null => false
    t.string   "created_by", :limit => 22, :null => false
    t.string   "updated_by", :limit => 22, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_type_categories", ["code","opu_id"], :name => "IRM_REPORT_TYPE_CATEGORIES_U1", :unique => true

  create_table "irm_report_type_categories_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "report_type_category_id", :limit => 22,  :null => false
    t.string   "language",                :limit => 30,  :null => false
    t.string   "name",                    :limit => 150, :null => false
    t.string   "description",             :limit => 240
    t.string   "source_lang",             :limit => 30,  :null => false
    t.string   "status_code",             :limit => 30,  :null => false
    t.string   "created_by",              :limit => 22,  :null => false
    t.string   "updated_by",              :limit => 22,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_type_categories_tl", ["report_type_category_id", "language"], :name => "IRM_REPORT_TYPE_CATEGORIES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_report_type_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                         FROM irm_report_type_categories  t,irm_report_type_categories_tl tl
                                         WHERE t.id = tl.report_type_category_id')


  create_table "irm_report_type_fields", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "section_id",             :limit => 22,                  :null => false
    t.string   "object_attribute_id",    :limit => 22,                  :null => false
    t.string   "default_selection_flag", :limit => 1,  :default => "N", :null => false
    t.string   "status_code",            :limit => 30,                  :null => false
    t.string   "created_by",             :limit => 22,                  :null => false
    t.string   "updated_by",             :limit => 22,                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_type_fields", ["section_id"], :name => "IRM_REPORT_TYPE_FIELDS_N1"

  create_table "irm_report_type_objects", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "report_type_id",     :limit => 22, :null => false
    t.string   "business_object_id", :limit => 22, :null => false
    t.string   "object_sequence",    :limit => 1,  :null => false
    t.string   "relationship_type",  :limit => 30, :null => false
    t.string   "status_code",        :limit => 30, :null => false
    t.string   "created_by",         :limit => 22, :null => false
    t.string   "updated_by",         :limit => 22, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_type_objects", ["report_type_id", "business_object_id"], :name => "IRM_REPORT_TYPE_OBJECTS_U1", :unique => true
  add_index "irm_report_type_objects", ["report_type_id"], :name => "IRM_REPORT_TYPE_OBJECTS_N1"

  create_table "irm_report_type_sections", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "report_type_id",   :limit => 22,  :null => false
    t.string   "name",             :limit => 150, :null => false
    t.integer  "section_sequence",                :null => false
    t.string   "status_code",      :limit => 30,  :null => false
    t.string   "created_by",       :limit => 22,  :null => false
    t.string   "updated_by",       :limit => 22,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_type_sections", ["report_type_id"], :name => "IRM_REPORT_TYPE_SECTIONS_N1"

  create_table "irm_report_types", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "category_id",        :limit => 22, :null => false
    t.string   "business_object_id", :limit => 22, :null => false
    t.string   "code",               :limit => 30, :null => false
    t.string   "status_code",        :limit => 30, :null => false
    t.string   "created_by",         :limit => 22, :null => false
    t.string   "updated_by",         :limit => 22, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_types", ["code","opu_id"], :name => "IRM_REPORT_TYPE_U1", :unique => true

  create_table "irm_report_types_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "report_type_id", :limit => 22,  :null => false
    t.string   "language",       :limit => 30,  :null => false
    t.string   "name",           :limit => 150, :null => false
    t.string   "description",    :limit => 240
    t.string   "source_lang",    :limit => 30,  :null => false
    t.string   "status_code",    :limit => 30,  :null => false
    t.string   "created_by",     :limit => 22,  :null => false
    t.string   "updated_by",     :limit => 22,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_types_tl", ["report_type_id", "language"], :name => "IRM_REPORT_TYPES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_report_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_report_types  t,irm_report_types_tl tl
                                           WHERE t.id = tl.report_type_id')

  create_table "irm_reports", :force => true do |t|
    t.string   "opu_id",                 :limit => 22,                   :null => false
    t.string   "report_type_id",         :limit => 22,                   :null => false
    t.string   "report_folder_id",       :limit => 22
    t.string   "code",                   :limit => 30,                   :null => false
    t.string   "detail_display_flag",    :limit => 1,   :default => "Y", :null => false
    t.string   "group_field_id",         :limit => 22
    t.string   "filter_company_id",      :limit => 22,                   :null => false
    t.string   "filter_date_field_id",   :limit => 22
    t.string   "filter_date_range_type", :limit => 30
    t.datetime "filter_date_from"
    t.datetime "filter_date_to"
    t.string   "limit_field_id",         :limit => 22
    t.string   "limit_field_order",      :limit => 22
    t.integer  "limit_record_count"
    t.string   "raw_condition_clause",   :limit => 240
    t.string   "condition_clause",       :limit => 240
    t.text     "query_str_cache"
    t.string   "status_code",            :limit => 30,                   :null => false
    t.string   "created_by",             :limit => 22,                   :null => false
    t.string   "updated_by",             :limit => 22,                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_reports", ["code","opu_id"], :name => "IRM_REPORTS_U1", :unique => true

  create_table "irm_report_group_columns", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                   :null => false
    t.string   "report_id",       :limit => 22,                   :null => false
    t.string   "field_id",        :limit => 22,                   :null => false
    t.integer  "seq_num",                                         :null => false
    t.string   "group_flag",      :limit => 1,   :default => "N"
    t.string   "sort_type",       :limit => 30
    t.string   "group_date_type", :limit => 150
    t.string   "status_code",     :limit => 30,                   :null => false
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_report_group_columns", ["field_id"], :name => "IRM_REPORT_GROUP_COLUMNS_N2"
  add_index "irm_report_group_columns", ["report_id"], :name => "IRM_REPORT_GROUP_COLUMNS_N1"

  create_table "irm_reports_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "report_id",   :limit => 22,  :null => false
    t.string   "language",    :limit => 30,  :null => false
    t.string   "name",        :limit => 150, :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,  :null => false
    t.string   "status_code", :limit => 30,  :null => false
    t.string   "created_by",  :limit => 22,  :null => false
    t.string   "updated_by",  :limit => 22,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_reports_tl", ["report_id", "language"], :name => "IRM_REPORTS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_reports t,irm_reports_tl tl
                                             WHERE t.id = tl.report_id')

  create_table "irm_role_explosions", :force => true do |t|
    t.string   "parent_role_id",        :limit => 22,                        :null => false
    t.string   "direct_parent_role_id", :limit => 22,                        :null => false
    t.string   "role_id",               :limit => 22,                        :null => false
    t.string   "opu_id",                :limit => 22,                        :null => false
    t.string   "status_code",           :limit => 30, :default => "ENABLED"
    t.string   "created_by",            :limit => 22,                        :null => false
    t.string   "updated_by",            :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_role_explosions", ["parent_role_id", "direct_parent_role_id", "role_id"], :name => "IRM_ROLE_EXPLOSIONS_U1", :unique => true

  create_table "irm_roles", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                        :null => false
    t.string   "code",              :limit => 30,                        :null => false
    t.string   "report_to_role_id", :limit => 22
    t.string   "status_code",       :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_roles", ["code"], :name => "IRM_ROLES_N1"

  create_table "irm_roles_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                         :null => false
    t.string   "role_id",     :limit => 22,                         :null => false
    t.string   "name",        :limit => 60,                         :null => false
    t.string   "description", :limit => 150,                        :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_roles_tl", ["role_id", "language"], :name => "IRM_ROLES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_roles_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_roles  t,irm_roles_tl tl
                                             WHERE t.id = tl.role_id')

  create_table "irm_rule_filter_criterions", :force => true do |t|
    t.string   "opu_id",         :limit => 22,  :null => false
    t.string   "rule_filter_id", :limit => 22,  :null => false
    t.string   "attribute_name", :limit => 60
    t.integer  "seq_num",                       :null => false
    t.string   "operator_code",  :limit => 30
    t.string   "filter_value",   :limit => 150
    t.string   "status_code",    :limit => 30,  :null => false
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_rule_filter_criterions", ["rule_filter_id"], :name => "IRM_RULE_FILTER_CRITERIONS_N1"

  create_table "irm_rule_filters", :force => true do |t|
    t.string   "opu_id",               :limit => 22,                    :null => false
    t.string   "bo_code",              :limit => 30,                    :null => false
    t.string   "filter_type",          :limit => 30,                    :null => false
    t.string   "filter_name",          :limit => 150
    t.string   "filter_code",          :limit => 30
    t.string   "source_id",            :limit => 22
    t.string   "source_type",          :limit => 60
    t.string   "source_code",          :limit => 30
    t.string   "own_id",               :limit => 22
    t.string   "default_flag",         :limit => 1,    :default => "N"
    t.string   "restrict_visibility",  :limit => 1,    :default => "N"
    t.string   "raw_condition_clause", :limit => 150
    t.string   "condition_clause",     :limit => 1000
    t.string   "status_code",          :limit => 30,                    :null => false
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_rule_filters", ["filter_code", "source_code"], :name => "IRM_RULE_FILTERS_N1"
  add_index "irm_rule_filters", ["source_id", "source_type"], :name => "IRM_RULE_FILTERS_N2"


  create_table "irm_site_groups", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "region_code", :limit => 30,                        :null => false
    t.string   "group_code",  :limit => 30,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED"
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_site_groups", ["region_code", "group_code","opu_id"], :name => "IRM_SITE_GROUPS_U1", :unique => true

  create_table "irm_site_groups_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "site_group_id", :limit => 22,                         :null => false
    t.string   "name",          :limit => 30,                         :null => false
    t.string   "description",   :limit => 150
    t.string   "language",      :limit => 30
    t.string   "source_lang",   :limit => 30
    t.string   "status_code",   :limit => 30,  :default => "ENABLED"
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_site_groups_tl", ["site_group_id", "language"], :name => "IRM_SITE_GROUPS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_site_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_site_groups t,irm_site_groups_tl tl
                                           WHERE t.id = tl.site_group_id')

  create_table "irm_sites", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "site_group_code", :limit => 30,                         :null => false
    t.string   "site_code",       :limit => 30,                         :null => false
    t.string   "address_line",    :limit => 150
    t.string   "country",         :limit => 30
    t.string   "state_code",      :limit => 30
    t.string   "city",            :limit => 30
    t.string   "postal_code",     :limit => 30
    t.string   "timezone_code",   :limit => 30
    t.string   "status_code",     :limit => 30,  :default => "ENABLED"
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_sites", ["site_group_code", "site_code"], :name => "IRM_SITES_U1", :unique => true

  create_table "irm_sites_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "site_id",     :limit => 22,                         :null => false
    t.string   "name",        :limit => 30,                         :null => false
    t.string   "description", :limit => 150
    t.string   "language",    :limit => 30
    t.string   "source_lang", :limit => 30
    t.string   "status_code", :limit => 30,  :default => "ENABLED"
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_sites_tl", ["site_id", "language"], :name => "IRM_SITES_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_sites_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_sites t,irm_sites_tl tl
                                           WHERE t.id = tl.site_id')

  create_table "irm_system_parameters", :force => true do |t|
    t.string   "opu_id",             :limit => 22,                         :null => false
    t.string   "parameter_code",     :limit => 30
    t.string   "content_type",       :limit => 30,                         :null => false
    t.string   "data_type",          :limit => 30,                         :null => false
    t.string   "value",              :limit => 240
    t.text     "validation_format"
    t.text     "validation_content"
    t.string   "validation_type",    :limit => 30
    t.text     "position"
    t.datetime "img_updated_at"
    t.integer  "img_file_size"
    t.string   "img_content_type",   :limit => 60
    t.string   "img_file_name",      :limit => 60
    t.string   "status_code",        :limit => 30,  :default => "ENABLED"
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_system_parameters_tl", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                         :null => false
    t.string   "system_parameter_id", :limit => 22,                         :null => false
    t.string   "name",                :limit => 150
    t.string   "description",         :limit => 240
    t.string   "language",            :limit => 30
    t.string   "source_lang",         :limit => 30
    t.string   "status_code",         :limit => 30,  :default => "ENABLED"
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_system_parameters_tl", ["system_parameter_id", "language"], :name => "IRM_SYSTEM_PARAMETERS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_system_parameters_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_system_parameters  t,irm_system_parameters_tl tl
                                             WHERE t.id = tl.system_parameter_id')

  create_table "irm_tabs", :force => true do |t|
    t.string   "opu_id",             :limit => 22,                        :null => false
    t.string   "business_object_id", :limit => 22
    t.string   "code",               :limit => 30,                        :null => false
    t.string   "function_group_id",  :limit => 22,                        :null => false
    t.string   "style_color",        :limit => 30
    t.string   "style_image",        :limit => 30
    t.string   "status_code",        :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",         :limit => 22,                        :null => false
    t.string   "updated_by",         :limit => 22,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_tabs_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "tab_id",      :limit => 22,                         :null => false
    t.string   "language",    :limit => 30,                         :null => false
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "source_lang", :limit => 30,                         :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                         :null => false
    t.string   "updated_by",  :limit => 22,                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_tabs_tl", ["tab_id", "language"], :name => "IRM_TABS_TL_U1", :unique => true

  execute('CREATE OR REPLACE VIEW irm_tabs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_tabs t,irm_tabs_tl tl
                                           WHERE t.id = tl.tab_id')

  create_table "irm_todo_events", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "calendar_id",      :limit => 22
    t.string   "name",             :limit => 150,                         :null => false
    t.string   "description",      :limit => 3000
    t.string   "location",         :limit => 240
    t.string   "string",           :limit => 240
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "completed"
    t.integer  "percent_complete"
    t.string   "priority"
    t.text     "url"
    t.boolean  "all_day",                          :default => false
    t.string   "color",            :limit => 30
    t.string   "source_type",      :limit => 30
    t.string   "source_id",        :limit => 22
    t.text     "rrule"
    t.string   "parent_id",        :limit => 22
    t.string   "event_status",     :limit => 30
    t.string   "status_code",      :limit => 30,   :default => "ENABLED", :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_todo_tasks", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "calendar_id",      :limit => 22
    t.string   "name",             :limit => 150,                         :null => false
    t.string   "description",      :limit => 3000
    t.datetime "start_at"
    t.datetime "due_date"
    t.integer  "duration"
    t.datetime "completed"
    t.integer  "percent_complete"
    t.string   "priority"
    t.text     "url"
    t.string   "send_email_flag",  :limit => 1,    :default => "N",       :null => false
    t.integer  "sequence"
    t.boolean  "all_day",                          :default => false
    t.string   "color",            :limit => 30
    t.string   "source_type",      :limit => 30
    t.string   "source_id",        :limit => 22
    t.text     "rrule"
    t.string   "parent_id",        :limit => 22
    t.string   "task_status",      :limit => 30
    t.string   "status_code",      :limit => 30,   :default => "ENABLED", :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_watchers", :force => true do |t|
    t.string   "opu_id",         :limit => 22
    t.string   "watchable_id",   :limit => 22
    t.string   "watchable_type", :limit => 30
    t.string   "member_id",      :limit => 22
    t.string   "member_type",    :limit => 30
    t.string   "deletable_flag", :limit => 1,  :default => "Y"
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_watchers", ["opu_id", "member_id", "watchable_id", "member_type"], :name => "IRM_WATCHERS_N2"
  add_index "irm_watchers", ["opu_id", "watchable_id", "watchable_type"], :name => "IRM_WATCHERS_N1"

  create_table "irm_wf_approval_actions", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "process_id",  :limit => 22,                        :null => false
    t.string   "action_mode", :limit => 30,                        :null => false
    t.string   "step_id",     :limit => 22
    t.string   "action_type", :limit => 60,                        :null => false
    t.string   "action_id",   :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_approval_processes", :force => true do |t|
    t.string   "opu_id",                 :limit => 22,                         :null => false
    t.string   "bo_code",                :limit => 30,                         :null => false
    t.integer  "process_order"
    t.string   "name",                   :limit => 60,                         :null => false
    t.string   "process_code",           :limit => 30,                         :null => false
    t.string   "description",            :limit => 150
    t.string   "evaluate_entry_mode",    :limit => 30,                         :null => false
    t.string   "next_approver_mode",     :limit => 30
    t.string   "record_editability",     :limit => 30,                         :null => false
    t.string   "mail_template_id",       :limit => 22,                         :null => false
    t.string   "approve_fields"
    t.string   "display_history_flag",   :limit => 1,   :default => "Y",       :null => false
    t.string   "allow_submitter_recall", :limit => 1,   :default => "N",       :null => false
    t.string   "status_code",            :limit => 30,  :default => "OFFLINE", :null => false
    t.string   "created_by",             :limit => 22
    t.string   "updated_by",             :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_approval_step_approvers", :force => true do |t|
    t.string   "opu_id",        :limit => 22,                        :null => false
    t.string   "step_id",       :limit => 22,                        :null => false
    t.string   "approver_type", :limit => 30,                        :null => false
    t.string   "approver_id",   :limit => 22,                        :null => false
    t.string   "status_code",   :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_approval_steps", :force => true do |t|
    t.string   "opu_id",                   :limit => 22,                         :null => false
    t.string   "process_id",               :limit => 22,                         :null => false
    t.integer  "step_number",                                                    :null => false
    t.string   "name",                     :limit => 60,                         :null => false
    t.string   "step_code",                :limit => 30,                         :null => false
    t.string   "description",              :limit => 150
    t.string   "evaluate_mode",            :limit => 30
    t.string   "evaluate_result",          :limit => 30
    t.string   "approver_mode",            :limit => 30,                         :null => false
    t.string   "multiple_approver_mode",   :limit => 30,                         :null => false
    t.string   "allow_delegation_approve", :limit => 1,   :default => "N",       :null => false
    t.string   "reject_behavior",          :limit => 30,                         :null => false
    t.string   "status_code",              :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",               :limit => 22
    t.string   "updated_by",               :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_approval_submitters", :force => true do |t|
    t.string   "opu_id",         :limit => 22,                        :null => false
    t.string   "process_id",     :limit => 22,                        :null => false
    t.string   "submitter_type", :limit => 30,                        :null => false
    t.string   "submitter_id",   :limit => 22,                        :null => false
    t.string   "status_code",    :limit => 30, :default => "ENABLED"
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_field_updates", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                         :null => false
    t.string   "bo_code",           :limit => 30,                         :null => false
    t.string   "name",              :limit => 60,                         :null => false
    t.string   "field_update_code", :limit => 30,                         :null => false
    t.string   "description",       :limit => 150
    t.string   "relation_bo",       :limit => 30
    t.string   "object_attribute",  :limit => 30,                         :null => false
    t.string   "value_type",        :limit => 30,                         :null => false
    t.string   "value",             :limit => 150
    t.string   "status_code",       :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_mail_alerts", :force => true do |t|
    t.string   "opu_id",             :limit => 22,                         :null => false
    t.string   "name",               :limit => 60,                         :null => false
    t.string   "mail_alert_code",    :limit => 30,                         :null => false
    t.string   "bo_code",            :limit => 30,                         :null => false
    t.string   "description",        :limit => 150
    t.string   "mail_template_code", :limit => 30,                         :null => false
    t.string   "additional_email",   :limit => 250
    t.string   "from_email",         :limit => 150
    t.string   "status_code",        :limit => 30,  :default => "ENABLED"
    t.string   "created_by",         :limit => 22
    t.string   "updated_by",         :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_mail_recipients", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                        :null => false
    t.string   "wf_mail_alert_id", :limit => 22,                        :null => false
    t.string   "recipient_type",   :limit => 30,                        :null => false
    t.string   "recipient_id",     :limit => 22,                        :null => false
    t.string   "status_code",      :limit => 30, :default => "ENABLED"
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_process_instances", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "process_id",          :limit => 22
    t.string   "next_approver_id",    :limit => 22
    t.string   "bo_id",               :limit => 22
    t.string   "bo_model_name"
    t.string   "bo_description"
    t.string   "submitter_id",        :limit => 22
    t.string   "process_status_code", :limit => 30,  :default => "SUBMITTED"
    t.string   "comment",             :limit => 150
    t.string   "status_code",         :limit => 30,  :default => "ENABLED"
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_at"
  end

  add_index "irm_wf_process_instances", ["process_id", "bo_id"], :name => "IRM_WF_PROCESS_INSTANCES_N1"

  create_table "irm_wf_rule_actions", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                        :null => false
    t.string   "rule_id",             :limit => 22,                        :null => false
    t.string   "action_mode",         :limit => 30
    t.string   "action_type",         :limit => 60,                        :null => false
    t.string   "action_reference_id", :limit => 22,                        :null => false
    t.string   "time_trigger_id",     :limit => 22
    t.string   "status_code",         :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_wf_rule_actions", ["rule_id"], :name => "IRM_WF_RULE_ACTIONS_N1"

  create_table "irm_wf_rule_histories", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "event_id",    :limit => 22
    t.string   "rule_id",     :limit => 22,                        :null => false
    t.string   "bo_code",     :limit => 30
    t.string   "bo_id",       :limit => 22,                        :null => false
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22
    t.string   "updated_by",  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_wf_rule_histories", ["event_id", "rule_id"], :name => "IRM_WF_RULE_HISTORIES_N1"

  create_table "irm_wf_rule_time_triggers", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                         :null => false
    t.string   "rule_id",             :limit => 22,                         :null => false
    t.string   "name",                :limit => 60
    t.string   "description",         :limit => 150
    t.string   "trigger_mode",        :limit => 30,                         :null => false
    t.string   "time_unit",           :limit => 60,                         :null => false
    t.integer  "time_lead"
    t.string   "trigger_data_object", :limit => 30,                         :null => false
    t.string   "status_code",         :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_wf_rule_time_triggers", ["rule_id"], :name => "IRM_WF_RULE_TIME_TRIGGERS_N1"

  create_table "irm_wf_rules", :force => true do |t|
    t.string   "opu_id",                 :limit => 22,                         :null => false
    t.string   "bo_code",                :limit => 30,                         :null => false
    t.string   "rule_code",              :limit => 30,                         :null => false
    t.string   "name",                   :limit => 60,                         :null => false
    t.string   "description",            :limit => 150
    t.string   "evaluate_criteria_rule", :limit => 30,                         :null => false
    t.string   "evaluate_rule_mode",     :limit => 30,                         :null => false
    t.string   "status_code",            :limit => 30,  :default => "OFFLINE", :null => false
    t.string   "created_by",             :limit => 22
    t.string   "updated_by",             :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irm_wf_rules", ["bo_code"], :name => "IRM_WF_RULE_N1"
  add_index "irm_wf_rules", ["rule_code"], :name => "IRM_WF_RULE_N2"

  create_table "irm_wf_settings", :force => true do |t|
    t.string   "opu_id",                     :limit => 22,                        :null => false
    t.string   "default_workflow_person_id", :limit => 22
    t.string   "email_approval_flag",        :limit => 1,  :default => "N",       :null => false
    t.string   "status_code",                :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",                 :limit => 22
    t.string   "updated_by",                 :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "irm_wf_step_instances", :force => true do |t|
    t.string   "opu_id",      :limit => 22
    t.string   "process_instance_id",  :limit => 22,                         :null => false
    t.string   "batch_id",             :limit => 22
    t.string   "step_id",              :limit => 22,                         :null => false
    t.string   "assign_approver_id",   :limit => 22
    t.string   "actual_approver_id",   :limit => 22
    t.string   "approval_status_code", :limit => 30,  :default => "PENDING"
    t.string   "comment",              :limit => 150
    t.string   "status_code",          :limit => 30,  :default => "ENABLED"
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_at"
  end

  add_index "irm_wf_step_instances", ["actual_approver_id"], :name => "IRM_WF_STEP_INSTANCES_N2"
  add_index "irm_wf_step_instances", ["process_instance_id", "step_id"], :name => "IRM_WF_STEP_INSTANCES_N1"

  create_table "irm_wf_tasks", :force => true do |t|
    t.string   "opu_id",           :limit => 22
    t.string   "calendar_id",      :limit => 22
    t.string   "name",             :limit => 150,                         :null => false
    t.string   "description",      :limit => 3000
    t.string   "location",         :limit => 240
    t.string   "string",           :limit => 240
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "completed"
    t.integer  "percent_complete"
    t.string   "priority",         :limit => 30
    t.text     "url"
    t.boolean  "all_day",                          :default => false
    t.string   "color",            :limit => 30
    t.string   "source_type",      :limit => 30
    t.string   "source_id",        :limit => 22
    t.string   "task_status",      :limit => 30
    t.string   "parent_id",        :limit => 22
    t.text     "rrule"
    t.string   "status_code",      :limit => 30,   :default => "ENABLED", :null => false
    t.string   "created_by",       :limit => 22
    t.string   "updated_by",       :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_column_accesses", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                        :null => false
    t.string   "column_id",   :limit => 22,                        :null => false
    t.string   "source_type", :limit => 30
    t.string   "source_id",   :limit => 22
    t.string   "status_code", :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                        :null => false
    t.string   "updated_by",  :limit => 22,                        :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "skm_columns", :force => true do |t|
    t.string   "opu_id",           :limit => 22,                        :null => false
    t.string   "parent_column_id", :limit => 22
    t.string   "column_code",      :limit => 30,                        :null => false
    t.string   "status_code",      :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",       :limit => 22,                        :null => false
    t.string   "updated_by",       :limit => 22,                        :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "skm_columns", ["column_code","opu_id"], :name => "SKM_COLUMNS_U1", :unique => true

  create_table "skm_columns_tl", :force => true do |t|
    t.string   "opu_id",      :limit => 22,                         :null => false
    t.string   "column_id",   :limit => 22,                         :null => false
    t.string   "name",        :limit => 150,                        :null => false
    t.string   "description", :limit => 240
    t.string   "language",    :limit => 30,                         :null => false
    t.string   "source_lang", :limit => 30,                         :null => false
    t.string   "status_code", :limit => 30,  :default => "ENABLED", :null => false
    t.string   "created_by",  :limit => 22,                         :null => false
    t.string   "updated_by",  :limit => 22,                         :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "skm_columns_tl", ["column_id", "language"], :name => "SKM_COLUMNS_TL_U1", :unique => true
  add_index "skm_columns_tl", ["column_id"], :name => "SKM_COLUMNS_TL_N1"

  execute('CREATE OR REPLACE VIEW skm_columns_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM skm_columns t,skm_columns_tl tl
                                           WHERE t.id = tl.column_id')


  create_table "skm_entry_columns", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "entry_header_id", :limit => 22,                        :null => false
    t.string   "column_id",       :limit => 22,                        :null => false
    t.string   "status_code",     :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",      :limit => 22,                        :null => false
    t.string   "updated_by",      :limit => 22,                        :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "skm_entry_details", :force => true do |t|
    t.string   "opu_id",                    :limit => 22,                         :null => false
    t.string   "entry_header_id",           :limit => 22,                         :null => false
    t.string   "element_name",              :limit => 60,                         :null => false
    t.string   "element_description",       :limit => 150
    t.integer  "default_rows",                             :default => 4
    t.string   "entry_template_element_id", :limit => 22
    t.text     "entry_content"
    t.string   "required_flag",             :limit => 1
    t.integer  "line_num"
    t.string   "status_code",               :limit => 30,  :default => "ENABLED"
    t.string   "created_by",                :limit => 22
    t.string   "updated_by",                :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_favorites", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "entry_header_id", :limit => 22,                        :null => false
    t.string   "person_id",       :limit => 22,                        :null => false
    t.string   "status_code",     :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",      :limit => 22,                        :null => false
    t.string   "updated_by",      :limit => 22,                        :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "skm_entry_headers", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                         :null => false
    t.string   "entry_template_id", :limit => 22,                         :null => false
    t.string   "entry_title",       :limit => 60,                         :null => false
    t.string   "keyword_tags",      :limit => 150
    t.string   "doc_number",        :limit => 30
    t.string   "history_flag",      :limit => 1,   :default => "N"
    t.string   "entry_status_code", :limit => 30
    t.string   "version_number",    :limit => 30
    t.datetime "published_date"
    t.string   "author_id",         :limit => 22
    t.string   "source_type",       :limit => 30
    t.string   "source_id",         :limit => 22
    t.string   "status_code",       :limit => 30,  :default => "ENABLED"
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_operate_histories", :force => true do |t|
    t.string   "opu_id",            :limit => 22
    t.string   "operate_code",                 :null => false
    t.string   "incident_id",    :limit => 22
    t.string   "entry_id",       :limit => 22
    t.integer  "version_number"
    t.string   "opu_id",         :limit => 22
    t.string   "search_key",     :limit => 50
    t.integer  "result_count"
    t.integer  "var_num1"
    t.integer  "var_num2"
    t.integer  "var_num3"
    t.string   "var_str1",       :limit => 50
    t.string   "var_str2",       :limit => 50
    t.string   "var_str3",       :limit => 50
    t.string   "created_by",     :limit => 22
    t.string   "updated_by",     :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_statuses", :force => true do |t|
    t.string   "opu_id",            :limit => 22,                        :null => false
    t.string   "entry_status_code", :limit => 30,                        :null => false
    t.string   "visiable_flag",     :limit => 1,  :default => "Y"
    t.string   "status_code",       :limit => 30, :default => "ENABLED"
    t.string   "created_by",        :limit => 22
    t.string   "updated_by",        :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_statuses_tl", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                         :null => false
    t.string   "entry_status_id", :limit => 22,                         :null => false
    t.string   "name",            :limit => 60,                         :null => false
    t.string   "description",     :limit => 150
    t.string   "language",        :limit => 30,                         :null => false
    t.string   "source_lang",     :limit => 30,                         :null => false
    t.string   "status_code",     :limit => 30,  :default => "ENABLED"
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skm_entry_statuses_tl", ["entry_status_id", "language"], :name => "SKM_ENTRY_STATUSES_TL_U1", :unique => true
  add_index "skm_entry_statuses_tl", ["entry_status_id"], :name => "SKM_ENTRY_STATUSES_TL_N1"

  execute('CREATE OR REPLACE VIEW skm_entry_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM skm_entry_statuses t,skm_entry_statuses_tl tl
                                           WHERE t.id = tl.entry_status_id')

  create_table "skm_entry_subjects", :force => true do |t|
    t.string   "opu_id",          :limit => 22,                        :null => false
    t.string   "entry_header_id", :limit => 22,                        :null => false
    t.string   "subject_id",      :limit => 22,                        :null => false
    t.string   "status_code",     :limit => 30, :default => "ENABLED"
    t.string   "created_by",      :limit => 22
    t.string   "updated_by",      :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_template_details", :force => true do |t|
    t.string   "opu_id",                    :limit => 22,                        :null => false
    t.string   "entry_template_id",         :limit => 22,                        :null => false
    t.string   "entry_template_element_id", :limit => 22,                        :null => false
    t.integer  "line_num"
    t.string   "required_flag",             :limit => 1,  :default => "N"
    t.integer  "default_rows",                            :default => 4
    t.string   "status_code",               :limit => 30, :default => "ENABLED"
    t.string   "created_by",                :limit => 22
    t.string   "updated_by",                :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_template_elements", :force => true do |t|
    t.string   "opu_id",                      :limit => 22,                         :null => false
    t.string   "entry_template_element_code", :limit => 30,                         :null => false
    t.integer  "default_rows",                               :default => 4
    t.string   "name",                        :limit => 60,                         :null => false
    t.string   "description",                 :limit => 150
    t.string   "status_code",                 :limit => 30,  :default => "ENABLED"
    t.string   "created_by",                  :limit => 22
    t.string   "updated_by",                  :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_entry_templates", :force => true do |t|
    t.string   "opu_id",              :limit => 22,                         :null => false
    t.string   "entry_template_code", :limit => 30,                         :null => false
    t.string   "name",                :limit => 60,                         :null => false
    t.string   "description",         :limit => 150
    t.string   "status_code",         :limit => 30,  :default => "ENABLED"
    t.string   "created_by",          :limit => 22
    t.string   "updated_by",          :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_file_operate_histories", :force => true do |t|
    t.string   "opu_id",              :limit => 22
    t.string   "operate_code",                :null => false
    t.string   "attachment_id", :limit => 22
    t.string   "version_id",    :limit => 22
    t.string   "file_name"
    t.string   "opu_id",        :limit => 22
    t.integer  "var_num1"
    t.integer  "var_num2"
    t.integer  "var_num3"
    t.string   "var_str1",      :limit => 50
    t.string   "var_str2",      :limit => 50
    t.string   "var_str3",      :limit => 50
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skm_settings", :force => true do |t|
    t.string   "opu_id",                 :limit => 22,                        :null => false
    t.string   "sidebar_flag",           :limit => 1,  :default => "Y",       :null => false
    t.string   "sidebar_file_menu_flag", :limit => 1,  :default => "N",       :null => false
    t.string   "status_code",            :limit => 30, :default => "ENABLED", :null => false
    t.string   "created_by",             :limit => 22
    t.string   "updated_by",             :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slm_service_agreements", :force => true do |t|
    t.string  "opu_id",                       :limit => 22, :null => false
    t.string  "agreement_code",               :limit => 30
    t.date    "active_start_date"
    t.date    "active_end_date"
    t.integer "response_time"
    t.integer "resolve_time"
    t.string  "business_object_code",         :limit => 30
    t.string  "rule_filter_code",             :limit => 30
    t.string  "response_escalation_enabled",  :limit => 1
    t.string  "rs_first_escalation_mode",     :limit => 30
    t.integer "rs_first_elapse_time"
    t.string  "rs_first_assignee_type"
    t.string  "rs_first_escalation_assignee"
    t.string  "first_escalation_enabled",     :limit => 1
    t.string  "first_escalation_mode",        :limit => 30
    t.integer "first_elapse_time"
    t.string  "first_assignee_type",          :limit => 30
    t.string  "first_escalation_assignee",    :limit => 30
    t.string  "second_escalation_enabled",    :limit => 1
    t.string  "second_escalation_mode",       :limit => 30
    t.integer "second_elapse_time"
    t.string  "second_assignee_type",         :limit => 30
    t.string  "second_escalation_assignee",   :limit => 30
    t.string  "third_escalation_enabled",     :limit => 1
    t.string  "third_escalation_mode",        :limit => 30
    t.integer "third_elapse_time"
    t.string  "third_assignee_type",          :limit => 30
    t.string  "third_escalation_assignee",    :limit => 30
    t.string  "fourth_escalation_enabled",    :limit => 1
    t.string  "fourth_escalation_mode",       :limit => 30
    t.integer "fourth_elapse_time"
    t.string  "fourth_assignee_type",         :limit => 30
    t.string  "fourth_escalation_assignee",   :limit => 30
    t.string  "status_code",                  :limit => 30, :null => false
    t.string  "created_by",                   :limit => 22
    t.string  "updated_by",                   :limit => 22
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "service_company_id",           :limit => 22
  end

  add_index "slm_service_agreements", ["agreement_code"], :name => "SLM_SERVICE_AGREEMENTS_N1"

  create_table "slm_service_agreements_tl", :force => true do |t|
    t.string "opu_id",               :limit => 22,  :null => false
    t.string "service_agreement_id", :limit => 22
    t.string "name",                 :limit => 30
    t.string "description",          :limit => 150, :null => false
    t.string "language",             :limit => 30,  :null => false
    t.string "source_lang",          :limit => 30,  :null => false
    t.string "status_code",          :limit => 30,  :null => false
    t.string "created_by",           :limit => 22
    t.string "updated_by",           :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  execute('CREATE OR REPLACE VIEW slm_service_agreements_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM slm_service_agreements t,slm_service_agreements_tl tl
                                           WHERE t.id = tl.service_agreement_id')


  create_table "slm_service_breaks", :force => true do |t|
    t.string  "opu_id",             :limit => 22,  :null => false
    t.string  "service_catalog_id", :limit => 22
    t.integer "seq_number"
    t.string  "start_time",         :limit => 30
    t.string  "end_time",           :limit => 30
    t.string  "description",        :limit => 150
    t.string  "status_code",        :limit => 30,  :null => false
    t.string  "created_by",         :limit => 22
    t.string  "updated_by",         :limit => 22
    t.date    "created_at"
    t.date    "updated_at"
  end

  add_index "slm_service_breaks", ["service_catalog_id", "seq_number"], :name => "SLM_SERVICE_BREAKS_N1"

  create_table "slm_service_catalogs", :force => true do |t|
    t.string   "opu_id",                :limit => 22,                        :null => false
    t.string   "catalog_code",          :limit => 30
    t.string   "service_category_code", :limit => 30
    t.string   "priority_code",         :limit => 30
    t.string   "external_system_id",    :limit => 22
    t.date     "active_start_date"
    t.date     "active_end_date"
    t.string   "service_owner_id",      :limit => 22
    t.string   "slm_code",              :limit => 30
    t.string   "statistics_api",        :limit => 60
    t.string   "status_code",           :limit => 30, :default => "ENABLED"
    t.string   "created_by",            :limit => 22
    t.string   "updated_by",            :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slm_service_catalogs", ["opu_id", "catalog_code"], :name => "SLM_SERVICE_CATALOGS_N1"

  create_table "slm_service_catalogs_tl", :force => true do |t|
    t.string "opu_id",             :limit => 22,  :null => false
    t.string "service_catalog_id", :limit => 22
    t.string "name",               :limit => 30
    t.string "description",        :limit => 150, :null => false
    t.string "language",           :limit => 30,  :null => false
    t.string "source_lang",        :limit => 30,  :null => false
    t.string "status_code",        :limit => 30,  :null => false
    t.string "created_by",         :limit => 22
    t.string "updated_by",         :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "slm_service_catalogs_tl", ["service_catalog_id", "language"], :name => "SLM_SERVICE_CATALOGS_TL_N1"

  execute('CREATE OR REPLACE VIEW slm_service_catalogs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM slm_service_catalogs  t,slm_service_catalogs_tl tl
                                             WHERE t.id = tl.service_catalog_id')

  create_table "slm_service_categories", :force => true do |t|
    t.string   "opu_id",        :limit => 22,                        :null => false
    t.string   "category_code", :limit => 30
    t.string   "status_code",   :limit => 30, :default => "ENABLED"
    t.string   "created_by",    :limit => 22
    t.string   "updated_by",    :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slm_service_categories", ["opu_id", "category_code"], :name => "SLM_SERVICE_CATEGORIES_N1"

  create_table "slm_service_categories_tl", :force => true do |t|
    t.string "opu_id",              :limit => 22,  :null => false
    t.string "service_category_id", :limit => 22
    t.string "name",                :limit => 30
    t.string "description",         :limit => 150, :null => false
    t.string "language",            :limit => 30,  :null => false
    t.string "source_lang",         :limit => 30,  :null => false
    t.string "status_code",         :limit => 30,  :null => false
    t.string "created_by",          :limit => 22
    t.string "updated_by",          :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "slm_service_categories_tl", ["service_category_id", "language"], :name => "SLM_SERVICE_CATEGORIES_TL_N1"

  execute('CREATE OR REPLACE VIEW slm_service_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM slm_service_categories  t,slm_service_categories_tl tl
                                             WHERE t.id = tl.service_category_id')

  create_table "slm_service_members", :force => true do |t|
    t.string "opu_id",                  :limit => 22, :null => false
    t.string "service_catalog_id",      :limit => 22
    t.string "service_company_id",      :limit => 22
    t.string "service_organization_id", :limit => 22
    t.string "service_department_id",   :limit => 22
    t.string "service_person_id",       :limit => 22
    t.string "service_contract_id",     :limit => 22
    t.string "description"
    t.string "status_code",             :limit => 30, :null => false
    t.string "created_by",              :limit => 22
    t.string "updated_by",              :limit => 22
    t.date   "created_at"
    t.date   "updated_at"
  end

  add_index "slm_service_members", ["service_catalog_id", "service_company_id", "service_organization_id", "service_department_id", "service_person_id", "service_contract_id"], :name => "SLM_SERVICE_MEMBERS_N1"

  create_table "uid_external_logins", :force => true do |t|
    t.string   "opu_id",               :limit => 22
    t.string   "external_system_code", :limit => 30
    t.string   "external_login_name",  :limit => 60
    t.string   "external_login_id",    :limit => 22
    t.date     "active_start_date"
    t.date     "active_end_date"
    t.string   "source_type",          :limit => 30
    t.string   "description",          :limit => 300
    t.string   "status_code",          :limit => 30,  :default => "ENABLED"
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uid_external_logins", ["opu_id", "external_system_code", "external_login_name", "external_login_id"], :name => "UID_EXTERNAL_LOGINS_N1"

  create_table "uid_user_login_mappings", :force => true do |t|
    t.string   "opu_id",               :limit => 22
    t.string   "external_system_code", :limit => 30
    t.string   "external_login_name",  :limit => 30
    t.string   "person_id",            :limit => 22
    t.string   "status_code",          :limit => 30, :default => "ENABLED"
    t.string   "created_by",           :limit => 22
    t.string   "updated_by",           :limit => 22
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  execute("CREATE OR REPLACE VIEW irm_person_relations_v AS
             select people.id source_id,'IRM__PERSON' source_type,people.id person_id from irm_people people
             union
             select people.organization_id source_id,'IRM__ORGANIZATION' source_type,people.id person_id from irm_people people where people.organization_id IS NOT NULL
             union
             select people.organization_id source_id,'IRM__ORGANIZATION_EXPLOSION' source_type,people.id person_id from irm_people people where people.organization_id IS NOT NULL
             union
             select explosions.parent_org_id source_id,'IRM__ORGANIZATION_EXPLOSION' source_type,people.id person_id from irm_people people,irm_organization_explosions explosions where people.organization_id = explosions.organization_id AND  people.organization_id IS NOT NULL
             union
             select people.role_id source_id,'IRM__ROLE' source_type,people.id person_id from irm_people people where people.role_id IS NOT NULL
             union
             select people.role_id source_id,'IRM__ROLE_EXPLOSION' source_type,people.id person_id from irm_people people where people.role_id IS NOT NULL
             union
             select explosions.parent_role_id source_id,'IRM__ROLE_EXPLOSION' source_type,people.id person_id from irm_people people,irm_role_explosions explosions where people.role_id = explosions.role_id AND people.role_id IS NOT NULL
             union
             select people.group_id source_id,'IRM__GROUP' source_type,people.person_id person_id from irm_group_members people
             union
             select people.group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people
             union
             select explosions.parent_group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people,irm_group_explosions explosions where people.group_id = explosions.group_id AND people.group_id IS NOT NULL
             union
             select systems.id source_id,'IRM__EXTERNAL_SYSTEM' source_type,people.person_id person_id from irm_external_system_people people,irm_external_systems systems where people.external_system_id = systems.id
  ")

    ts = ActiveRecord::Base.connection.execute("show  tables")
    columns = []
    ci_array = ["created_by","updated_by"]
    ts.each do |t|
      next if t.first.end_with?("_vl")||t.first.end_with?("_v")
      ActiveRecord::Base.connection.execute("describe  #{t.first}").each do |c|
        columns << {:table_name=>t.first,:column_name=>c.first}  if c.first.eql?("id")
      end
    end
    columns.each do |c|
      change_column c[:table_name], c[:column_name], :string,:limit=>22, :collate=>"utf8_bin"
    end
    execute("ALTER TABLE `irm_object_codes` CHANGE `id` `id` int(11) DEFAULT NULL auto_increment  NOT NULL")
    execute("ALTER TABLE `irm_machine_codes` CHANGE `id` `id` int(11) DEFAULT NULL auto_increment  NOT NULL")
    change_column :irm_object_codes, "object_code", :string,:limit=>4, :collate=>"utf8_bin"
    change_column :irm_machine_codes, "machine_code", :string,:limit=>4, :collate=>"utf8_bin"
    ts.each do |t|
      next  if t.first.end_with?("_vl")||t.first.end_with?("_v")
      Irm::ObjectCode.code(t.first)
    end
  end

  def self.down
  end
end
