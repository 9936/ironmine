class Cons::LevelController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @level }
    end
  end

  def new
    @level = Cons::Level.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @level }
    end
  end

  def create
    @level = Cons::Level.new(params[:cons_level])
    puts params[:cons_level].inspect

    respond_to do |format|
      if @level.save
        format.html { redirect_to({:action=>"show",:id=>@level.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @level, :status => :created, :location => @level }
        format.json { render :json=>@level}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @level.errors, :status => :unprocessable_entity }
        format.json  { render :json => @level.errors}
      end
    end
  end

  def show
    @level = Cons::Level.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@level}
      format.html
    end
  end

  def edit
    @level = Cons::Level.find(params[:id])
  end

  def update
    @level = Cons::Level.find(params[:id])

    respond_to do |format|
      if @level.update_attributes(params[:cons_level])
        format.html { redirect_to({:action=>"show", :id=>@level.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@level}
      else
        @error = @level
        format.html { render "edit" }
        format.xml  { render :xml => @level.errors, :status => :unprocessable_entity }
        format.json  { render :json => @level.errors}
      end
    end
  end

  def get_data
    @level = Cons::Level.where("id <> ?", "").with_level_message
    @level = @level.match_value("#{Cons::Level.table_name}.name",params[:name])
    @level = @level.match_value("#{Cons::Level.table_name}.code",params[:code])
    @level = @level.match_value("#{Cons::Level.table_name}.description",params[:description])

    @level,count = paginate(@level)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@level.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @level
      }
    end
  end

end
