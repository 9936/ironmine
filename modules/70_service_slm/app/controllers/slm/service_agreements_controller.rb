class Slm::ServiceAgreementsController < ApplicationController
  # GET /service_agreements
  # GET /service_agreements.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @service_agreements }
    end
  end

  # GET /service_agreements/1
  # GET /service_agreements/1.xml
  def show
    @service_agreement = Slm::ServiceAgreement.multilingual.status_meaning.find(params[:id])
    @service_agreement.untransform_time
    @start_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}St", @service_agreement.id).first
    @pause_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Pa", @service_agreement.id).first
    @stop_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Sp", @service_agreement.id).first
    @cancel_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Ca", @service_agreement.id).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @service_agreement }
    end
  end

  # GET /service_agreements/new
  # GET /service_agreements/new.xml
  def new
    @service_agreement = Slm::ServiceAgreement.new(:business_object_code => "ICM_INCIDENT_REQUESTS", :external_system_id => params[:sid])
    @start_rule_filter = Irm::RuleFilter.create_for_source(@service_agreement.business_object_code, "#{Slm::ServiceAgreement.name}St", 0)
    @pause_rule_filter = Irm::RuleFilter.create_for_source(@service_agreement.business_object_code, "#{Slm::ServiceAgreement.name}Pa", 0)
    @stop_rule_filter = Irm::RuleFilter.create_for_source(@service_agreement.business_object_code, "#{Slm::ServiceAgreement.name}Sp", 0)
    @cancel_rule_filter = Irm::RuleFilter.create_for_source(@service_agreement.business_object_code, "#{Slm::ServiceAgreement.name}Ca", 0)
    @service_agreement.untransform_time
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @service_agreement }
    end
  end

  # GET /service_agreements/1/edit
  def edit
    @service_agreement = Slm::ServiceAgreement.multilingual.find(params[:id])
    @service_agreement.untransform_time
    @start_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}St", @service_agreement.id).first
    @pause_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Pa", @service_agreement.id).first
    @stop_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Sp", @service_agreement.id).first
    @cancel_rule_filter = Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Ca", @service_agreement.id).first
  end

  # POST /service_agreements
  # POST /service_agreements.xml
  def create
    @service_agreement = Slm::ServiceAgreement.new(params[:slm_service_agreement])
    @start_rule_filter = Irm::RuleFilter.new(params[:start_rule_filter])
    @pause_rule_filter = Irm::RuleFilter.new(params[:pause_rule_filter])
    @stop_rule_filter = Irm::RuleFilter.new(params[:stop_rule_filter])
    @cancel_rule_filter = Irm::RuleFilter.new(params[:cancel_rule_filter])


    respond_to do |format|
      if @service_agreement.valid?&&@start_rule_filter.valid?&&@stop_rule_filter.valid?&&@pause_rule_filter.valid?&&@cancel_rule_filter.valid?
        @service_agreement.save
        @start_rule_filter.source_id = @service_agreement.id
        @stop_rule_filter.source_id = @service_agreement.id
        @pause_rule_filter.source_id = @service_agreement.id
        @cancel_rule_filter.source_id = @service_agreement.id
        @start_rule_filter.save
        @stop_rule_filter.save
        @pause_rule_filter.save
        @cancel_rule_filter.save
        format.html { redirect_to({:action => "show", :id => @service_agreement.id}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @service_agreement, :status => :created, :location => @service_agreement }
      else
        puts [@service_agreement.errors.to_hash, @start_rule_filter.errors.to_hash, @stop_rule_filter.errors.to_hash, @pause_rule_filter.errors.to_hash, @cancel_rule_filter.errors.to_hash]
        format.html { render :action => "new" }
        format.xml { render :xml => @service_agreement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_agreements/1
  # PUT /service_agreements/1.xml
  def update
    @service_agreement = Slm::ServiceAgreement.find(params[:id])
    @start_rule_filter = @service_agreement.start_filter
    @pause_rule_filter = @service_agreement.pause_filter
    @stop_rule_filter = @service_agreement.stop_filter
    @cancel_rule_filter = @service_agreement.cancel_filter
    @start_rule_filter.attributes = params[:start_rule_filter]
    @pause_rule_filter.attributes = params[:pause_rule_filter]
    @stop_rule_filter.attributes = params[:stop_rule_filter]
    @cancel_rule_filter.attributes = params[:cancel_rule_filter]
    @service_agreement.attributes = params[:slm_service_agreement]
    respond_to do |format|
      if @service_agreement.valid?&&@start_rule_filter.valid?&&@stop_rule_filter.valid?&&@pause_rule_filter.valid?&&@cancel_rule_filter.valid?
        @service_agreement.save
        @start_rule_filter.save
        @stop_rule_filter.save
        @pause_rule_filter.save
        @cancel_rule_filter.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @service_agreement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_agreements/1
  # DELETE /service_agreements/1.xml
  def destroy
    @service_agreement = Slm::ServiceAgreement.find(params[:id])
    @service_agreement.destroy

    respond_to do |format|
      format.html { redirect_to(service_agreements_url) }
      format.xml { head :ok }
    end
  end

  def multilingual_edit
    @service_agreement = Slm::ServiceAgreement.find(params[:id])
  end

  def multilingual_update
    @service_agreement = Slm::ServiceAgreement.find(params[:id])
    @service_agreement.not_auto_mult=true
    respond_to do |format|
      if @service_agreement.update_attributes(params[:service_agreement])
        format.html { redirect_to({:action => "index"}, :notice => 'Service agreement was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @service_agreement.errors, :status => :unprocessable_entity }
      end
    end
  end

  def match_filter_edit
    service_agreement = Slm::ServiceAgreement.find(params[:id])
    @rule_filter = Irm::RuleFilter.query_by_source(service_agreement.class.name, service_agreement.id).first
    if @rule_filter.nil?
      @rule_filter = Irm::RuleFilter.create_for_source("ICM_INCIDENT_REQUESTS", service_agreement.class.name, service_agreement.id)
      @rule_filter.save
    end
    respond_to do |format|
      format.html
    end
  end

  def match_filter_update
    service_agreement = Slm::ServiceAgreement.find(params[:id])
    @rule_filter = Irm::RuleFilter.query_by_source(service_agreement.class.name, service_agreement.id).first

    respond_to do |format|
      if @rule_filter.update_attributes(params[:irm_rule_filter])
        format.html { redirect_to({:action => "show"}) }
        format.xml { head :ok }
      else
        format.html { render "match_filter_edit" }
        format.xml { render :xml => @action.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    service_agreements_scope = Slm::ServiceAgreement.multilingual.status_meaning
    service_agreements_scope = service_agreements_scope.match_value("slm_service_agreements_tl.name", params[:name])
    service_agreements_scope = service_agreements_scope.match_value("slm_service_agreements.agreement_code", params[:agreement_code])
    service_agreements, count = paginate(service_agreements_scope)
    service_agreements.each do |service_agreement|
      service_agreement.time_zone = ActiveSupport::TimeZone.new(service_agreement.time_zone).to_s
    end
    respond_to do |format|
      format.json { render :json => to_jsonp(service_agreements.to_grid_json([:agreement_code, :name, :description, :status_meaning], count)) }
      format.html {
        @count = count
        @datas = service_agreements
      }
    end
  end

  def add_response_time_rule
    @service_agreement_id = params[:service_agreement_id]
    @service_agreement = Slm::ServiceAgreement.find(@service_agreement_id)
    @response_escalation_enabled = params[:response_escalation_enabled]
    @rs_first_day = params[:rs_first_day]
    @rs_first_hour = params[:rs_first_hour]
    @rs_first_minute = params[:rs_first_minute]
    @rs_first_escalation_mode = params[:rs_first_escalation_mode]
    @rs_first_assignee_type = params[:rs_first_assignee_type]
    @rs_first_escalation_assignee = params[:rs_first_escalation_assignee]
    if @response_escalation_enabled.to_i == 1
      rs_first_elapse_time = @rs_first_day.to_i * 86400 + @rs_first_hour.to_i * 60 + @rs_first_minute.to_i
      @service_agreement.not_auto_mult=true
      @service_agreement.update_time_flag=Irm::Constant::SYS_YES
      @service_agreement.update_attributes({:response_escalation_enabled => @response_escalation_enabled,
                                            :rs_first_escalation_mode => @rs_first_escalation_mode,
                                            :rs_first_elapse_time => rs_first_elapse_time,
                                            :rs_first_assignee_type => @rs_first_assignee_type,
                                            :rs_first_escalation_assignee => @rs_first_escalation_assignee})
    end
    respond_to do |format|
      format.js
    end
  end

  def add_solve_time_rule
    @service_agreement_id = params[:service_agreement_id]
    @service_agreement = Slm::ServiceAgreement.find(@service_agreement_id)
    @attr = Hash.new
    #======================first============================#
    @response_escalation_enabled = params[:response_escalation_enabled]
    @rs_first_day = params[:rs_first_day]
    @rs_first_hour = params[:rs_first_hour]
    @rs_first_minute = params[:rs_first_minute]
    @rs_first_escalation_mode = params[:rs_first_escalation_mode]
    @rs_first_assignee_type = params[:rs_first_assignee_type]
    @rs_first_escalation_assignee = params[:rs_first_escalation_assignee]
    if @response_escalation_enabled.to_i == 1
      rs_first_elapse_time = @rs_first_day.to_i * 86400 + @rs_first_hour.to_i * 60 + @rs_first_minute.to_i
      @attr.merge!({:response_escalation_enabled => @response_escalation_enabled,
                    :rs_first_escalation_mode => @rs_first_escalation_mode,
                    :rs_first_elapse_time => rs_first_elapse_time,
                    :rs_first_assignee_type => @rs_first_assignee_type,
                    :rs_first_escalation_assignee => @rs_first_escalation_assignee})
    end
    #======================first============================#
    @first_escalation_enabled = params[:first_escalation_enabled]
    @solve_first_day = params[:solve_first_day]
    @solve_first_hour = params[:solve_first_hour]
    @solve_first_minute = params[:solve_first_minute]
    @first_escalation_mode = params[:first_escalation_mode]
    @first_assignee_type = params[:first_assignee_type]
    @first_escalation_assignee = params[:first_escalation_assignee]
    if @first_escalation_enabled.to_i == 1
      solve_first_elapse_time = @solve_first_day.to_i * 86400 + @solve_first_hour.to_i * 60 + @solve_first_minute.to_i
      @attr.merge!({:first_escalation_enabled => @first_escalation_enabled,
                    :first_escalation_mode => @first_escalation_mode,
                    :first_elapse_time => solve_first_elapse_time,
                    :first_assignee_type => @first_assignee_type,
                    :first_escalation_assignee => @first_escalation_assignee})
    end
    #======================second============================#
    @second_escalation_enabled = params[:second_escalation_enabled]
    @solve_second_day = params[:solve_second_day]
    @solve_second_hour = params[:solve_second_hour]
    @solve_second_minute = params[:solve_second_minute]
    @second_escalation_mode = params[:second_escalation_mode]
    @second_assignee_type = params[:second_assignee_type]
    @second_escalation_assignee = params[:second_escalation_assignee]
    if @second_escalation_enabled.to_i == 1
      solve_second_elapse_time = @solve_second_day.to_i * 86400 + @solve_second_hour.to_i * 60 + @solve_second_minute.to_i
      @attr.merge!({:second_escalation_enabled => @second_escalation_enabled,
                    :second_escalation_mode => @second_escalation_mode,
                    :second_elapse_time => solve_second_elapse_time,
                    :second_assignee_type => @second_assignee_type,
                    :second_escalation_assignee => @second_escalation_assignee})
    end
    #======================third============================#
    @third_escalation_enabled = params[:third_escalation_enabled]
    @solve_third_day = params[:solve_third_day]
    @solve_third_hour = params[:solve_third_hour]
    @solve_third_minute = params[:solve_third_minute]
    @third_escalation_mode = params[:third_escalation_mode]
    @third_assignee_type = params[:third_assignee_type]
    @third_escalation_assignee = params[:third_escalation_assignee]
    if @third_escalation_enabled.to_i == 1
      solve_third_elapse_time = @solve_third_day.to_i * 86400 + @solve_third_hour.to_i * 60 + @solve_third_minute.to_i
      @attr.merge!({:third_escalation_enabled => @third_escalation_enabled,
                    :third_escalation_mode => @third_escalation_mode,
                    :third_elapse_time => solve_third_elapse_time,
                    :third_assignee_type => @third_assignee_type,
                    :third_escalation_assignee => @third_escalation_assignee})
    end
    #======================fourth============================#
    @fourth_escalation_enabled = params[:fourth_escalation_enabled]
    @solve_fourth_day = params[:solve_fourth_day]
    @solve_fourth_hour = params[:solve_fourth_hour]
    @solve_fourth_minute = params[:solve_fourth_minute]
    @fourth_escalation_mode = params[:fourth_escalation_mode]
    @fourth_assignee_type = params[:fourth_assignee_type]
    @fourth_escalation_assignee = params[:fourth_escalation_assignee]
    if @fourth_escalation_enabled.to_i == 1
      solve_fourth_elapse_time = @solve_fourth_day.to_i * 86400 + @solve_fourth_hour.to_i * 60 + @solve_fourth_minute.to_i
      @attr.merge!({:fourth_escalation_enabled => @fourth_escalation_enabled,
                    :fourth_escalation_mode => @fourth_escalation_mode,
                    :fourth_elapse_time => solve_fourth_elapse_time,
                    :fourth_assignee_type => @fourth_assignee_type,
                    :fourth_escalation_assignee => @fourth_escalation_assignee})
    end
    @service_agreement.not_auto_mult=true
    @service_agreement.update_time_flag=Irm::Constant::SYS_YES
    @service_agreement.update_attributes(@attr)
    respond_to do |format|
      format.js
    end
  end

  def get_by_assignee_type
    @assignee_type = params[:assignee_type]
    result = ""
    if @assignee_type == 'USER'
      user_scope = Irm::Person.query_all_person
      user = user_scope.collect { |i| {:label => i[:person_name], :value => i.id, :id => i.id} }
      result = user
    else
      role_scope = Irm::Role.multilingual.enabled
      role = role_scope.collect { |i| {:label => i[:name], :value => i.id, :id => i.id} }
      result = role
    end
    respond_to do |format|
      format.json { render :json => result.to_grid_json([:label, :value], result.count) }
    end
  end


  def add_exists_action

  end

  def save_exists_action
    action_types = [[Irm::WfFieldUpdate, Irm::BusinessObject.class_name_to_code(Irm::WfFieldUpdate.name)], [Irm::WfMailAlert, Irm::BusinessObject.class_name_to_code(Irm::WfMailAlert.name)]]
    selected_actions = params[:selected_actions].split(",")
    exists_actions = Slm::TimeTriggerAction.where(:time_trigger_id => params[:trigger_id])
    exists_actions.each do |action|
      action_type = action_types.detect { |i| i[0].name.eql?(action.action_type) }
      if selected_actions.include?("#{action_type[1]}##{action.action_id}")
        selected_actions.delete("#{action_type[1]}##{action.action_id}")
      else
        action.destroy
      end
    end

    selected_actions.each do |action_str|
      next unless action_str.strip.present?
      action = action_str.split("#")
      action_type = action_types.detect { |i| i[1].eql?(action[0]) }
      Slm::TimeTriggerAction.create(
          :time_trigger_id => params[:trigger_id],
          :action_type => action_type[0].name,
          :action_id => action[1])
    end if selected_actions.any?

    respond_to do |format|
      format.html { redirect_back_or_default({:action => "show", :id => params[:id]}) }
      format.xml { head :ok }
    end
  end

  def destroy_action
    @time_trigger_action = Slm::TimeTriggerAction.find(params[:id]);
    @time_trigger_action.destroy

    respond_to do |format|
      format.html { redirect_back_or_default({:action => "show", :id => params[:id]})
      }
      format.xml { head :ok }
    end
  end


  def show_relations
    sla_instances = Slm::SlaInstance.with_detail(I18n.locale).where(:bo_type=>params[:bo_type],:bo_id=>params[:bo_id])
    sla_instances.each do |slai|
      if "START".eql?(slai.last_phase_type)
        calendar = slai.service_agreement.calendar
        slai.current_duration = slai.current_duration.to_i+calendar.working_time(slai.last_phase_start_date,Time.now)
        if  slai.current_duration < slai.max_duration
          slai.end_at = calendar.next_working_time(Time.now,slai.max_duration-slai.current_duration)
          slai.display_color = "green"
        else
          slai.display_color = "red"
        end
      end
    end

    respond_to do |format|
      format.json {
        render :json => to_jsonp(service_agreements.to_grid_json([:agreement_code, :name, :description, :status_meaning], count))
      }
      format.html {
        @count = sla_instances.length
        @datas = sla_instances
      }
    end
  end

end
