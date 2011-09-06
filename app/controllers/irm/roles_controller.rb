class Irm::RolesController < ApplicationController
  def index
    all_roles = Irm::Role.list_all

    grouped_roles = all_roles.collect{|i| [i.id,i.report_to_role_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    roles = {}
    all_roles.each do |ar|
      roles.merge!({ar.id=>ar})
    end
    @level_roles = []

    proc = Proc.new{|parent_role_id,level|
      if(grouped_roles[parent_role_id.to_s]&&grouped_roles[parent_role_id.to_s].any?)

        grouped_roles[parent_role_id.to_s].each do |r|
          roles[r[0]].level = level
          @level_roles << roles[r[0]]

          proc.call(roles[r[0]].id,level+1)
        end
      end
    }


    grouped_roles["blank"].each do |gr|
      roles[gr[0]].level = 1
      @level_roles << roles[gr[0]]
      proc.call(roles[gr[0]].id,2)
    end if grouped_roles["blank"]


    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @role = Irm::Role.list_all.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  def new
    @role = Irm::Role.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  def edit
    @role = Irm::Role.multilingual.find(params[:id])
  end

  def create
    @role = Irm::Role.new(params[:irm_role])
    respond_to do |format|
      if @role.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        @fgs = Irm::FunctionGroup.multilingual.enabled
        fs = Irm::Function.multilingual.enabled.where(:public_flag=>Irm::Constant::SYS_NO,:login_flag=>Irm::Constant::SYS_NO)
        @fs = fs.group_by{|i| i.group_code}
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @role = Irm::Role.find(params[:id])
    respond_to do |format|
      if @role.update_attributes(params[:irm_role])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        @fgs = Irm::FunctionGroup.multilingual.enabled
        fs = Irm::Function.multilingual.enabled.where(:public_flag=>Irm::Constant::SYS_NO,:login_flag=>Irm::Constant::SYS_NO)
        @fs = fs.group_by{|i| i.group_code}
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @role = Irm::Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_data
    roles_scope = Irm::Role.list_all
    roles_scope = roles_scope.match_value("#{Irm::Role.table_name}.code",params[:code])
    roles_scope = roles_scope.match_value("#{Irm::RolesTl.table_name}.name",params[:name])    
    roles,count = paginate(roles_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(roles.to_grid_json([:name,:code,:report_to_role_name,:status_code, :description], count)) }
    end
  end
  
  def data_grid
    render :layout => nil
  end

  def multilingual_edit
    @role = Irm::Role.find(params[:id])
  end

  def multilingual_update
    @role = Irm::Role.find(params[:id])
    @role.not_auto_mult = true
    respond_to do |format|
      if @role.update_attributes(params[:irm_role])
        format.html { redirect_to({:action=>"show"}, :notice => 'Role was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit_assignment
    @role = Irm::Role.find(params[:id])
  end

  def update_assignment
    @role = Irm::Role.find(params[:id])
    if params[:person_ids]&&params[:person_ids].strip.length>0
      person_ids =params[:person_ids].strip.split(",")
      person_ids.each do |pid|
        if pid.present?
          Irm::Person.find(pid).update_attribute(:role_id,params[:id])
        end
      end
    end
    respond_to do |format|
        format.html { render :action => "edit_assignment" }
    end
  end

  def assignable_people
    @people= Irm::Person.list_all.order(:id).where("role_id != ? OR role_id IS NULL OR role_id=''",params[:id])

    @people,count = paginate(@people)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@people.to_grid_json([:login_name,:person_name,:region_name,:email_address,:bussiness_phone], count))}
    end
  end

  def role_people
    @people= Irm::Person.list_all.order(:id).where("role_id =?",params[:id])

    @people,count = paginate(@people)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@people.to_grid_json([:login_name,:person_name,:region_name,:email_address,:bussiness_phone], count))}
    end
  end
end
