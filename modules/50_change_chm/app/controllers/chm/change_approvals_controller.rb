class Chm::ChangeApprovalsController < ApplicationController

  # GET /change_approvals/new
  # GET /change_approvals/new.xml
  def new
    @change_request = Chm::ChangeRequest.find(params[:change_request_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_approval }
    end
  end


  # POST /change_approvals
  # POST /change_approvals.xml
  def create
    @change_request = Chm::ChangeRequest.find(params[:change_request_id])
    person_ids = params[:person_ids]
    person_ids.split(",").each do |person_id|
      change_approval = Chm::ChangeApproval.new(:person_id=>person_id,:change_request_id=>@change_request.id,:approve_status=>"ASSIGNED")
      change_approval.save if change_approval.valid?
    end

    params[:advisory_board_member_ids] = ""
    @change_request.update_attribute(:approve_status,"ASSIGNED")

    respond_to do |format|
        format.html { redirect_back_or_default(:controller=>"chm/change_requests",:action => "show_approve",:id=>@change_request.id) }
        format.xml  { render :xml => @change_request }
    end
  end


  # DELETE /change_approvals/1
  # DELETE /change_approvals/1.xml
  def destroy
    @change_approval = Chm::ChangeApproval.find(params[:id])
    @change_approval.destroy
    unless Chm::ChangeApproval.where(:change_request_id=>@change_approval.change_request_id).any?
      Chm::ChangeRequest.find(@change_approval.change_request_id).update_attribute(:approve_status,"")
    end

    respond_to do |format|
      format.html { redirect_back_or_default(:controller=>"chm/change_requests",:action => "show_approve",:id=>@change_approval.change_request_id) }
      format.xml  { head :ok }
    end
  end

  def get_available_member
    advisory_board_members_scope = Chm::AdvisoryBoardMember.list_all.available_for_request(params[:change_request_id]).where("advisory_board_id = ?",params[:advisory_board_id])
    advisory_board_members_scope = advisory_board_members_scope.match_value("people.full_name",params[:full_name])
    advisory_board_members,count = paginate(advisory_board_members_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(advisory_board_members.to_grid_json([:full_name,:email_address,:organization_name,:person_id],count))}
    end
  end


  def submit
    @change_request = Chm::ChangeRequest.find(params[:change_request_id])
    Chm::ChangeApproval.where(:change_request_id=>@change_request.id).update_all(:approve_status=>"APPROVING",:send_at=>Time.now)
    Chm::ChangeApproval.list_all.where(:change_request_id=>@change_request.id).each do |change_approval|
    # TODO send approve mail

    end

    @change_request.update_attribute(:approve_status,"APPROVING")


    respond_to do |format|
        format.html { redirect_back_or_default(:controller=>"chm/change_requests",:action => "show_approve",:id=>@change_request.id) }
        format.xml  { render :xml => @change_request }
    end
  end


  def approve
    @change_approval = Chm::ChangeApproval.find(params[:id])
    @change_request = Chm::ChangeRequest.list_all.find(@change_approval.change_request_id)
    respond_to do |format|
      format.html { render :layout => "application_full"} # index.html.erb
      format.xml  { head :ok }
    end
  end


  def decide
    @change_approval = Chm::ChangeApproval.find(params[:id])
    @change_approval.attributes = params[:chm_change_approval]
    if Irm::Constant::SYS_YES.eql?(params[:reject])
      @change_approval.reject
    else
      @change_approval.approve
    end

    respond_to do |format|
      format.html { redirect_back_or_default(:controller=>"chm/change_requests",:action => "show_approve",:id=>@change_approval.change_request_id) }
      format.xml  { head :ok }
    end
  end


end
