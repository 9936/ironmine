class Ccc::ConnTypesController < ApplicationController
  layout "uid"
  # GET /conn_types
  # GET /conn_types.xml
  def index
    @connTypes = Ccc::ConnType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @connTypes }
    end
  end

  def show

    @connType = Ccc::ConnType.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @connType }
    end
  end

  # GET /conn_types/new
  # GET /conn_types/new.xml
  def new
    @connType = Ccc::ConnType.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @connType }
    end
  end

  # GET /conn_types/1/edit
  def edit
    @connType = Ccc::ConnType.multilingual.find(params[:id])
  end

  # POST /conn_types
  # POST /conn_types.xml
  def create
    @connType = Ccc::ConnType.new(params[:ccc_conn_type])
    respond_to do |format|
      if @connType.valid? && @connType.save
        format.html { redirect_to({:action => "show", :id => @connType}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @connType, :status => :created, :location => @connType }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @connType.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conn_types/1
  # PUT /conn_types/1.xml
  def update
    @connType = Ccc::ConnType.find(params[:id])

    respond_to do |format|
      if @connType.update_attributes(params[:ccc_conn_type])
        format.html { redirect_to({:action=>"show", :id=>@connType.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@connType}
      else
        @error = @connType
        format.html { render "edit" }
        format.xml  { render :xml => @connType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @connType.errors}
      end
    end
  end


  def get_data
    conn_types_scope = Ccc::ConnType.multilingual
    conn_types_scope = conn_types_scope.match_value("#{Ccc::ConnType.table_name}.code",params[:code])
    conn_types_scope = conn_types_scope.match_value("#{Ccc::ConnTypesTl.table_name}.name",params[:name])
    conn_types_scope = conn_types_scope.match_value("#{Ccc::ConnTypesTl.table_name}.description",params[:description])
    conn_types,count = paginate(conn_types_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(conn_types.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = conn_types
      }
    end
  end

  def multilingual_edit
    @connType = Ccc::ConnType.find(params[:id])
  end

  def multilingual_update
    @connType = Ccc::ConnType.find(params[:id])
    @connType.not_auto_mult=true
    respond_to do |format|
      if @connType.update_attributes(params[:ccc_conn_type])
        format.html { redirect_to({:action => "show"}, :notice => 'ConnType was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @connType.errors, :status => :unprocessable_entity }
      end
    end
  end
end
