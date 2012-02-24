class Csi::SurveyResultsController < ApplicationController
  def statistics
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      format.html {render :layout => "application_full"}
    end
  end

  def list
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      format.html {render :layout => "application_full"}
    end
  end

  def get_data
    survey_responses_scope = Csi::SurveyResponse.list_all.where(:survey_id=>params[:id])
    survey_responses_scope = survey_responses_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    survey_responses,count = paginate(survey_responses_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(survey_responses.to_grid_json([:person_name,:start_at,:elapse,:ip_address],count))}
    end
  end

  def show_input
    @survey_subject = Csi::SurveySubject.find(params[:id])
    @text_inputs = Csi::SurveyResult.select_all.with_response.where("result_type IN (?)",["OTHER","INPUT"]).where(:survey_subject_id=>params[:id])
  end


  def show_response
    @survey_response = Csi::SurveyResponse.find(params[:id])
    respond_to do |format|
      format.html {render :layout => "application_full"}
    end
  end

end
