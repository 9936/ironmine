class Mam::SystemsController < ApplicationController
   def index
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /incident_requests/1
  # GET /incident_requests/1.xml
  def show
    @system = Mam::System.select_all.status_meaning.find(params[:id])
    @system_person = Mam::SystemPerson.new(:system_id=>params[:id])
    respond_to do |format|
      format.html# show.html.erb
      format.xml { render :xml => @system }
    end
  end

  # GET /incident_requests/new
  # GET /incident_requests/new.xml
  def new
    @system = Mam::System.new()
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @system }
    end
  end

  def create
    @system = Mam::System.new(params[:mam_system])
    respond_to do |format|
      if @system.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @system, :status => :created, :location => @system }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system.errors, :status => :unprocessable_entity }
      end
    end
  end


  # GET /incident_rsolr_searchequests/1/edit
  def edit
    @system = Mam::System.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
      format.xml { render :xml => @system }
    end
  end

   def update
     @system = Mam::System.find(params[:id])

     respond_to do |format|
       if @system.update_attributes(params[:mam_system])
         format.html { redirect_to({:action=>"show", :id => @system.id},:notice => (t :successfully_updated)) }
         format.xml  { head :ok }
       else
         @error = @system
         format.html { render "edit" }
         format.xml  { render :xml => @system.errors, :status => :unprocessable_entity }
       end
     end
   end

  def get_data
    systems_scope = Mam::System.select_all.status_meaning
    systems,count = paginate(systems_scope)

    respond_to do |format|
      format.json  {render :json => to_jsonp(systems.to_grid_json([:system_name], count)) }
      format.html  {
        @count = count
        @datas = systems
      }
    end
  end

  def add_people
    @system = Mam::System.find(params[:system_id])
    @system_person = Mam::SystemPerson.new()
  end

   def add_support_groups
     @system = Mam::System.find(params[:system_id])
     @system_group = Mam::SystemGroup.new()
   end

  def add_people_create
    @system = Mam::System.find(params[:system_id])
    @system_person = Mam::SystemPerson.new(params[:mam_system_person])
    respond_to do |format|
      @system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
        Mam::SystemPerson.create(:person_id=>id,:system_id=>@system.id)
      end if @system_person.status_code.present?
      format.html { redirect_to({:action=>"show",:id=>@system.id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @system_person, :status => :created}
    end
  end

   def add_support_group_create
     @system = Mam::System.find(params[:system_id])
     @system_group = Mam::SystemGroup.new(params[:mam_system_group])
     respond_to do |format|
       @system_group.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
         Mam::SystemGroup.create(:support_group_id=>id,:system_id=>@system.id)
       end if @system_group.status_code.present?
       format.html { redirect_to({:action=>"show",:id=>@system.id}, :notice => t(:successfully_created)) }
       format.xml  { render :xml => @system_group, :status => :created}
     end
   end

  def get_memberable_data
    members_scope = Irm::Person.
        select("#{Irm::Person.table_name}.full_name person_name, #{Irm::Person.table_name}.login_name, #{Irm::Person.table_name}.email_address email_address, #{Irm::Person.table_name}.id").
        where("NOT EXISTS(SELECT 1 FROM mam_system_people msp WHERE msp.system_id = ? AND msp.person_id = #{Irm::Person.table_name}.id)", params[:system_id])

    members_scope = members_scope.match_value("#{Irm::Person.table_name}.login_name", params[:login_name])
    members_scope = members_scope.match_value("#{Irm::Person.table_name}.full_name", params[:person_name])
    members_scope = members_scope.match_value("#{Irm::Person.table_name}.email_address", params[:email_address])

    members_scope,count = paginate(members_scope)
    respond_to do |format|
      format.html  {
        @datas = members_scope
        @count = count
      }
      format.json {render :json=>to_jsonp(members_scope.to_grid_json([:person_name,:email_address], count))}
    end
  end

   def get_groupable_data
     groups_scope = Icm::SupportGroup.
         select("isgv.name support_group_name, isgv.id").
         joins(", icm_support_groups_vl isgv").
         where("#{Icm::SupportGroup.table_name}.id = isgv.id").where("isgv.language = ?", I18n.locale).
         where("NOT EXISTS(SELECT 1 FROM mam_system_groups msg WHERE msg.system_id = ? AND msg.support_group_id = isgv.id)", params[:system_id])
     groups_scope,count = paginate(groups_scope)
     respond_to do |format|
       format.html  {
         @datas = groups_scope
         @count = count
       }
     end
   end

  def get_owned_members_data
    members_scope = Mam::SystemPerson.select_all.with_person.where(:system_id=>params[:system_id])
    members_scope,count = paginate(members_scope)
    respond_to do |format|
      format.html  {
        @system = Mam::System.find(params[:system_id])
        @datas = members_scope
        @count = count
      }
      format.json {render :json=>to_jsonp(members_scope.to_grid_json([:person_name,:email_address], count))}
    end
  end

   def get_owned_groups_data
     groups_scope = Mam::SystemGroup.select_all.
         with_support_group(I18n.locale).
         where("system_id = ?", params[:system_id])
     groups_scope,count = paginate(groups_scope)
     respond_to do |format|
       format.html  {
         @system = Mam::System.find(params[:system_id])
         @datas = groups_scope
         @count = count
       }
     end
   end

  def delete_person
    @system_person = Mam::SystemPerson.find(params[:id])
    system_id = @system_person.system_id
    @system_person.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"mam/systems",:action=>"show",:id=>system_id}) }
      format.xml  { head :ok }
    end
  end

   def delete_support_group
     @system_group = Mam::SystemGroup.find(params[:id])
     system_id = @system_group.system_id
     @system_group.destroy

     respond_to do |format|
       format.html { redirect_to({:controller=>"mam/systems",:action=>"show",:id=>system_id}) }
       format.xml  { head :ok }
     end
   end
end
