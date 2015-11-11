class Cons::StatusController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @status }
    end
  end

  def new
    @status = Cons::Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status }
    end
  end

  def create
    @status = Cons::Status.new(params[:cons_status])
    puts params[:cons_status].inspect

    respond_to do |format|
      if @status.save
        format.html { redirect_to({:action=>"show",:id=>@status.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @status, :status => :created, :location => @status }
        format.json { render :json=>@status}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        format.json  { render :json => @status.errors}
      end
    end
  end

  def show
    @status = Cons::Status.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@status}
      format.html
    end
  end

  def edit
    @status = Cons::Status.find(params[:id])
  end

  def update
    @status = Cons::Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:cons_status])
        format.html { redirect_to({:action=>"show", :id=>@status.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@status}
      else
        @error = @status
        format.html { render "edit" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        format.json  { render :json => @status.errors}
      end
    end
  end

  def get_data
    @status = Cons::Status.where("id <> ?", "").with_status_message
    @status = @status.match_value("#{Cons::Status.table_name}.name",params[:name])
    @status = @status.match_value("#{Cons::Status.table_name}.code",params[:code])
    @status = @status.match_value("#{Cons::Status.table_name}.description",params[:description])

    @status,count = paginate(@status)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@status.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @status
      }
    end
  end

end
