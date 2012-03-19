class Com::ConfigRelationMembersController < ApplicationController
  # GET /com/config_relation_members
  # GET /com/config_relation_members.xml
  def index

  end

  # GET /com/config_relation_members/1
  # GET /com/config_relation_members/1.xml
  def show
    @config_relation_member = Com::ConfigRelationMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_relation_member }
    end
  end

  # GET /com/config_relation_members/new
  # GET /com/config_relation_members/new.xml
  def new
    @config_relation_member = Com::ConfigRelationMember.new
    @config_relation_type_id=params[:config_relation_type_id]
    @config_relation_type_name=params[:config_relation_type_name]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_relation_member }
    end
  end

  # GET /com/config_relation_members/1/edit
  def edit
    @config_relation_member = Com::ConfigRelationMember.select_all.with_config_relation_type.find(params[:id])
  end

  # POST /com/config_relation_members
  # POST /com/config_relation_members.xml
  def create
    @config_relation_member = Com::ConfigRelationMember.new(params[:com_config_relation_member])
    @config_relation_type_id=params[:com_config_relation_member][:config_relation_type_id]
    @config_relation_type_name=Com::ConfigRelationType.multilingual.where("#{Com::ConfigRelationType.table_name}.id=?",@config_relation_type_id).first[:name]
    respond_to do |format|
      if @config_relation_member.save
        format.html { redirect_to({:controller=>"com/config_relation_types",:action => "show",:id=>@config_relation_member.config_relation_type_id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_relation_member, :status => :created, :location => @config_relation_member }
      else
        format.html { render :action => "new",:config_relation_type_id=>@config_relation_type_id,:config_relation_type_name=>@config_relation_type_name }
        format.xml  { render :xml => @config_relation_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /com/config_relation_members/1
  # PUT /com/config_relation_members/1.xml
  def update
    @config_relation_member = Com::ConfigRelationMember.find(params[:id])

    respond_to do |format|
      if @config_relation_member.update_attributes(params[:com_config_relation_member])
        format.html { redirect_to({:controller=>"com/config_relation_types",:action => "show",:id=>@config_relation_member.config_relation_type_id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_relation_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /com/config_relation_members/1
  # DELETE /com/config_relation_members/1.xml
  def destroy
    @config_relation_member = Com::ConfigRelationMember.find(params[:id])
    @config_relation_member.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"com/config_relation_types",:action => "show",:id=>@config_relation_member.config_relation_type_id}) }
      format.xml  { head :ok }
    end
  end


  def get_data
    com_config_relation_members_scope = Com::ConfigRelationMember.select_all.with_config_relation_type.with_config_relation_class
    com_config_relation_members_scope = com_config_relation_members_scope.match_value("#{Com::ConfigRelationMember.table_name}.config_relation_type_id",params[:config_relation_type_id])
    com_config_relation_members_scope = com_config_relation_members_scope.match_value("#{Com::ConfigClass.view_name}.name",params[:config_class_name])
    com_config_relation_members,count = paginate(com_config_relation_members_scope)
    respond_to do |format|
      format.html {
        @datas = com_config_relation_members
        @count = count
        render_html_data_table
      }
      format.json {render :json=>to_jsonp(com_config_relation_members.to_grid_json([:type_name,:config_class_name],count))}
    end
  end
end
