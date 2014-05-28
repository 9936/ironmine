class Ndm::ProjectsController < ApplicationController
  def index

  end


  def show
    @project = Ndm::Project.find(params[:id])
    @project_person = Ndm::ProjectPerson.new
    @project_person.status_code=""

    respond_to do |format|
      format.html  
    end
  end

  def new
    @project = Ndm::Project.new

    respond_to do |format|
      format.html  
    end
  end

  def edit
    @project = Ndm::Project.find(params[:id])
    respond_to do |format|
      format.html  
    end
  end

  def create
    @project = Ndm::Project.new(params[:ndm_project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @project = Ndm::Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:ndm_project])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @project = Ndm::Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(dem_project_url) }
      format.xml { head :ok }
    end
  end


  def get_data
    project_scope = Ndm::Project.select_all.order("created_at DESC")
    projects, count = paginate(project_scope)
    respond_to do |format|
      format.html {
        @datas = projects
        @count = count
      }
      format.json { render :json => to_jsonp(projects.to_grid_json([:name, :description, :status], count)) }
    end
  end

  def add_people
    @project_person = Ndm::ProjectPerson.new(params[:ndm_project_person])
    vi = @project_person.vi
    ed = @project_person.ed
    ad = @project_person.ad
    re = @project_person.re
    im = @project_person.im

    respond_to do |format|
      if(!@project_person.status_code.blank?)
        @project_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Ndm::ProjectPerson.create(:project_id => params[:project_id],
                                     :person_id => id,
                                     :vi => vi, :ed => ed, :ad => ad, :re => re, :im => im)
        end
      end
      format.html { redirect_to({:action=>"show", :id => params[:project_id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @project_person.errors, :status => :unprocessable_entity }
    end
  end

  def get_member_data

  end

  def get_available_people_data
    ava_people_scope = Irm::Person.
        with_organization(I18n.locale).
        where("NOT EXISTS(SELECT 1 FROM ndm_project_people npp WHERE npp.project_id = ? AND npp.person_id = #{Irm::Person.table_name}.id)", params[:project_id]).
        select("#{Irm::Person.table_name}.id id, #{Irm::Person.table_name}.full_name person_name, #{Irm::Person.table_name}.email_address email_address")

    ava_people_scope = ava_people_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    people, count = paginate(ava_people_scope)
    respond_to do |format|
      format.html {
        @datas = people
        @count = count
      }
    end
  end

  def delete_people
    @project_person = Ndm::ProjectPerson.new(params[:ndm_project_person])

    respond_to do |format|
      if(!@project_person.temp_id_string.blank?)
        @project_person.temp_id_string.split(",").delete_if{|i| i.blank?}.each do |id|
          esp = Ndm::ProjectPerson.where(:project_id => params[:id],:person_id => id).first
          esp.destroy
        end
      end
      format.html { redirect_to({:action=>"show", :id => params[:id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @project_person.errors, :status => :unprocessable_entity }
    end
  end

  def get_owned_members_data
    member_scope = Ndm::Project.
        joins(",#{Ndm::ProjectPerson.table_name} pp").
        joins(",#{Irm::Person.table_name} ip").
        where("pp.person_id = ip.id").
        where("pp.project_id = #{Ndm::Project.table_name}.id").
        where("pp.project_id = ?", params[:project_id]).
        select("pp.vi vi, pp.ed ed, pp.re re,  pp.ad ad, pp.im im").
        select("pp.id ppid").
        select("ip.id id,ip.full_name person_name, ip.email_address email_address")

    members, count = paginate(member_scope)
    respond_to do |format|
      format.html {
        @datas = members
        @count = count
      }
    end
  end

  def update_project_people
    project_person = Ndm::ProjectPerson.find(params[:id])
    project_person.vi = params[:vi] ? 'Y' : 'N'
    project_person.ed = params[:ed] ? 'Y' : 'N'
    project_person.ad = params[:ad] ? 'Y' : 'N'
    project_person.re = params[:re] ? 'Y' : 'N'
    project_person.im = params[:im] ? 'Y' : 'N'
    project_person.save

    redirect_to params[:redirect_to] if params[:redirect_to]
  end
end
