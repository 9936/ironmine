<% plural_table_name_str = plural_table_name.split("_")[1..-1].join("_") %>
<% singular_table_name_str = singular_table_name.split("_")[1..-1].join("_") %>

class <%= controller_class_name %>Controller < ApplicationController
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  def index
    @<%= plural_table_name_str %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= plural_table_name_str %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  def show
    @<%= singular_table_name_str %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= singular_table_name_str %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  def new
    @<%= singular_table_name_str %> = <%= orm_class.build(class_name) %>

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= singular_table_name_str %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name_str %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  def create
    @<%= singular_table_name_str %> = <%= orm_class.build(class_name, "params[:#{singular_table_name_str}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @<%= singular_table_name_str %>, :status => :created, :location => @<%= singular_table_name_str %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  def update
    @<%= singular_table_name_str %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name_str}]") %>
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.xml
  def destroy
    @<%= singular_table_name_str %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= index_helper %>_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @<%= singular_table_name_str %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def multilingual_update
    @<%= singular_table_name_str %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= singular_table_name_str %>.not_auto_mult=true
    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name_str}]") %>
        format.html { redirect_to({:action => "show"}, :notice => '<%= human_name %> was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    <%= plural_table_name_str %>_scope = <%= class_name %>.multilingual
    <%= plural_table_name_str %>_scope = <%= plural_table_name_str %>_scope.match_value("\#{<%= orm_class %>.table_name}.name",params[:name])
    <%= plural_table_name_str %>,count = paginate(<%= plural_table_name_str %>_scope)
    respond_to do |format|
      format.html  {
        @datas = <%= plural_table_name_str %>
        @count = count
      }
      format.json {render :json=>to_jsonp(<%= plural_table_name_str %>.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
