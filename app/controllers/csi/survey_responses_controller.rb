class Csi::SurveyResponsesController < ApplicationController
  def new
    @survey_member = Csi::SurveyMember.find(params[:survey_member_id])
    @survey = @survey_member.survey

    respond_to do |format|
        if @survey && @survey.password.present? &&(!session[:survey_token].present?||session[:survey_token] != params[:survey_token])
          format.html {redirect_with_back(:action=>"fill_password",:survey_member_id=>@survey_member.id)}
        else
          format.html {render :layout => "application_full"}
        end
    end

  end

  def create
    @survey_member = Csi::SurveyMember.find(params[:survey_member_id])
    @survey = @survey_member.survey
    survey_response = Csi::SurveyResponse.new(:ip_address=>request.remote_ip,:survey_id=>@survey.id,:survey_member_id=>@survey_member.id,:person_id=>Irm::Person.current.id,:source_type=>"SURVEY_MEMBER",:start_at=>params[:start_at],:end_at=>Time.now)
    survey_subjects = Csi::SurveySubject.where(:survey_id=>@survey.id).where("input_type!= ?","page")
    survey_subjects.each do |subject|
      case subject.input_type
        when "string","text"
          survey_response.survey_results.build(:survey_subject_id=>subject.id,:result_type=>"INPUT",:text_input=>params[:result][subject.id])
        when "radio","drop"
          if "_other".eql?(params[:result][subject.id])
            survey_response.survey_results.build(:survey_subject_id=>subject.id,:result_type=>"OTHER",:text_input=>params[:result][:other][subject.id])
          else
            survey_response.survey_results.build(:survey_subject_id=>subject.id,:result_type=>"OPTION",:survey_subject_option_id=>params[:result][subject.id])
          end
        when "check"
          if params[:result][subject.id]&&params[:result][subject.id].is_a?(Array)
            params[:result][subject.id].each do |option|
              if option.eql?("_other")
                survey_response.survey_results.build(:survey_subject_id=>subject.id,:result_type=>"OTHER",:text_input=>params[:result][:other][subject.id]) if params[:result][:other][subject.id].present?
              else
                survey_response.survey_results.build(:survey_subject_id=>subject.id,:result_type=>"OPTION",:survey_subject_option_id=>option)
              end
            end
          end
      end
    end

    respond_to do |format|
      if survey_response.save
        @survey_member.update_attribute(:response_flag,Irm::Constant::SYS_YES)
        format.html {redirect_back_or_default}
      else
        render "new"
      end
    end

  end

  def show

  end


  def fill_password
    survey_member = Csi::SurveyMember.find(params[:survey_member_id])
    @survey = survey_member.survey
    @survey.password = ""
    respond_to do |format|
      format.html
    end
  end

  def validate_password
    survey_member = Csi::SurveyMember.find(params[:survey_member_id])
    @survey = survey_member.survey
    confirm_survey =  Csi::Survey.new(params[:csi_survey])
    session[:survey_token] = Irm::IdGenerator.instance.generate(Csi::Survey.table_name)
    redirect_with_back(:action=>"new",:survey_token=>session[:survey_token])
  end

  def show_thanks

  end

end
