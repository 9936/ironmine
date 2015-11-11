class Cons::ConnectController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @connect }
    end
  end

  def new
    @connect = Cons::Connect.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @connect }
    end
  end

  def create
    @connect = Cons::Connect.new(params[:cons_connect])
    puts params[:cons_connect].inspect

    respond_to do |format|
      if @connect.save
        format.html { redirect_to({:action=>"show",:id=>@connect.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @connect, :status => :created, :location => @connect }
        format.json { render :json=>@connect}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @connect.errors, :status => :unprocessable_entity }
        format.json  { render :json => @connect.errors}
      end
    end
  end

  def show
    @connect = Cons::Connect.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@connect}
      format.html
    end
  end

  def edit
    @connect = Cons::Connect.find(params[:id])
  end

  def update
    @connect = Cons::Connect.find(params[:id])

    respond_to do |format|
      if @connect.update_attributes(params[:cons_connect])
        format.html { redirect_to({:action=>"show", :id=>@connect.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@connect}
      else
        @error = @connect
        format.html { render "edit" }
        format.xml  { render :xml => @connect.errors, :status => :unprocessable_entity }
        format.json  { render :json => @connect.errors}
      end
    end
  end

  def get_data
    @connect = Cons::Connect.where("id <> ?", "").with_connect_message
    @connect = @connect.match_value("#{Cons::Connect.table_name}.name",params[:name])
    @connect = @connect.match_value("#{Cons::Connect.table_name}.code",params[:code])
    @connect = @connect.match_value("#{Cons::Connect.table_name}.description",params[:description])

    @connect,count = paginate(@connect)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@connect.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @connect
      }
    end

  end

end
