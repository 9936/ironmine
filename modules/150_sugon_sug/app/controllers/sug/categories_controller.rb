class Sug::CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  def index
    @categorys = Sug::Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categorys }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Sug::Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Sug::Category.new
    if params[:parent_id].present?
      parent = Sug::Category.find(params[:parent_id])
      @category.parent_id = parent.id if parent.present?
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Sug::Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Sug::Category.new(params[:sug_category])

    respond_to do |format|
      if @category.save
        if @category.root?
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        else
          format.html { redirect_to({:action => "show", :id => @category.parent_id}, :notice => t(:successfully_created)) }
        end

        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Sug::Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:sug_category])
        if @category.root?
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        else
          format.html { redirect_to({:action => "show", :id => @category.parent_id}, :notice => t(:successfully_created)) }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Sug::Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    if params[:parent_id].present?
      parent = Sug::Category.find(params[:parent_id])
      categories, count = parent.children, parent.children.size
    else
      categories_scope = Sug::Category.roots
      categories_scope = categories_scope.match_value("#{Sug::Category.table_name}.code", params[:code])
      categories_scope = categories_scope.match_value("#{Sug::Category.table_name}.name", params[:name])
      categories,count = paginate(categories_scope)
    end

    respond_to do |format|
      format.html  {
        @datas = categories
        @count = count
      }
    end
  end

  def get_children
    category = Sug::Category.find(params[:id])
    unless category.leaf?
      categories = category.children
      categories = categories.collect{|i| {:label=>i[:name], :value=>i.id, :id=>i.id}}
    else
      []
    end
    respond_to do |format|
      format.json {render :json=> categories.to_grid_json([:label, :value], categories.count)}
    end
  end
end
