class Cons::ModuleController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @module }
    end
  end

  def new
    @module = Cons::Module.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @module }
    end
  end

  def create
    @module = Cons::Module.new(params[:cons_module])
    puts params[:cons_module].inspect

    respond_to do |format|
      if @module.save
        format.html { redirect_to({:action=>"show",:id=>@module.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @module, :status => :created, :location => @module }
        format.json { render :json=>@module}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @module.errors, :status => :unprocessable_entity }
        format.json  { render :json => @module.errors}
      end
    end
  end

  def show
    @module = Cons::Module.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@module}
      format.html
    end
  end

  def edit
    @module = Cons::Module.find(params[:id])
  end

  def update
    @module = Cons::Module.find(params[:id])

    respond_to do |format|
      if @module.update_attributes(params[:cons_module])
        format.html { redirect_to({:action=>"show", :id=>@module.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@module}
      else
        @error = @module
        format.html { render "edit" }
        format.xml  { render :xml => @module.errors, :status => :unprocessable_entity }
        format.json  { render :json => @module.errors}
      end
    end
  end

  def get_data
    @module = Cons::Module.where("id <> ?", "").with_module_message
    @module = @module.match_value("#{Cons::Module.table_name}.name",params[:name])
    @module = @module.match_value("#{Cons::Module.table_name}.code",params[:code])
    @module = @module.match_value("#{Cons::Module.table_name}.description",params[:description])

    @module,count = paginate(@module)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@module.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @module
      }
    end
  end

end
