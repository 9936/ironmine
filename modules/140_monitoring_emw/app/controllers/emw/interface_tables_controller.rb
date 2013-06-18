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
    interface_tables = Emw::InterfaceTable.query_by_interface(params[:interface_id])
    #interface_tables = interface_tables_scope.match_value("interface_table.name",params[:name])
    respond_to do |format|
      format.html  {
        @datas = interface_tables
        @count = interface_tables.count
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
      @interface_table.step = @step
      @interface_table.import_flag = 'Y'


      if @interface_table.valid?
        eval("import_step_#{@step}")
      else
        @step -= 1 if @step > 1
      end
    end
  end

  private
    def import_step_2
      begin
        @columns = @interface_table.get_columns
      rescue RuntimeError => e
        @interface_table.errors.add(:database, e.message)
        @step -= 1
      end
    end

    def import_step_3
      @columns = []
      selected_columns = params[:columns]
      if selected_columns.present? && selected_columns.any?
        selected_columns.each do |c_s|
          column = c_s.split(" ")
          if column.size == 4
            description = column[3]
          else
            description = nil
          end
          error_flag = params["#{column[0]}_error"].present?? params["#{column[0]}_error"] : 'N'
          message_flag = params["#{column[0]}_message"].present?? params["#{column[0]}_message"] : 'N'
          @columns << {:name => column[0], :data_type => column[1], :data_length => column[2], :error_flag => error_flag, :message_flag => message_flag, :description => description }
        end
      end
    end

    def import_step_4
      if params[:columns].present? && params[:columns].any?
        params[:columns].each do |column|
          column = eval(column)
          @interface_table.interface_columns.build(:name => column[:name],
                                                   :data_type => column[:data_type],
                                                   :data_length => column[:data_length],
                                                   :error_flag => column[:error_flag],
                                                   :message_flag => column[:message_flag],
                                                   :description => column[:description])
        end
        @interface_table.save
      end


    end
end
