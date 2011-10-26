class Irm::SearchLayoutsController < ApplicationController

  # GET /search_layouts/new
  # GET /search_layouts/new.xml
  def new
    @search_layout = Irm::SearchLayout.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @search_layout }
    end
  end

  # GET /search_layouts/1/edit
  def edit
    @search_layout = Irm::SearchLayout.find(params[:id])
  end

  # POST /search_layouts
  # POST /search_layouts.xml
  def create
    @search_layout = Irm::SearchLayout.new(params[:irm_search_layout])

    respond_to do |format|
      if @search_layout.valid?
        @search_layout.create_columns_from_str
        @search_layout.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @search_layout, :status => :created, :location => @search_layout }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @search_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /search_layouts/1
  # PUT /search_layouts/1.xml
  def update
    @search_layout = Irm::SearchLayout.find(params[:id])
    @search_layout.attributes = params[:irm_search_layout]
    respond_to do |format|
      if @search_layout.valid?
        @search_layout.create_columns_from_str
        @search_layout.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /search_layouts/1
  # DELETE /search_layouts/1.xml
  def destroy
    @search_layout = Irm::SearchLayout.find(params[:id])
    @search_layout.destroy

    respond_to do |format|
      format.html { redirect_to(search_layouts_url) }
      format.xml  { head :ok }
    end
  end

end
