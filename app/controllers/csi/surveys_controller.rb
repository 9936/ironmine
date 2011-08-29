class Csi::SurveysController < ApplicationController
  # GET /surveys
  # GET /surveys.xml
  def index
    @surveys = Csi::Survey.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    @survey = Csi::Survey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    @survey =Csi::Survey.new(:status_code=>"OFFLINE")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Csi::Survey.find(params[:id])
  end

  # POST /surveys
  # POST /surveys.xml
  def create
    @survey = Csi::Survey.new(params[:csi_survey])

    respond_to do |format|
      if @survey.save
        @survey.create_range_from_str
        format.html { redirect_to({:action=>"show",:id=>@survey.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @survey, :status => :created, :location => @survey }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      if @survey.update_attributes(params[:csi_survey])
         @survey.create_range_from_str
        format.html { redirect_to({:action=>"show",:id=>@survey.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey = Csi::Survey.find(params[:id])
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to(surveys_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    @surveys= Csi::Survey.query_wrap_info(I18n::locale).with_person_count.with_allow_author.order("created_at desc")
    @surveys = @surveys.match_value("#{Csi::Survey.table_name}.title",params[:title])
    @surveys,count = paginate(@surveys)
    @surveys_new = []
    @surveys.each do |s|
      s.person_count = Csi::SurveyRange.query_range_person_count(s.id)
      s.allow_author_only = s.current_author? if s.result_only_author == Irm::Constant::SYS_YES
      s.allow_author_only = "Y" if s.result_only_author == Irm::Constant::SYS_NO
      @surveys_new << s
    end
    respond_to do |format|
      format.json {render :json=>to_jsonp(@surveys_new.to_grid_json(['R',:title,:description,:status_meaning, :joined_count, :person_count, :created_at, :published_at, :allow_author_only], count))}
    end
  end 

  def password
    @survey = Csi::Survey.find(params[:id]) rescue nil

    respond_to do |format|
      if @survey
        session[:survey_password] = params[:password] if params[:password]
        format.html {redirect_to({:action=>"reply",:id=>params[:id]})}
      else
        flash[:notice] = t(:label_csi_survey_no_form)
        format.html { redirect_to({:action=>"index"})}
      end
    end
  end

  def reply
    @survey = Csi::Survey.find(params[:id]) rescue nil
    @survey_member_id = params[:survey_member_id]

    respond_to do |format|
      if @survey && !@survey.password.blank? &&
        session[:survey_password] != @survey.password
        format.html { render 'password'}
      elsif @survey
        @page = (params[:page] || 1).to_i
        @page = 1 if @page < 1 || @page > @survey.total_page + 1
        @subjects = @survey.find_subjects_by_page(@page)
        format.html {  render 'reply'}
      else
        flash[:notice] = t(:label_csi_survey_no_form)
        format.html { redirect_to({:action=>"index"})}
      end
    end
  end

  def create_result
    @survey_results = params[:result]
    @survey_id = params[:survey_id]
    @survey= Csi::Survey.find(@survey_id)
    @back_url = params[:back_url]
    @error = Array.new
    @response_batch = params[:survey_member_id]
    if params[:survey_member_id].present?
      Csi::SurveyMember.find(params[:survey_member_id]).update_attribute(:response_flag,Irm::Constant::SYS_YES)
    end
    @response_batch ||= Time.now.to_i.to_s+Irm::Person.current.id.to_s+rand(9).to_s
    @response_time = Time.now
    @thank_message = Csi::Survey.find(@survey_id).thanks_message
    #得到当前调查的ip
    @ip_address =request.remote_ip
    #得到当前的person_id
    @current_person_id = Irm::Person.current.id
    if @thank_message.blank?
      @thank_message = t(:label_csi_default_thanks_message)
    end
    save_flag= true
    if !@survey_results.blank?
       begin
          Csi::SurveyResult.transaction do
            @survey_results.each do |survey_result|
             @subject_id = survey_result[0]
             results = survey_result[1]
               if results.is_a?(Array)                    
                    if results.include?('_other')
                      results.delete('_other')
                      other_result=results.detect {|c| c.is_a?(Hash)}
                          @survey_result=Csi::SurveyResult.new({:subject_id=>@subject_id,
                                                 :subject_result=>other_result['other'],
                                                 :person_id =>@current_person_id,
                                                 :response_batch=>@response_batch,
                                                 :response_time=>@response_time,
                                                 :ip_address=>@ip_address,
                                                 :option_type=>"other"})
                          @survey_result.save!

                    end
                    results.each do |result|
                      if results[0].is_a?(Hash)
                        @error << [@subject_id]
                      else
                        if !result.is_a?(Hash)
                         @survey_result=Csi::SurveyResult.new({:subject_id=>@subject_id,
                                                               :subject_result=>result,
                                                               :person_id =>@current_person_id,
                                                               :response_batch=>@response_batch,
                                                               :response_time=>@response_time,
                                                               :ip_address=>@ip_address,
                                                               :option_type=>"normal"})
                         @survey_result.save!
                        end
                      end                      
                    end
               else
                  @survey_result = Csi::SurveyResult.new({:subject_id=>@subject_id,
                                                          :person_id =>@current_person_id,
                                                          :response_batch=>@response_batch,
                                                          :response_time=>@response_time,
                                                          :ip_address=>@ip_address,
                                                          :subject_result=>results})
                  @survey_result.save!
               end
             end
          end
       rescue ActiveRecord::RecordInvalid => invalid
       # do whatever you wish to warn the user, or log something
         save_flag=false
         if !@survey_result.errors.blank?
           @error << [@subject_id]
         end
       end
    end
    flash[:notice] = @thank_message.to_s

    respond_to do |format|
        if save_flag
          #回答完成后, 看是否有该问卷调查的任务,有的话把任务变为完成状态
          Irm::TodoEvent.complete_task(@survey, Irm::Person.current.id)
          format.html { redirect_to({:action=>"thanks",:survey_id=>@survey_id,:back_url=>@back_url},
                                     :notice => @thank_message) }
          format.xml  { render :xml => @survey, :status => :created, :location => @survey }
          format.js   {
            render :thanks
          }
        else
          if @survey
            @page = (params[:page] || 1).to_i
            @page = 1 if @page < 1 || @page > @survey.total_page + 1
            @subjects = @survey.find_subjects_by_page(@page)
          end
          format.html { render 'reply' }
          format.js
          format.xml  { render :xml => @survey, :status => :created, :location => @survey }
        end
    end
  end


  def show_reply
    @survey = Csi::Survey.find(params[:id])
    @survey_results = Csi::SurveyResult.list_all.where(:response_batch=>params[:survey_member_id])
  end

  def thanks
    @survey = Csi::Survey.find(params[:survey_id])
    @back_url=params[:back_url]
  end

  def show_result
    @survey_id = params[:id]
    survey = Csi::Survey.query(@survey_id).first
    @survey_code = survey.survey_code
    @survey_title = survey.title
    @subjects = Csi::SurveySubject.query_by_survey_id(@survey_id)
    @batch_results = Csi::SurveyResult.query_distinct_response_batch(@survey_id)
  end

  def export_result
    @survey_id = params[:id]
    @subjects = Csi::SurveySubject.query_by_survey_id(@survey_id)
    @batch_results = Csi::SurveyResult.query_distinct_response_batch(@survey_id)

    @export_results = Array.new
    @export_result = Hash.new
    @export_headers= Array.new
    
    survey_timestamps  = t(:label_csi_survey_timestamps)
    survey_person = t(:label_csi_survey_person)
    @export_headers << survey_timestamps
    @export_headers << survey_person    
    @subjects.each do |subject|
      @export_headers << subject.name
    end

    @batch_results.each do |batch_result|
      @export_result = {}
      @export_result = {survey_timestamps=>batch_result.response_time.to_time.to_formatted_s(:datetime_short),
                        survey_person=>Irm::Person.query_person_name(batch_result.person_id).first[:person_name]}
      @subjects.each do |subject|
        @export_result.merge!(subject.name=>get_survey_result(@survey_id,batch_result.response_batch,subject.id))
      end
      @export_results <<@export_result
    end

    respond_to do |format|
      format.html
      format.xls {send_data(@export_results.to_xls(:headers => @export_headers,:use_herders=>true)) }
    end
  end


  def test
    pei_hash = {"Monday"=>2000,"Tuesday"=>1000}
    @data_provider = to_pie_chart_json(pei_hash)
  end


  def get_survey_report
    incident_requests = Icm::IncidentRequest.query_by_urgency(I18n.locale)
    respond_to do |format|
      format.json {render :json=>to_jsonp(incident_requests.to_grid_json([:urgency_name,:urgency_count], 3))}
    end
  end

  def survey_report
    @survey_id = params[:id]
    survey = Csi::Survey.query(@survey_id).first
    @survey_code = survey.survey_code
    @survey_title = survey.title
    @return_url=request.env['HTTP_REFERER']
  end



  def active
    @survey = Csi::Survey.find(params[:id])
    attrs = {}
    if(Irm::Constant::SYS_YES.eql?(params[:active]))
      attrs =  {:status_code=>"ENABLED"}
    else
      attrs =  {:status_code=>"OFFLINE"}
    end

    respond_to do |format|
      if @survey.update_attributes(attrs)
        if @survey.enabled?
          @survey.generate_member
        else
          @survey.clear_member
        end
        format.html { redirect_to({:action=>"show",:id=>@survey.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { redirect_to({:action=>"show",:id=>@survey.id}) }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def get_survey_result(survey_id,response_batch,subject_id)
      @survey_result = Csi::SurveyResult.query_by_survey_id(survey_id,response_batch,subject_id)
      @count = Csi::SurveyResult.query_by_survey_id(survey_id,response_batch,subject_id).count
      @all_survey_result=""
      @survey_result.each do |t|
         if @count.to_i == 1
           @all_survey_result = t[:subject_result]
         else
           @all_survey_result = @all_survey_result + t[:subject_result]+','
         end
      end
      @all_survey_result
    end

    def to_pie_chart_json(chart_data)
      json = %Q([)
      if chart_data.is_a?(Hash)
        chart_data.each do |key,value|
          json << %Q({category:"#{key}",value:#{value}},)
        end
        json.chomp!(",")
      end
      json << "]"
      json
    end

end
