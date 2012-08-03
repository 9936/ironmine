class Csi::SurveyRange < ActiveRecord::Base
  set_table_name :csi_survey_ranges

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  belongs_to :survey

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.source_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.source_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }



  def self.query_range_person_count(survey_id)
    su = Csi::Survey.where(:id => survey_id).first
    if su.with_incident_request == Irm::Constant::SYS_YES || su.status_code != Irm::Constant::ENABLED
      return -1
    else
      return Csi::SurveyMember.query_by_survey_id(survey_id).count
    end
  rescue
    -1
  end

end
