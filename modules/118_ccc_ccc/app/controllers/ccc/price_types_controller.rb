class Ccc::PriceTypesController < ApplicationController
  layout "uid"
  # GET /price_types
  # GET /price_types.xml
  def index
    @priceTypes = Ccc::PriceType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @priceTypes }
    end
  end

  def show

    @priceType = Ccc::PriceType.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @priceType }
    end
  end

  # GET /price_types/new
  # GET /price_types/new.xml
  def new
    @priceType = Ccc::PriceType.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @priceType }
    end
  end

  # GET /price_types/1/edit
  def edit
    @priceType = Ccc::PriceType.multilingual.find(params[:id])
  end

  # POST /price_types
  # POST /price_types.xml
  def create
    @priceType = Ccc::PriceType.new(params[:ccc_price_type])
    respond_to do |format|
      if @priceType.valid? && @priceType.save
        format.html { redirect_to({:action => "show", :id => @priceType}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @priceType, :status => :created, :location => @priceType }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @priceType.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /price_types/1
  # PUT /price_types/1.xml
  def update
    @priceType = Ccc::PriceType.find(params[:id])

    respond_to do |format|
      if @priceType.update_attributes(params[:ccc_price_type])
        format.html { redirect_to({:action=>"show", :id=>@priceType.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@priceType}
      else
        @error = @priceType
        format.html { render "edit" }
        format.xml  { render :xml => @priceType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @priceType.errors}
      end
    end
  end


  def get_data
    price_types_scope = Ccc::PriceType.multilingual
    price_types_scope = price_types_scope.match_value("#{Ccc::PriceType.table_name}.code",params[:code])
    price_types_scope = price_types_scope.match_value("#{Ccc::PriceTypesTl.table_name}.name",params[:name])
    price_types_scope = price_types_scope.match_value("#{Ccc::PriceTypesTl.table_name}.description",params[:description])
    price_types,count = paginate(price_types_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(price_types.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = price_types
      }
    end
  end

  def multilingual_edit
    @priceType = Ccc::PriceType.find(params[:id])
  end

  def multilingual_update
    @priceType = Ccc::PriceType.find(params[:id])
    @priceType.not_auto_mult=true
    respond_to do |format|
      if @priceType.update_attributes(params[:ccc_price_type])
        format.html { redirect_to({:action => "show"}, :notice => 'price_type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @priceType.errors, :status => :unprocessable_entity }
      end
    end
  end
end
