class Csi::SubjectOption < ActiveRecord::Base
  set_table_name :csi_survey_subject_options

  belongs_to :survey_subject,:foreign_key=>"survey_subject_id"

  scope :query_by_subject_id, lambda{|subject_id,option_type|
               joins(:survey_subject).
               where("#{table_name}.survey_subject_id = ? and  #{Csi::SurveySubject.table_name}.input_type=?",
                     subject_id,option_type)
  }

  scope :query_by_survey,lambda{|survey_id|
    joins(:survey_subject).where("#{Csi::SurveySubject.table_name}.survey_id = ?",survey_id)
  }
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.delete_by_subject(subject_id)
    delete_all :subject_id=>subject_id
  end

end