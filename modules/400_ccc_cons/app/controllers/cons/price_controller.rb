class Cons::PriceController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @price }
    end
  end

  def new
    @price = Cons::Price.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @price }
    end
  end

  def create
    @price = Cons::Price.new(params[:cons_price])
    puts params[:cons_price].inspect

    respond_to do |format|
      if @price.save
        format.html { redirect_to({:action=>"show",:id=>@price.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @price, :status => :created, :location => @price }
        format.json { render :json=>@price}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @price.errors, :status => :unprocessable_entity }
        format.json  { render :json => @price.errors}
      end
    end
  end

  def show
    @price = Cons::Price.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@price}
      format.html
    end
  end

  def edit
    @price = Cons::Price.find(params[:id])
  end

  def update
    @price = Cons::Price.find(params[:id])

    respond_to do |format|
      if @price.update_attributes(params[:cons_price])
        format.html { redirect_to({:action=>"show", :id=>@price.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@price}
      else
        @error = @price
        format.html { render "edit" }
        format.xml  { render :xml => @price.errors, :status => :unprocessable_entity }
        format.json  { render :json => @price.errors}
      end
    end
  end

  def get_data

    @price = Cons::Price.where("id <> ?", "").with_price_message
    @price = @price.match_value("#{Cons::Price.table_name}.name",params[:name])
    @price = @price.match_value("#{Cons::Price.table_name}.code",params[:code])
    @price = @price.match_value("#{Cons::Price.table_name}.description",params[:description])

    @price,count = paginate(@price)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@price.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @price
      }
    end
  end

end
