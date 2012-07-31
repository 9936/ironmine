class Irm::LookupTypesController < ApplicationController
  # GET /lookup_types
  # GET /lookup_types.xml
  def index
   @lookup_type = Irm::LookupType.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lookup_types }
    end
  end

  def show
    @lookup_type = Irm::LookupType.multilingual.find(params[:id])
  end


  # GET /lookup_types/new
  # GET /lookup_types/new.xml
  def new
    @lookup_type = Irm::LookupType.new(:lookup_level=>'USER')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lookup_type }
    end
  end

  # GET /lookup_types/1/edit
  def edit
    @lookup_type = Irm::LookupType.multilingual.find(params[:id])
  end

  # POST /lookup_types
  # POST /lookup_types.xml
  def create
    @lookup_type = Irm::LookupType.new(params[:irm_lookup_type])

    respond_to do |format|
      if @lookup_type.save
        flash[:successful_message] = (t :successfully_created)
        format.html { redirect_to({:action=>"index"},:notice => (t :successfully_created))}
        format.xml  { render :xml => @lookup_type, :status => :created, :location => @lookup_type }
      else
        @error=@lookup_type
        format.html { render "new" }
        format.xml  { render :xml => @lookup_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # multi language
  def multilingual_edit
    @lookup_type = Irm::LookupType.find(params[:id])
  end

  def multilingual_update
    @lookup_type = Irm::LookupType.find(params[:id])
    @lookup_type.not_auto_mult=true
    respond_to do |format|
      if @lookup_type.update_attributes(params[:irm_lookup_type])
        format.html { render({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end

  # PUT /lookup_types/1
  # PUT /lookup_types/1.xml
  def update
    @lookup_type = Irm::LookupType.find(params[:id])

    respond_to do |format|
      if @lookup_type.update_attributes(params[:irm_lookup_type])
        format.html { redirect_to({:action=>"index"},:notice => (t :successfully_updated))}
        format.xml  { head :ok }
      else
        format.html { render "edit" }
        format.xml  { render :xml => @lookup_type.errors, :status => :unprocessable_entity }
      end
    end
  end


  def get_lookup_types
    @lookup_types = Irm::LookupType.multilingual.query_wrap_info(I18n::locale)
    @lookup_types = @lookup_types.match_value("#{Irm::LookupType.table_name}.lookup_type",params[:lookup_type])
    @lookup_types = @lookup_types.match_value("#{Irm::LookupTypesTl.table_name}.meaning",params[:meaning])
    @lookup_types,count = paginate(@lookup_types)
    respond_to do |format|
      format.json  {render :json => to_jsonp(@lookup_types.to_grid_json(['R',:lookup_level,:lookup_type,:meaning,:description,:status_meaning],
                                                                               count)) }
      format.html  {
        @count=count
        @datas=@lookup_types
      }

    end
  end
end
