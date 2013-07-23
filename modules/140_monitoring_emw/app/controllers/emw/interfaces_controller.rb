class Emw::InterfacesController < ApplicationController
  layout "application_full"

  # GET /interfaces
  # GET /interfaces.xml
  def index
    @interfaces = Emw::Interface.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interfaces }
    end
  end

  # GET /interfaces/1
  # GET /interfaces/1.xml
  def show
    @interface = Emw::Interface.with_module.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interface }
    end
  end

  # GET /interfaces/new
  # GET /interfaces/new.xml
  def new
    @interface = Emw::Interface.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interface }
    end
  end

  # GET /interfaces/1/edit
  def edit
    @interface = Emw::Interface.find(params[:id])
  end

  # POST /interfaces
  # POST /interfaces.xml
  def create
    @interface = Emw::Interface.new(params[:emw_interface])

    respond_to do |format|
      if @interface.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @interface, :status => :created, :location => @interface }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interface.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interfaces/1
  # PUT /interfaces/1.xml
  def update
    @interface = Emw::Interface.find(params[:id])

    respond_to do |format|
      if @interface.update_attributes(params[:emw_interface])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interface.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interfaces/1
  # DELETE /interfaces/1.xml
  def destroy
    @interface = Emw::Interface.find(params[:id])
    @interface.destroy

    respond_to do |format|
      format.html { redirect_to(interfaces_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    interfaces_scope = Emw::Interface.with_module
    interfaces_scope = interfaces_scope.match_value("#{Emw::Interface.table_name}.name",params[:name])
    interfaces,count = paginate(interfaces_scope)
    respond_to do |format|
      format.html  {
        @datas = interfaces
        @count = count
      }
      format.json {render :json=>to_jsonp(interfaces.to_grid_json([:name,:description],count))}
    end
  end
end
