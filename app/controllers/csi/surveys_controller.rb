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
    @survey =Csi:: Survey.new

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
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_created)) }
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
    @surveys= Csi::Survey.query_wrap_info(I18n::locale)
    @surveys = @surveys.match_value("#{Csi::Survey.table_name}.title",params[:title])
    @surveys,count = paginate(@surveys)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@surveys.to_grid_json(['R',:title,:description,:status_meaning], count))}
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
    @return_url=request.env['HTTP_REFERER']
    
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
    @return_url = params[:return_url]
    @error = Array.new
    @response_batch = Time.now.to_i.to_s+Irm::Person.current.id.to_s+rand(9).to_s
    @response_time = Time.now
    @thank_message = Csi::Survey.find(@survey_id).thanks_message
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
                                                 :person_id =>Irm::Person.current,
                                                 :response_batch=>@response_batch,
                                                 :response_time=>@response_time,
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
                                                               :person_id =>Irm::Person.current,
                                                               :response_batch=>@response_batch,
                                                               :response_time=>@response_time,
                                                               :option_type=>"normal"})
                         @survey_result.save!
                        end
                      end                      
                    end
               else
                  @survey_result = Csi::SurveyResult.new({:subject_id=>@subject_id,
                                                          :person_id =>Irm::Person.current,
                                                          :response_batch=>@response_batch,
                                                          :response_time=>@response_time,
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
          format.html { redirect_to({:action=>"thanks",:survey_id=>@survey_id,:return_url=>@return_url}, :notice => @thank_message) }
          format.xml  { render :xml => @survey, :status => :created, :location => @survey }
          format.js   {
            render 'thanks'
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

  def thanks
    @survey = Csi::Survey.find(params[:survey_id])
    @return_url=params[:return_url]
  end

  def show_result
    @survey_id = params[:id]
    @subjects = Csi::SurveySubject.query_by_survey_id(@survey_id)
    @batch_results = Csi::SurveyResult.query_distinct_response_batch(@survey_id)
  end
end
