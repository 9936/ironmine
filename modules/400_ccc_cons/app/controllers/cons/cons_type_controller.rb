class Cons::ConsTypeController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consType }
    end
  end

  def new
    @consType = Cons::ConsType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consType }
    end
  end

  def create
    @consType = Cons::ConsType.new(params[:cons_consType])
    puts params[:cons_consType].inspect

    respond_to do |format|
      if @consType.save
        format.html { redirect_to({:action=>"show",:id=>@consType.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @consType, :status => :created, :location => @consType }
        format.json { render :json=>@consType}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @consType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consType.errors}
      end
    end
  end

  def show
    @consType = Cons::ConsType.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@consType}
      format.html
    end
  end

  def edit
    @consType = Cons::ConsType.find(params[:id])
  end

  def update
    @consType = Cons::ConsType.find(params[:id])

    respond_to do |format|
      if @consType.update_attributes(params[:cons_consType])
        format.html { redirect_to({:action=>"show", :id=>@consType.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@consType}
      else
        @error = @consType
        format.html { render "edit" }
        format.xml  { render :xml => @consType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consType.errors}
      end
    end
  end

  def get_data
    @consType = Cons::ConsType.where("id <> ?", "").with_consType_message
    @consType = @consType.match_value("#{Cons::ConsType.table_name}.name",params[:name])
    @consType = @consType.match_value("#{Cons::ConsType.table_name}.code",params[:code])
    @consType = @consType.match_value("#{Cons::ConsType.table_name}.description",params[:description])

    @consType,count = paginate(@consType)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@consType.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @consType
      }
    end
  end

end
