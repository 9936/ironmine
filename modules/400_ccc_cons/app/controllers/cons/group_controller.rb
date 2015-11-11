class Cons::GroupController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def new
    @group = Cons::Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def create
    @group = Cons::Group.new(params[:cons_group])
    puts params[:cons_group].inspect

    respond_to do |format|
      if @group.save
        format.html { redirect_to({:action=>"show",:id=>@group.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @group, :status => :created, :location => @group }
        format.json { render :json=>@group}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors}
      end
    end
  end

  def show
    @group = Cons::Group.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@group}
      format.html
    end
  end

  def edit
    @group = Cons::Group.find(params[:id])
  end

  def update
    @group = Cons::Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:cons_group])
        format.html { redirect_to({:action=>"show", :id=>@group.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@group}
      else
        @error = @group
        format.html { render "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors}
      end
    end
  end

  def get_data
    @group = Cons::Group.where("id <> ?", "").with_group_message
    @group = @group.match_value("#{Cons::Group.table_name}.name",params[:name])
    @group = @group.match_value("#{Cons::Group.table_name}.code",params[:code])
    @group = @group.match_value("#{Cons::Group.table_name}.description",params[:description])

    @group,count = paginate(@group)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@group.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @group
      }
    end
  end

end
