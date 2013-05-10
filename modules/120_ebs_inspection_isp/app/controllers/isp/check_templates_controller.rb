class Isp::CheckTemplatesController < ApplicationController

  # GET /isp/check_templates
  # GET /isp/check_templates.xml
  def index
    @check_templates = Isp::CheckTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @check_templates }
    end
  end

  # GET /isp/check_templates/1
  # GET /isp/check_templates/1.xml
  def show
    @check_template = Isp::CheckTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @check_template }
    end
  end

  # GET /isp/check_templates/new
  # GET /isp/check_templates/new.xml
  def new
    @check_template = Isp::CheckTemplate.new(:program_id=>params[:program_id])

    find_param_symbols

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @check_template }
    end
  end

  # GET /isp/check_templates/1/edit
  def edit
    @check_template = Isp::CheckTemplate.find(params[:id])
    find_param_symbols
  end

  # POST /isp/check_templates
  # POST /isp/check_templates.xml
  def create
    @check_template = Isp::CheckTemplate.new(params[:isp_check_template])

    respond_to do |format|
      if @check_template.save
        format.html { redirect_to({:controller => "isp/programs", :id => @check_template.program_id, :action => "show"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @check_template, :status => :created, :location => @check_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @check_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /isp/check_templates/1
  # PUT /isp/check_templates/1.xml
  def update
    @check_template = Isp::CheckTemplate.find(params[:id])

    respond_to do |format|
      if @check_template.update_attributes(params[:isp_check_template])
        format.html { redirect_to({:controller => "isp/programs", :id => @check_template.program_id, :action => "show"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @check_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /isp/check_templates/1
  # DELETE /isp/check_templates/1.xml
  def destroy
    @check_template = Isp::CheckTemplate.find(params[:id])
    @check_template.destroy

    respond_to do |format|
      format.html { redirect_to(isp_check_templates_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @check_template = Isp::CheckTemplate.find(params[:id])
  end

  def multilingual_update
    @check_template = Isp::CheckTemplate.find(params[:id])
    @check_template.not_auto_mult=true
    respond_to do |format|
      if @check_template.update_attributes(params[:isp_check_template])
        format.html { redirect_to({:action => "show"}, :notice => 'Check template was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @check_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    check_templates_scope = Isp::CheckTemplate.with_program(params[:program_id])
    check_templates_scope = check_templates_scope.match_value("#{Isp::CheckTemplate.table_name}.name",params[:name])
    check_templates,count = paginate(check_templates_scope)
    respond_to do |format|
      format.html  {
        @datas = check_templates
        @count = count
      }
      format.json {render :json=>to_jsonp(check_templates.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  private
    def find_param_symbols
      @param_symbols = []

      program = @check_template.program

      program.connections.each do |conn|
        @param_symbols << conn.object_symbol

        conn.check_items.each do |ci|
          @param_symbols << "#{conn.object_symbol}.#{ci.object_symbol}"

          ci.check_parameters.each do |cp|
            @param_symbols << "#{conn.object_symbol}.#{cp.object_symbol}"
          end
        end
      end
    end
end
