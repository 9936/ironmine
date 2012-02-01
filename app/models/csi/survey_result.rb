# -*- coding: utf-8 -*-
class Csi::SurveyResult < ActiveRecord::Base
  set_table_name :csi_survey_results
  belongs_to :survey_response

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :join_subject,lambda{
    joins("JOIN #{Csi::SurveySubject.table_name} ON #{Csi::SurveySubject.table_name}.id = #{table_name}.survey_subject_id")
  }

  scope :with_option,lambda{
    joins("LEFT OUTER JOIN #{Csi::SubjectOption.table_name} ON #{Csi::SubjectOption.table_name}.id = #{table_name}.survey_subject_option_id").
        select("#{Csi::SubjectOption.table_name}.value option_value")
  }

  scope :with_response,lambda{
    joins("JOIN #{Csi::SurveyResponse.table_name} ON #{Csi::SurveyResponse.table_name}.id = #{table_name}.survey_response_id").
        joins("JOIN #{Irm::Person.table_name} ON #{Csi::SurveyResponse.table_name}.person_id = #{Irm::Person.table_name}.id").
        select("#{Irm::Person.table_name}.full_name person_name,#{Csi::SurveyResponse.table_name}.start_at")
  }

  def self.list_all
    select("#{table_name}.*").with_survey_subject
  end
end