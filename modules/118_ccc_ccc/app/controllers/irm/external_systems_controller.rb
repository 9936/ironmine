class Irm::ExternalSystemsController < ApplicationController
  # GET /external_systems
  # GET /external_systems.xml
  def index
    @external_systems = Irm::ExternalSystem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @external_systems }
    end
  end

  # GET /external_systems/1
  # GET /external_systems/1.xml
  def show
    @external_system = Irm::ExternalSystem.multilingual.list_all.status_meaning.find(params[:id])
    @external_system_person = Irm::ExternalSystemPerson.new
    @external_system_person.status_code=""
    @business_objects = Irm::BusinessObject.with_system_custom_flag.multilingual.order(:bo_table_name)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @external_system }
    end
  end

  # GET /external_systems/new
  # GET /external_systems/new.xml
  def new
    @external_system = Irm::ExternalSystem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @external_system }
    end
  end

  # GET /external_systems/1/edit
  def edit
    @external_system = Irm::ExternalSystem.multilingual.find(params[:id])
  end

  # POST /external_systems
  # POST /external_systems.xml
  def create
    external_system = Irm::ExternalSystem.order("external_system_code DESC").first
    if external_system
      external_system_code = external_system.external_system_code
      if external_system_code.to_i!= 0
        params[:irm_external_system][:external_system_code] = (external_system_code.to_i + 1).to_s
      else
        params[:irm_external_system][:external_system_code] = "100000"
      end
    else
      params[:irm_external_system][:external_system_code] = "100000"
    end

    @external_system = Irm::ExternalSystem.new(params[:irm_external_system])

    respond_to do |format|
      if @external_system.save
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @external_system, :status => :created, :location => @external_system }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @external_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /external_systems/1
  # PUT /external_systems/1.xml
  def update
    @external_system = Irm::ExternalSystem.multilingual.find(params[:id])

    respond_to do |format|
      if @external_system.update_attributes(params[:irm_external_system])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @external_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /external_systems/1
  # DELETE /external_systems/1.xml
  def destroy
    @external_system = Irm::ExternalSystem.find(params[:id])
    @external_system.destroy

    respond_to do |format|
      format.html { redirect_to(external_systems_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @external_system = Irm::ExternalSystem.find(params[:id])
  end

  def multilingual_update
    @external_system = Irm::ExternalSystem.find(params[:id])
    @external_system.not_auto_mult=true
    respond_to do |format|
      if @external_system.update_attributes(params[:irm_external_system])
        format.html { redirect_to({:action => "show", :id => @external_system.id }, :notice => 'External system was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @external_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    external_systems_scope = Irm::ExternalSystem.multilingual.status_meaning
    external_systems_scope = external_systems_scope.match_value("irm_external_systems_tl.system_name",params[:system_name])
    external_systems_scope = external_systems_scope.match_value("irm_external_systems.external_system_code",params[:external_system_code])
    external_systems_scope = external_systems_scope.match_value("irm_external_systems.external_hostname",params[:hostname])
    external_systems_scope = external_systems_scope.match_value("irm_external_systems.external_ip_address",params[:external_ip_address])
    external_systems,count = paginate(external_systems_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(external_systems.to_grid_json([:external_system_code,:external_hostname,:external_ip_address,
                                                                         :system_name,:system_description,:status_meaning],count))}
      format.html  {
        @count = count
        @datas =external_systems
      }
    end
  end

  def add_people
    @external_system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])

    group_id = params[:support_group].first
    group_id = group_id[:group_id] if group_id.present?

    respond_to do |format|
      if(!@external_system_person.status_code.blank?)
        @external_system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Irm::ExternalSystemPerson.create(:external_system_id => params[:external_system_id],
                                           :person_id => id,
                                           :system_profile_id => params[:irm_external_system_person][:system_profile_id])
          if group_id.present? && !Irm::GroupMember.where("group_id=?", group_id).where("person_id=?", id).any?
            Irm::GroupMember.create(:group_id => group_id, :person_id => id)
          end
        end
      end
      system_id = Irm::ExternalSystem.where(:id=>params[:external_system_id]).first
      format.html { redirect_to({:action=>"show", :id => system_id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

  def delete_people
    @external_system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])

    respond_to do |format|
      if(!@external_system_person.temp_id_string.blank?)
        @external_system_person.temp_id_string.split(",").delete_if{|i| i.blank?}.each do |id|
          esp = Irm::ExternalSystemPerson.where(:external_system_id => params[:external_system_id],:person_id => id).first
          esp.destroy
        end
      end
      system_id = Irm::ExternalSystem.where(:id=>params[:external_system_id]).first
      format.html { redirect_to({:action=>"show", :id => system_id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end
end