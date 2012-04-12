class Chm::AdvisoryBoardMembersController < ApplicationController

  # GET /advisory_board_members/new
  # GET /advisory_board_members/new.xml
  def new
    @advisory_board = Chm::AdvisoryBoard.find(params[:advisory_board_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advisory_board_member }
    end
  end

  # POST /advisory_board_members
  # POST /advisory_board_members.xml
  def create
    @advisory_board = Chm::AdvisoryBoard.find(params[:advisory_board_id])
    person_ids = params[:person_ids]
    person_ids.split(",").each do |person_id|
      Chm::AdvisoryBoardMember.create(:advisory_board_id=>@advisory_board.id,:person_id=>person_id)
    end

    params[:person_ids] = ""
    respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @advisory_board }
    end

  end

  # DELETE /advisory_board_members/1
  # DELETE /advisory_board_members/1.xml
  def destroy
    @advisory_board_member = Chm::AdvisoryBoardMember.find(params[:id])
    @advisory_board_member.destroy

    respond_to do |format|
      format.html { redirect_to({:controller => "chm/advisory_boards",:id=>@advisory_board_member.advisory_board_id,:action=>"show"}) }
      format.xml  { head :ok }
    end
  end


  def get_data
    ava_people_scope = Irm::Person.select_all.
                      with_organization(I18n.locale).where("NOT EXISTS(SELECT 1 FROM #{Chm::AdvisoryBoardMember.table_name} WHERE #{Chm::AdvisoryBoardMember.table_name}.person_id = #{Irm::Person.table_name}.id AND #{Chm::AdvisoryBoardMember.table_name}.advisory_board_id = ?)",params[:advisory_board_id])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    people, count = paginate(ava_people_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(people.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = people
        @count = count
        render_html_data_table
      }
    end
  end
end
