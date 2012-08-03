class Irm::WfStepInstancesController < ApplicationController
  # GET /wf_step_instances
  # GET /wf_step_instances.xml
  def index
    @wf_step_instances = Irm::WfStepInstance.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wf_step_instances }
    end
  end

  # GET /wf_step_instances/1
  # GET /wf_step_instances/1.xml
  def show
    @wf_step_instance = Irm::WfStepInstance.find(params[:id])
    @wf_process_instance = Irm::WfProcessInstance.find(@wf_step_instance.process_instance_id)
    @bo_instance = @wf_process_instance.bo_instance
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wf_step_instance }
    end
  end


  def submit
    @wf_step_instance = Irm::WfStepInstance.find(params[:id])
    @wf_step_instance.attributes = params[:irm_wf_step_instance] if params[:irm_wf_step_instance]
    @wf_process_instance = Irm::WfProcessInstance.find(@wf_step_instance.process_instance_id)
    @bo_instance = @wf_process_instance.bo_instance
    begin
      Irm::WfStepInstance.transaction do
        if @wf_step_instance.next_approver_id
          @wf_process_instance.next_approver_id = @wf_step_instance.next_approver_id
          @wf_process_instance.save
        end
        @wf_step_instance.save
        if params[:reject]
          @wf_step_instance.reject(Irm::Person.current.id)
        else
          @wf_step_instance.approved(Irm::Person.current.id)
        end
        # remove next approver id
        if @wf_process_instance.next_approver_id
           @wf_process_instance.update_attribute(:next_approver_id,nil)
        end
      end
      rescue Wf::MissingSelectApproverError => error
        @next_step =  Irm::WfApprovalStep.list_all.find(error.message.to_i)
        render "select_approver"
        return
      rescue Wf::MissingDefaultApproverError => error
        @next_step =  Irm::WfApprovalStep.list_all.find(error.message.to_i)
        @wf_step_instance.errors.add(:next_approver_id,t(:label_irm_wf_approval_process_can_not_find_next_approver))
      rescue Wf::MissingAutoApproverError => error
        @next_step =  Irm::WfApprovalStep.list_all.find(error.message.to_i)
        @wf_step_instance.errors.add(:next_approver_id,t(:label_irm_wf_approval_process_can_not_find_next_approver))
      rescue Wf::ApproveError => error
        text = error
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



  def reassign
    @wf_step_instance = Irm::WfStepInstance.list_all.find(params[:id])
    @wf_process_instance = Irm::WfProcessInstance.find(@wf_step_instance.process_instance_id)
    @bo_instance = @wf_process_instance.bo_instance
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wf_step_instance }
    end
  end

  def save_reassign
    @wf_step_instance = Irm::WfStepInstance.list_all.find(params[:id])
    @wf_step_instance.attributes = params[:irm_wf_step_instance] if params[:irm_wf_step_instance]
    @wf_process_instance = Irm::WfProcessInstance.find(@wf_step_instance.process_instance_id)
    @bo_instance = @wf_process_instance.bo_instance
    if !@wf_step_instance.next_approver_id.present?
      @wf_step_instance.errors.add(:next_approver_id,I18n.t("activemodel.errors.messages.blank"))
    end

    respond_to do |format|
      if @wf_process_instance.errors.any?
        format.html { render "reassign" }
        format.xml  { render :xml => @wf_process_instance.errors, :status => :unprocessable_entity }
      else
        Irm::WfStepInstance.transaction do
          @wf_step_instance.reassign(Irm::Person.current.id)
        end
        format.html { redirect_back_or_default }
        format.xml  { render :xml => @wf_process_instance, :status => :created, :location => @wf_process_instance }
      end
    end
  end
end
