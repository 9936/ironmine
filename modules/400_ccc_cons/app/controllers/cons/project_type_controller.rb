class Cons::ProjectTypeController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projectType }
    end
  end

  def new
    @projectType = Cons::ProjectType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projectType }
    end
  end

  def create
    @projectType = Cons::ProjectType.new(params[:cons_projectType])
    puts params[:cons_projectType].inspect

    respond_to do |format|
      if @projectType.save
        format.html { redirect_to({:action=>"show",:id=>@projectType.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @projectType, :status => :created, :location => @projectType }
        format.json { render :json=>@projectType}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @projectType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @projectType.errors}
      end
    end
  end

  def show
    @projectType = Cons::ProjectType.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@projectType}
      format.html
    end
  end

  def edit
    @projectType = Cons::ProjectType.find(params[:id])
  end

  def update
    @projectType = Cons::ProjectType.find(params[:id])

    respond_to do |format|
      if @projectType.update_attributes(params[:cons_projectType])
        format.html { redirect_to({:action=>"show", :id=>@projectType.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@projectType}
      else
        @error = @projectType
        format.html { render "edit" }
        format.xml  { render :xml => @projectType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @projectType.errors}
      end
    end
  end

  def get_data
    @projectType = Cons::ProjectType.where("id <> ?", "").with_projectType_message
    @projectType = @projectType.match_value("#{Cons::ProjectType.table_name}.name",params[:name])
    @projectType = @projectType.match_value("#{Cons::ProjectType.table_name}.code",params[:code])
    @projectType = @projectType.match_value("#{Cons::ProjectType.table_name}.description",params[:description])

    @projectType,count = paginate(@projectType)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@projectType.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @projectType
      }
    end
  end

end
