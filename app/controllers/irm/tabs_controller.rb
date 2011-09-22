class Irm::TabsController < ApplicationController
  # GET /tabs
  # GET /tabs.xml
  def index
    @tabs = Irm::Tab.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tabs }
    end
  end

  # GET /tabs/1
  # GET /tabs/1.xml
  def show
    @tab = Irm::Tab.with_bo(I18n.locale).with_function_group(I18n.locale).multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tab }
    end
  end

  # GET /tabs/new
  # GET /tabs/new.xml
  def new
    @tab = Irm::Tab.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tab }
    end
  end

  # GET /tabs/1/edit
  def edit
    @tab = Irm::Tab.multilingual.find(params[:id])
  end

  # POST /tabs
  # POST /tabs.xml
  def create
    @tab = Irm::Tab.new(params[:irm_tab])

    respond_to do |format|
      if @tab.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @tab, :status => :created, :location => @tab }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @Irm::Tab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tabs/1
  # PUT /tabs/1.xml
  def update
    @tab = Irm::Tab.multilingual.find(params[:id])

    respond_to do |format|
      if @tab.update_attributes(params[:irm_tab])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @Irm::Tab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tabs/1
  # DELETE /tabs/1.xml
  def destroy
    @tab = Irm::Tab.find(params[:id])
    @tab.destroy

    respond_to do |format|
      format.html { redirect_to(tabs_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @tab = Irm::Tab.find(params[:id])
  end

  def multilingual_update
    @tab = Irm::Tab.find(params[:id])
    @tab.not_auto_mult=true
    respond_to do |format|
      if @tab.update_attributes(params[:irm_tab])
        format.html { redirect_to({:action => "show"}, :notice => 'Tab was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @Irm::Tab.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    tabs_scope = Irm::Tab.with_bo(I18n.locale).with_function_group(I18n.locale).multilingual
    tabs_scope = tabs_scope.match_value("#{Irm::TabsTl.table_name}.name",params[:name])
    tabs_scope = tabs_scope.match_value("#{Irm::TabsTl.table_name}.description",params[:description])
    tabs_scope = tabs_scope.match_value("#{Irm::Tab.table_name}.code",params[:code])
    tabs,count = paginate(tabs_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(tabs.to_grid_json([:code,:name,:description,:business_object_name,:function_group_name],count))}
    end
  end
end
