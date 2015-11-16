class Ccc::SexesController < ApplicationController
  layout "uid"
  # GET /industries
  # GET /industries.xml
  def index
    @sexes = Ccc::Sex.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sexes }
    end
  end

  def show

    @sex = Ccc::Sex.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sex }
    end
  end

  # GET /industries/new
  # GET /industries/new.xml
  def new
    @sex = Ccc::Sex.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sex }
    end
  end

  # GET /industries/1/edit
  def edit
    @sex = Ccc::Sex.multilingual.find(params[:id])
  end

  # POST /industries
  # POST /industries.xml
  def create
    @sex = Ccc::Sex.new(params[:ccc_sex])
    respond_to do |format|
      if @sex.valid? && @sex.save
        format.html { redirect_to({:action => "show", :id => @sex}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @sex, :status => :created, :location => @sex }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sex.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /industries/1
  # PUT /industries/1.xml
  def update
    @sex = Ccc::Sex.find(params[:id])

    respond_to do |format|
      if @sex.update_attributes(params[:ccc_sex])
        format.html { redirect_to({:action=>"show", :id=>@sex.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@sex}
      else
        @error = @sex
        format.html { render "edit" }
        format.xml  { render :xml => @sex.errors, :status => :unprocessable_entity }
        format.json  { render :json => @sex.errors}
      end
    end
  end


  def get_data
    industries_scope = Ccc::Sex.multilingual
    industries_scope = industries_scope.match_value("#{Ccc::Sex.table_name}.code",params[:code])
    industries_scope = industries_scope.match_value("#{Ccc::SexesTl.table_name}.name",params[:name])
    industries_scope = industries_scope.match_value("#{Ccc::SexesTl.table_name}.description",params[:description])
    industries,count = paginate(industries_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(industries.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = industries
      }
    end
  end

  def multilingual_edit
    @sex = Ccc::Sex.find(params[:id])
  end

  def multilingual_update
    @sex = Ccc::Sex.find(params[:id])
    @sex.not_auto_mult=true
    respond_to do |format|
      if @sex.update_attributes(params[:ccc_sex])
        format.html { redirect_to({:action => "show"}, :notice => 'sex was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sex.errors, :status => :unprocessable_entity }
      end
    end
  end
end
