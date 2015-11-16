class Ccc::ProjectTypesController < ApplicationController
  layout "uid"
  # GET /project_types
  # GET /project_types.xml
  def index
    @projectTypes = Ccc::ProjectType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projectTypes }
    end
  end

  def show

    @projectType = Ccc::ProjectType.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @projectType }
    end
  end

  # GET /project_types/new
  # GET /project_types/new.xml
  def new
    @projectType = Ccc::ProjectType.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projectType }
    end
  end

  # GET /project_types/1/edit
  def edit
    @projectType = Ccc::ProjectType.multilingual.find(params[:id])
  end

  # POST /project_types
  # POST /project_types.xml
  def create
    @projectType = Ccc::ProjectType.new(params[:ccc_project_type])
    respond_to do |format|
      if @projectType.valid? && @projectType.save
        format.html { redirect_to({:action => "show", :id => @projectType}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @projectType, :status => :created, :location => @projectType }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @projectType.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_types/1
  # PUT /project_types/1.xml
  def update
    @projectType = Ccc::ProjectType.find(params[:id])

    respond_to do |format|
      if @projectType.update_attributes(params[:ccc_project_type])
        format.html { redirect_to({:action=>"show", :id=>@projectType.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@projectType}
      else
        @error = @projectType
        format.html { render "edit" }
        format.xml  { render :xml => @projectType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @projectType.errors}
      end
    end
  end


  def get_data
    project_types_scope = Ccc::ProjectType.multilingual
    project_types_scope = project_types_scope.match_value("#{Ccc::ProjectType.table_name}.code",params[:code])
    project_types_scope = project_types_scope.match_value("#{Ccc::ProjectTypesTl.table_name}.name",params[:name])
    project_types_scope = project_types_scope.match_value("#{Ccc::ProjectTypesTl.table_name}.description",params[:description])
    project_types,count = paginate(project_types_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(project_types.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = project_types
      }
    end
  end

  def multilingual_edit
    @projectType = Ccc::ProjectType.find(params[:id])
  end

  def multilingual_update
    @projectType = Ccc::ProjectType.find(params[:id])
    @projectType.not_auto_mult=true
    respond_to do |format|
      if @projectType.update_attributes(params[:ccc_project_type])
        format.html { redirect_to({:action => "show"}, :notice => 'project_type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @projectType.errors, :status => :unprocessable_entity }
      end
    end
  end
end
