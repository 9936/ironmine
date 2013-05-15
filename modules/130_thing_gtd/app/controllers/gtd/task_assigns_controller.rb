class Gtd::TaskAssignsController < ApplicationController
  # GET /gtd/task_assigns
  # GET /gtd/task_assigns.xml
  def index
    @task_assigns = Gtd::TaskAssign.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @task_assigns }
    end
  end

  # GET /gtd/task_assigns/1
  # GET /gtd/task_assigns/1.xml
  def show
    @task_assign = Gtd::TaskAssign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task_assign }
    end
  end

  # GET /gtd/task_assigns/new
  # GET /gtd/task_assigns/new.xml
  def new
    @task_assign = Gtd::TaskAssign.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task_assign }
    end
  end

  # GET /gtd/task_assigns/1/edit
  def edit
    @task_assign = Gtd::TaskAssign.find(params[:id])
  end

  # POST /gtd/task_assigns
  # POST /gtd/task_assigns.xml
  def create
    @task_assign = Gtd::TaskAssign.new(params[:gtd_task_assign])

    respond_to do |format|
      if @task_assign.save
        format.html { redirect_to({:action => "show",:id=>@task_assign.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @task_assign, :status => :created, :location => @task_assign }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task_assign.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gtd/task_assigns/1
  # PUT /gtd/task_assigns/1.xml
  def update
    @task_assign = Gtd::TaskAssign.find(params[:id])

    respond_to do |format|
      if @task_assign.update_attributes(params[:gtd_task_assign])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task_assign.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gtd/task_assigns/1
  # DELETE /gtd/task_assigns/1.xml
  def destroy
    @task_assign = Gtd::TaskAssign.find(params[:id])
    @task_assign.destroy

    respond_to do |format|
      format.html { redirect_to(gtd_task_assigns_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    gtd_task_assigns_scope = Gtd::TaskAssign.where(:external_system_id=>params[:sid])
    gtd_task_assigns_scope = gtd_task_assigns_scope.match_value("#{Gtd::TaskAssign.table_name}.name",params[:name])
    gtd_task_assigns,count = paginate(gtd_task_assigns_scope)
    respond_to do |format|
      format.html  {
        @datas = gtd_task_assigns
        @count = count
      }
      format.json {render :json=>to_jsonp(gtd_task_assigns.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end


  def add_member
    @type = params[:type]
    @task_assign  = Gtd::TaskAssign.find(params[:id])
    Gtd::TaskAssignMember.create(:task_assign_id=>@task_assign.id,:person_id=>params[:person_id],:member_type=>@type.upcase)
    respond_to do |format|
      format.js
    end
  end

  def get_from_people_data
    member_scope = Irm::Person.select_all.with_organization(I18n.locale).
        with_system_profile(I18n.locale, params[:sid]).
        query_task_assign(params[:id],"FROM")
    member_scope = member_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    members, count = paginate(member_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(members.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = members
        @count = count
      }
    end
  end

  def get_to_people_data
    member_scope = Irm::Person.select_all.with_organization(I18n.locale).
        with_system_profile(I18n.locale, params[:sid]).
                query_task_assign(params[:id],"TO")
    member_scope = member_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    members, count = paginate(member_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(members.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = members
        @count = count
      }
    end
  end


  def delete_member
    person_ids = params[:gtd_task_assign]["temp_#{params[:type]}_id_string".to_sym].split(",")
    person_ids.each do |person_id|
      Gtd::TaskAssignMember.where(:person_id=>person_id,:task_assign_id=>params[:id]).delete_all
    end
    respond_to do |format|
        format.html { redirect_to({:action => "show"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
    end
  end
end
