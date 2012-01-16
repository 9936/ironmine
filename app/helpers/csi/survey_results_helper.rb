module Csi::SurveyResultsHelper
  def survey_statistics(survey_id)
    datas = {}


    response_count = Csi::SurveyResponse.where(:survey_id=>survey_id).count

    datas[:response_count] = response_count

    option_counts = Csi::SurveyResult.select("#{Csi::SurveyResult.table_name}.survey_subject_option_id,count(*) option_count").
        joins("JOIN #{Csi::SurveyResponse.table_name} ON #{Csi::SurveyResponse.table_name}.id = #{Csi::SurveyResult.table_name}.survey_response_id").
        where("#{Csi::SurveyResponse.table_name}.survey_id = ? AND #{Csi::SurveyResult.table_name}.result_type = ?",survey_id,"OPTION").group("#{Csi::SurveyResult.table_name}.survey_subject_option_id")
    grouped_option_counts = {}
    option_counts.each do |option_count|
      grouped_option_counts[option_count[:survey_subject_option_id]] = {:survey_subject_option_id=>option_count[:survey_subject_option_id],:option_count=>option_count[:option_count],:percent=>response_count==0 ? 0 : option_count[:option_count].fdiv(response_count)*100.round(3)}
    end

    datas[:grouped_option_counts] = grouped_option_counts

    input_counts = Csi::SurveyResult.select("#{Csi::SurveyResult.table_name}.survey_subject_id,count(*) input_count").
        joins("JOIN #{Csi::SurveyResponse.table_name} ON #{Csi::SurveyResponse.table_name}.id = #{Csi::SurveyResult.table_name}.survey_response_id").
        where("#{Csi::SurveyResponse.table_name}.survey_id = ? AND #{Csi::SurveyResult.table_name}.result_type IN (?)",survey_id,["INPUT","OTHER"]).group("#{Csi::SurveyResult.table_name}.survey_subject_id")

    grouped_input_counts = {}

    input_counts.each do |input_count|
      grouped_input_counts[input_count[:survey_subject_id]] = input_count[:input_count]
    end

    datas[:grouped_input_counts] = grouped_input_counts

    datas[:subject_types] = subject_types

    datas
  end

  def subject_types
    types = {}
    Csi::SurveySubject::TYPES.map{|h| types[h[1].to_sym] = t("label_csi_survey_subject_type_#{h[0]}") }
    types
  end

  def survey_response_data(survey_response)
    results = Csi::SurveyResult.select_all.with_option.where(:survey_response_id=>survey_response.id)
    datas = {}
    results.each do |result|
      if datas[result.survey_subject_id]
        datas[result.survey_subject_id] << result
      else
        datas[result.survey_subject_id] = [result]
      end
    end
    datas
  end
end
