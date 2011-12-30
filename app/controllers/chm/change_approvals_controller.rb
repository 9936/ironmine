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

    respond_to do |format|
        format.html { redirect_back_or_default(:controller=>"chm/change_requests",:action => "show_approve",:id=>@change_request.id) }
        format.xml  { render :xml => @change_request }
    end
  end


  # DELETE /change_approvals/1
  # DELETE /change_approvals/1.xml
  def destroy
    @change_approval = ChangeApproval.find(params[:id])
    @change_approval.destroy

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


end
