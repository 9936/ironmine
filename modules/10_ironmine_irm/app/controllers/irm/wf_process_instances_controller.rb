class Irm::WfProcessInstancesController < ApplicationController
  layout "bootstrap_application"
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
    @wf_process_instance = Irm::WfProcessInstance.select_all.with_submitter.find(params[:id])
  end

  def execute_recall
    Irm::WfProcessInstance.transaction do
      @wf_process_instance = Irm::WfProcessInstance.find(params[:id])
      @wf_process_instance.update_attributes(params[:irm_wf_process_instance])
      @wf_process_instance.recall(Irm::Person.current.id)
    end
    redirect_back_or_default
  end

end
