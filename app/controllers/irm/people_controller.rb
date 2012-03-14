class Irm::PeopleController < ApplicationController
  layout "uid"
  # GET /people
  # GET /people.xml
  def index
    @people = Irm::Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  def show
    @person = Irm::Person.list_all.find(params[:id])
    @support_group_count = Irm::GroupMember.where(:person_id=>@person.id).size
    respond_to do |format|
      format.json {render :json=>@person}
      format.html
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Irm::Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Irm::Person.list_all.find(params[:id])
    @step = params[:next_action] if params[:next_action]
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Irm::Person.new(params[:irm_person])
    puts params[:irm_person].inspect
    if @person.template_flag.eql?(Irm::Constant::SYS_YES)
      @person = Irm::TemplatePerson.new(params[:irm_person])
    end

    respond_to do |format|
      if @person.save
        if params[:next_action]
          if params[:next_action].eql?("add_system")
            format.html { redirect_to({:controller => "irm/external_system_members",:action => "new_from_person",:person_id=>@person.id, :next_action => params[:next_action]})}
          elsif params[:next_action].eql?("add_group")
            format.html { redirect_to({:controller => "irm/group_members",:action => "new_from_person",:id=>@person.id, :next_action => params[:next_action]})}
          end
        else
          format.html { redirect_to({:action=>"show"},:notice => (t :successfully_created))}
          format.xml  { render :xml => @person, :status => :created, :location => @person }
          format.json { render :json=>@person}
        end

      else
        format.html { render "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
        format.json  { render :json => @person.errors}
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Irm::Person.list_all.find(params[:id])
    #禁止更新用户名
    params[:irm_person].delete(:login_name)

    @attributes = params[:irm_person]
    respond_to do |format|
      if @person.update_attributes(params[:irm_person])
        if params[:next_action]
          if params[:next_action].eql?("add_system")
            format.html { redirect_to({:controller => "irm/external_system_members",:action => "new_from_person",:person_id=>@person.id,:next_action => params[:next_action]})}
          elsif params[:next_action].eql?("add_group")
            format.html { redirect_to({:controller => "irm/group_members",:action => "new_from_person",:id=>@person.id, :next_action => params[:next_action]})}
          end
        else
          if params[:return_url]
            format.html {redirect_to(params[:return_url])}
            format.xml { head :ok}
          else
            format.html { redirect_to({:action=>"edit"},:notice => (t :successfully_updated)) }
            format.xml  { head :ok }
          end
          format.json { render :json=>@person}
        end
      else
        @error = @person
        format.html { render "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
        format.json  { render :json => @person.errors}
      end
    end
  end

  def get_data
    @people= Irm::Person.not_anonymous.list_all.order(:id)
    @people = @people.match_value("#{Irm::Person.table_name}.login_name",params[:login_name])
    @people = @people.match_value("#{Irm::Person.name_to_sql(nil,Irm::Person.table_name,"")}",params[:person_name])
    @people = @people.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    @people = @people.match_value("#{Irm::Person.table_name}.bussiness_phone",params[:bussiness_phone])
    @people = @people.match_value("#{Irm::Organization.view_name}.name",params[:organization_name])
    @people = @people.match_value("pv.profile_name",params[:profile_name])


    @people,count = paginate(@people)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@people.to_grid_json([:login_name,:person_name,:profile_name,:email_address,:bussiness_phone,:organization_name], count))}
    end
  end

  def login_access
    person_id = params[:person_id]
    @person = Irm::Person.find(person_id)
  end

  def get_choose_people
    @choose_people= Irm::Person.query_choose_person.query_by_support_staff_flag("Y")
    respond_to do |format|
      format.json {render :json=>@choose_people.to_dhtmlxgrid_json(['R',:person_name,:email_address,:mobile_phone], @choose_people.size)}
    end
  end

  def get_support_group
    person_id = params[:person_id]
    @support_groups= Irm::GroupMember.query_support_group_by_person_id(I18n::locale,person_id)
    @support_groups,count = paginate(@support_groups)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@support_groups.to_grid_json(['R',:support_group_name,:description,:status_meaning], count))}
    end
  end


  def get_owned_roles
    roles_scope = Irm::Role.multilingual.belongs_to_person(params[:person_id])
    roles,count = paginate(roles_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(roles.to_grid_json([:name,:role_code,:status_code,  :description], count)) }
    end    
  end

  def get_available_roles
    roles_scope = Irm::Role.multilingual.enabled.query_by_role_name(params[:role_name]).without_person(params[:id])
    roles,count = paginate(roles_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(roles.to_grid_json([:name,:role_code,:status_code, :description], count)) }
    end   
  end

  def remove_role
    return_url=params[:return_url]
    person_role = Irm::PersonRole.where(:person_id => params[:person_id], :role_id => params[:role_id]).first
    person_role.destroy
    if return_url.blank?
      redirect_to({:action=>"show", :id=> params[:person_id]})
    else
      redirect_to(return_url)
    end        
  end

  def select_roles
    @person_role = Irm::PersonRole.new
    @person_role.status_code=""
  end

  def add_roles
    @person_role = Irm::PersonRole.new(params[:irm_person_role])
    added_person = Irm::Person.find(params[:id])
    respond_to do |format|
      if(!@person_role.status_code.blank?)
        @person_role.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Irm::PersonRole.create(:person_id=>params[:id],:role_id=>id)
        end
        format.html { redirect_to({:action=>"show"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @person_role, :status => :created, :location => @report_group_member }
      else
        @person_role.errors.add(:status_code,"")
        format.html { render :action => "select_roles" }
        format.xml  { render :xml => @person_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_owned_external_systems
    @person = Irm::Person.find(params[:person_id])
    systems_scope = @person.external_systems
    systems, count = paginate(systems_scope)
    respond_to do |format|
      format.html  {
        @datas = systems
        @count = count
        render_html_data_table
      }
      format.json {render :json => to_jsonp(systems.to_grid_json([:system_name, :system_description, :external_system_code, :status_code], count))}
    end
  end


  def reset_password
    @person = Irm::Person.find(params[:id])
    @person.reset_password
    respond_to do |format|
        format.html { redirect_to({:action=>"show"}) }
    end
  end

  def info_card
    @person = Irm::Person.list_all.find(params[:id])
    render :layout => "common_all"
  end
end
