class Emw::InterfaceTablesController < ApplicationController
  layout "application_full"

  # GET /interface_tables/1
  # GET /interface_tables/1.xml
  def show
    @interface_table = Emw::InterfaceTable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interface_table }
    end
  end

  # GET /interface_tables/new
  # GET /interface_tables/new.xml
  def new
    @interface_table = Emw::InterfaceTable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interface_table }
    end
  end

  # GET /interface_tables/1/edit
  def edit
    @interface_table = Emw::InterfaceTable.find(params[:id])
  end

  # POST /interface_tables
  # POST /interface_tables.xml
  def create
    @interface_table = Emw::InterfaceTable.new(params[:emw_interface_table])
    @interface_table.interface_id = params[:interface_id]
    respond_to do |format|
      if @interface_table.save
        format.js
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @interface_table, :status => :created, :location => @interface_table }
      else
        format.js
        format.html { render :action => "new" }
        format.xml  { render :xml => @interface_table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interface_tables/1
  # PUT /interface_tables/1.xml
  def update
    @interface_table = Emw::InterfaceTable.find(params[:id])

    respond_to do |format|
      if @interface_table.update_attributes(params[:emw_interface_table])
        format.js
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.js
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interface_table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interface_tables/1
  # DELETE /interface_tables/1.xml
  def destroy
    @interface_table = Emw::InterfaceTable.find(params[:id])
    @interface_table.destroy

    respond_to do |format|
      format.html { redirect_to(interface_tables_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    interface_tables_scope = Emw::InterfaceTable.multilingual
    interface_tables_scope = interface_tables_scope.match_value("interface_table.name",params[:name])
    interface_tables,count = paginate(interface_tables_scope)
    respond_to do |format|
      format.html  {
        @datas = interface_tables
        @count = count
      }
      format.json {render :json=>to_jsonp(interface_tables.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  #导入接口表
  def import
    @step = params[:step]
    @step ||= 1
    @step = @step.to_i

    if @step == 1
      session[:emw_interface_table] = nil
      @interface_table = Emw::InterfaceTable.new(:interface_id => params[:interface_id])
    else
      if session[:emw_interface_table]
        session[:emw_interface_table].merge!(params[:emw_interface_table]) if params[:emw_interface_table].present?
      else
        session[:emw_interface_table] = params[:emw_interface_table]
      end

      @interface_table = Emw::InterfaceTable.new(session[:emw_interface_table])
      @interface_table.import_flag = 'Y'
      if @interface_table.valid?

      else
        @step -= 1 if @step > 1
      end
      puts "==========#{@interface_table.errors.to_json}============"
    end
  end
end
