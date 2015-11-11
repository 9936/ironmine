class Cons::IndustryController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @industry }
    end
  end

  def new
    @industry = Cons::Industry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @industry }
    end
  end

  def create
    @industry = Cons::Industry.new(params[:cons_industry])
    puts params[:cons_industry].inspect

    respond_to do |format|
      if @industry.save
        format.html { redirect_to({:action=>"show",:id=>@industry.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @industry, :status => :created, :location => @industry }
        format.json { render :json=>@industry}
        # end

      else
        format.html { render "new" }
        format.xml  { render :xml => @industry.errors, :status => :unprocessable_entity }
        format.json  { render :json => @industry.errors}
      end
    end
  end

  def show
    @industry = Cons::Industry.find(params[:id])
    respond_to do |format|
      format.json {render :json=>@industry}
      format.html
    end
  end

  def edit
    @industry = Cons::Industry.find(params[:id])
  end

  def update
    @industry = Cons::Industry.find(params[:id])

    respond_to do |format|
      if @industry.update_attributes(params[:cons_industry])
        format.html { redirect_to({:action=>"show", :id=>@industry.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@industry}
      else
        @error = @industry
        format.html { render "edit" }
        format.xml  { render :xml => @industry.errors, :status => :unprocessable_entity }
        format.json  { render :json => @industry.errors}
      end
    end
  end

  def get_data
    @industry = Cons::Industry.where("id <> ?", "").with_industry_message
    @industry = @industry.match_value("#{Cons::Industry.table_name}.name",params[:name])
    @industry = @industry.match_value("#{Cons::Industry.table_name}.code",params[:code])
    @industry = @industry.match_value("#{Cons::Industry.table_name}.description",params[:description])

    @industry,count = paginate(@industry)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@industry.to_grid_json([:name,:code,:description], count))}
      format.html {
        @count = count
        @datas = @industry
      }
    end
  end

end
