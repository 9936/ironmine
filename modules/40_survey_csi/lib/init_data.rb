#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:CSI_SURVEY=================================
  map.function_group :csi_survey, {
      :en => {:name => "Survey", :description => "Survey"},
      :zh => {:name => "调查问卷", :description => "调查问卷"}, }
  map.function_group :csi_survey, {
      :zone_code => "CSI_SURVEY",
      :controller => "csi/surveys",
      :action => "index"}
  map.function_group :csi_survey, {
      :children => {
          :view_survey => {
              :en => {:name => "View Survey", :description => "View Survey"},
              :zh => {:name => "查看调查问卷", :description => "查看调查问卷"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "csi/surveys" => ["get_data", "index", "show"],
              "csi/survey_ranges" => ["get_data", "index", "show"],
              "csi/survey_subjects" => ["get_data", "index", "show"],
          },
          :new_survey => {
              :en => {:name => "Initiate Survey", :description => "Initiate Survey"},
              :zh => {:name => "发起调查", :description => "发起调查"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "csi/surveys" => ["create", "new"],
              "csi/survey_ranges" => ["create", "new"],
              "csi/survey_subjects" => ["create", "new"],
          },
          :edit_survey => {
              :en => {:name => "Edit Survey", :description => "Edit Survey"},
              :zh => {:name => "编辑调查问卷", :description => "编辑调查问卷"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "csi/surveys" => ["active", "edit", "update"],
              "csi/survey_ranges" => ["edit", "update"],
              "csi/survey_subjects" => ["destroy", "edit", "update"],
          },
          :view_survey_result => {
              :en => {:name => "View Survey Result", :description => "View Survey Result"},
              :zh => {:name => "查看调查结果", :description => "查看调查结果"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "csi/surveys" => ["export_result", "show_result", "survey_report"],
          },
          :reply_survey => {
              :en => {:name => "Reply Survey", :description => "Reply Survey"},
              :zh => {:name => "参与调查", :description => "参与调查"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "csi/surveys" => ["create_result", "password", "reply", "show_reply", "thanks"],
          },
      }
  }
  #=================================END:CSI_SURVEY=================================
end