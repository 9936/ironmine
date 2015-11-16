class Ccc::ConsultantLevelsController < ApplicationController
  layout "uid"
  # GET /consultant_levels
  # GET /consultant_levels.xml
  def index
    @consultantLevels = Ccc::ConsultantLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultantLevels }
    end
  end

  def show

    @consultantLevel = Ccc::ConsultantLevel.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultantLevel }
    end
  end

  # GET /consultant_levels/new
  # GET /consultant_levels/new.xml
  def new
    @consultantLevel = Ccc::ConsultantLevel.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultantLevel }
    end
  end

  # GET /consultant_levels/1/edit
  def edit
    @consultantLevel = Ccc::ConsultantLevel.multilingual.find(params[:id])
  end

  # POST /consultant_levels
  # POST /consultant_levels.xml
  def create
    @consultantLevel = Ccc::ConsultantLevel.new(params[:ccc_consultant_level])
    respond_to do |format|
      if @consultantLevel.valid? && @consultantLevel.save
        format.html { redirect_to({:action => "show", :id => @consultantLevel}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @consultantLevel, :status => :created, :location => @consultantLevel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultantLevel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultant_levels/1
  # PUT /consultant_levels/1.xml
  def update
    @consultantLevel = Ccc::ConsultantLevel.find(params[:id])

    respond_to do |format|
      if @consultantLevel.update_attributes(params[:ccc_consultant_level])
        format.html { redirect_to({:action=>"show", :id=>@consultantLevel.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@consultantLevel}
      else
        @error = @consultantLevel
        format.html { render "edit" }
        format.xml  { render :xml => @consultantLevel.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultantLevel.errors}
      end
    end
  end


  def get_data
    consultant_levels_scope = Ccc::ConsultantLevel.multilingual
    consultant_levels_scope = consultant_levels_scope.match_value("#{Ccc::ConsultantLevel.table_name}.code",params[:code])
    consultant_levels_scope = consultant_levels_scope.match_value("#{Ccc::ConsultantLevelsTl.table_name}.name",params[:name])
    consultant_levels_scope = consultant_levels_scope.match_value("#{Ccc::ConsultantLevelsTl.table_name}.description",params[:description])
    consultant_levels,count = paginate(consultant_levels_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(consultant_levels.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = consultant_levels
      }
    end
  end

  def multilingual_edit
    @consultantLevel = Ccc::ConsultantLevel.find(params[:id])
  end

  def multilingual_update
    @consultantLevel = Ccc::ConsultantLevel.find(params[:id])
    @consultantLevel.not_auto_mult=true
    respond_to do |format|
      if @consultantLevel.update_attributes(params[:ccc_consultant_level])
        format.html { redirect_to({:action => "show"}, :notice => 'consultantLevel was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultantLevel.errors, :status => :unprocessable_entity }
      end
    end
  end
end
