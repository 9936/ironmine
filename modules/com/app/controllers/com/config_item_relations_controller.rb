class Com::ConfigItemRelationsController < ApplicationController
  # GET /com/config_item_relations
  # GET /com/config_item_relations.xml
  def index
    @config_item_relations = Com::ConfigItemRelation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @config_item_relations }
    end
  end

  # GET /com/config_item_relations/1
  # GET /com/config_item_relations/1.xml
  def show
    @config_item_relation = Com::ConfigItemRelation.list_all.find(params[:id])
    @config_item=Com::ConfigItem.find(@config_item_relation[:config_item_id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_item_relation }
    end
  end

  # GET /com/config_item_relations/new
  # GET /com/config_item_relations/new.xml
  def new
    @config_item_relation = Com::ConfigItemRelation.new
    @config_item=Com::ConfigItem.find(params[:config_item_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_item_relation }
    end
  end

  # GET /com/config_item_relations/1/edit
  def edit
    @config_item_relation = Com::ConfigItemRelation.list_all.find(params[:id])
    @config_item=Com::ConfigItem.find(@config_item_relation[:config_item_id])
  end

  # POST /com/config_item_relations
  # POST /com/config_item_relations.xml
  def create
    @config_item_relation = Com::ConfigItemRelation.new(params[:com_config_item_relation])

    respond_to do |format|
      if @config_item_relation.save
        format.html { redirect_to({:controller=>"com/config_items",:action => "show",:id=>@config_item_relation[:config_item_id]}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_item_relation, :status => :created, :location => @config_item_relation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_item_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /com/config_item_relations/1
  # PUT /com/config_item_relations/1.xml
  def update
    @config_item_relation = Com::ConfigItemRelation.find(params[:id])

    respond_to do |format|
      if @config_item_relation.update_attributes(params[:com_config_item_relation])
        format.html { redirect_to({:controller=>"com/config_items",:action => "show",:id=>@config_item_relation[:config_item_id]},  :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_item_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /com/config_item_relations/1
  # DELETE /com/config_item_relations/1.xml
  def destroy
    @config_item_relation = Com::ConfigItemRelation.find(params[:id])
    @config_item_relation.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"com/config_items",:action => "show",:id=>@config_item_relation[:config_item_id]}) }
      format.xml  { head :ok }
    end
  end


  def get_data
    com_config_item_relations_scope = Com::ConfigItemRelation.query_by_config_item_id(params[:config_item_id]).list_all
    com_config_item_relations_scope = com_config_item_relations_scope.match_value("#{Com::ConfigItemRelation.table_name}.description",params[:description])
    com_config_item_relations_scope = com_config_item_relations_scope.match_value("#{Com::ConfigRelationType.view_name}.name",params[:relation_type_name])
    com_config_item_relations_scope = com_config_item_relations_scope.match_value("cci2.item_number",params[:relation_item_number])
    com_config_item_relations,count = paginate(com_config_item_relations_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(com_config_item_relations.to_grid_json([:item_number,:description,:relation_type_name,:relation_item_number],count))}
    end
  end
end
