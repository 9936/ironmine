class Irm::WfProcessInstancesController < ApplicationController
  # GET /wf_process_instances
  # GET /wf_process_instances.xml
  def index
    @wf_process_instances = Irm::WfProcessInstance.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wf_process_instances }
    end
  end


  # submit a process instance
  # POST /wf_process_instances
  # POST /wf_process_instances.xml
  def submit
    @wf_process_instance = Irm::WfProcessInstance.new(:bo_id=>params[:bo_id],:bo_model_name=>params[:bo_model_name],:next_approver_id=>params[:next_approver_id],:submitter_id=>Irm::Person.current.id)
    process = @wf_process_instance.detect_process
    if process
      @wf_process_instance.process_id = process.id
      #next_step = @wf_process_instance.next_step(1)
      #if "SELECT_BY_SUMBITTER".eql?(next_step.approver_mode)
      #  redirect_to({:action=>"edit_approver",:bo_id=>params[:bo_id],:process_id=>process.id,:step_id=>next_step.id}.merge(get_default_url_options([:back_url])))
      #  return
      #elsif "PROCESS_DEFAULT".eql?(next_step.approver_mode)
      #  if !next_step.process_default_approver_ids(Irm::Person.current.id).present?
      #    @wf_process_instance.errors.add(:submitter_id,t(:label_irm_wf_approval_process_can_not_find_next_approver))
      #  end
      #elsif "AUTO_APPROVER".eql?(next_step.approver_mode)
      #  if next_step.auto_approver_ids.length<1
      #    @wf_process_instance.errors.add(:submitter_id,t(:label_irm_wf_approval_process_can_not_find_next_approver))
      #  end
      #end
      begin
        Irm::WfProcessInstance.transaction do
          @wf_process_instance.submit
        end
      rescue Wf::MissingSelectApproverError => error
        @next_step =  Irm::WfApprovalStep.list_all.find(error.message.to_i)
        render "select_approver"
        return
      rescue Wf::MissingDefaultApproverError => error
        @next_step =  Irm::WfApprovalStep.list_all.find(error.message.to_i)
        @wf_process_instance.errors.add(:next_approver_id,t(:label_irm_wf_approval_process_can_not_find_next_approver))
      rescue Wf::MissingAutoApproverError => error
        @next_step =  Irm::WfApprovalStep.list_all.find(error.message.to_i)
        @wf_process_instance.errors.add(:next_approver_id,t(:label_irm_wf_approval_process_can_not_find_next_approver))
      end
    else
      @wf_process_instance.errors.add(:process_id,t(:label_irm_wf_approval_process_can_not_find_match_process))
    end

    respond_to do |format|
      if @wf_process_instance.errors.any?
        format.html { render "submit_error" }
        format.xml  { render :xml => @wf_process_instance.errors, :status => :unprocessable_entity }
      else
        format.html { redirect_back_or_default }
        format.xml  { render :xml => @wf_process_instance, :status => :created, :location => @wf_process_instance }
      end
    end
  end


  def recall
    Irm::WfProcessInstance.transaction do
      Irm::WfProcessInstance.find(params[:id]).recall(Irm::Person.current.id)
    end
    redirect_back_or_default
  end

end
