class Csi::SurveyRange < ActiveRecord::Base
  set_table_name :csi_survey_ranges

  query_extend


  belongs_to :survey

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.source_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.source_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }



  def self.query_range_person_count(survey_id)
    Csi::SurveyMember.query_by_survey_id(survey_id).count
  end

end
