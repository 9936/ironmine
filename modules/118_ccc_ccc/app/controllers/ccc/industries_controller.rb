class Ccc::IndustriesController < ApplicationController
  layout "uid"
  # GET /industries
  # GET /industries.xml
  def index
    @industries = Ccc::Industry.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @industries }
    end
  end

  def show
   
    @industry = Ccc::Industry.multilingual.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @industry }
    end
  end

  # GET /industries/new
  # GET /industries/new.xml
  def new
    @industry = Ccc::Industry.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @industry }
    end
  end

  # GET /industries/1/edit
  def edit
    @industry = Ccc::Industry.multilingual.find(params[:id])
  end

  # POST /industries
  # POST /industries.xml
  def create
    @industry = Ccc::Industry.new(params[:ccc_industry])
    respond_to do |format|
      if @industry.valid? && @industry.save
        format.html { redirect_to({:action => "show", :id => @industry}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @industry, :status => :created, :location => @industry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @industry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /industries/1
  # PUT /industries/1.xml
  def update
    @industry = Ccc::Industry.find(params[:id])

    respond_to do |format|
      if @industry.update_attributes(params[:ccc_industry])
        format.html { redirect_to({:action=>"show", :id=>@industry.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@industry}
      else
        @error = @industry
        format.html { render "edit" }
        format.xml  { render :xml => @industry.errors, :status => :unprocessable_entity }
        format.json  { render :json => @industry.errors}
      end
    end
  end


  def get_data
    industries_scope = Ccc::Industry.multilingual
    industries_scope = industries_scope.match_value("#{Ccc::Industry.table_name}.code",params[:code])
    industries_scope = industries_scope.match_value("#{Ccc::IndustriesTl.table_name}.name",params[:name])
    industries_scope = industries_scope.match_value("#{Ccc::IndustriesTl.table_name}.description",params[:description])
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
    @industry = Ccc::Industry.find(params[:id])
  end

  def multilingual_update
    @industry = Ccc::Industry.find(params[:id])
    @industry.not_auto_mult=true
    respond_to do |format|
      if @industry.update_attributes(params[:ccc_industry])
        format.html { redirect_to({:action => "show"}, :notice => 'Industry was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @industry.errors, :status => :unprocessable_entity }
      end
    end
  end
end
