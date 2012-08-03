class Irm::PermissionsController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @permission = Irm::Permission.list_all.where(:id => params[:id]).first()
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  def new
    @permission = Irm::Permission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  def edit
    @permission = Irm::Permission.multilingual.find(params[:id])
  end

  def create
    @permission = Irm::Permission.new(params[:irm_permission])
    respond_to do |format|
      if @permission.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @permission, :status => :created, :location => @permission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @permission = Irm::Permission.find(params[:id])

    respond_to do |format|
      if @permission.update_attributes(params[:irm_permission])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @permission = Irm::Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_data
    permissions_scope = Irm::Permission.with_function_name.with_product_module_name.list_all.status_meaning.select("controller p_controller,action p_action")
    permissions_scope = permissions_scope.match_value("#{Irm::Permission.table_name}.code",params[:code])
    permissions_scope = permissions_scope.match_value("#{Irm::Permission.table_name}.controller",params[:p_controller])
    permissions_scope = permissions_scope.match_value("#{Irm::Permission.table_name}.action",params[:p_action])
    permissions_scope = permissions_scope.match_value("irm_functions_vl.name",params[:function_name])
    permissions_scope = permissions_scope.match_value("irm_functions_vl.id",params[:function_id])

    permissions,count = paginate(permissions_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(permissions.to_grid_json([:code,:product_module_name,:status_meaning,:function_name,:direct_get_flag,:params_count,:p_controller,:p_action, :status_code], count)) }
      format.html  {
        @datas =  permissions
        @count = count
      }
    end
  end

  def function_get_data
    permissions_scope = Irm::Permission.list_all.status_meaning.belong_to_function(params[:function_code])
    permissions,count = paginate(permissions_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(permissions.to_grid_json([:name,:product_module_name,:status_meaning,:permission_code,:page_controller,:page_action, :status_code], count)) }
    end
  end

  def data_grid
    render :layout => nil
  end

  def multilingual_edit
    @permission = Irm::Permission.find(params[:id])
  end

  def multilingual_update
    @permission = Irm::Permission.find(params[:id])
    @permission.not_auto_mult = true
    respond_to do |format|
      if @permission.update_attributes(params[:irm_permission])
        format.html { redirect_to({:action=>"show"}, :notice => 'Permission was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end    
end
