# -*- coding: utf-8 -*-
class Csi::SurveyResponse < ActiveRecord::Base
  set_table_name :csi_survey_responses
  belongs_to :survey

  validates_presence_of :survey_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

end