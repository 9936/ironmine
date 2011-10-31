class Irm::ObjectAttributesController < ApplicationController
  before_filter :setup_business_object
  # GET /object_attributes
  # GET /object_attributes.xml
  def index
    @object_attributes = Irm::ObjectAttribute.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @object_attributes }
    end
  end

  # GET /object_attributes/1
  # GET /object_attributes/1.xml
  def show
    @object_attribute = Irm::ObjectAttribute.list_all.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @object_attribute }
    end
  end

  # GET /object_attributes/new
  # GET /object_attributes/new.xml
  def new
    # 同步session和params中的数据
    if params[:irm_object_attribute]
      session[:irm_object_attribute].merge!(params[:irm_object_attribute].symbolize_keys)
    else
      session[:irm_object_attribute]={:business_object_id=>params[:bo_id],:step=>1}
    end

    # 将参数转化为对像
    @object_attribute = Irm::ObjectAttribute.new(session[:irm_object_attribute])

    # 设置当前step
    @object_attribute.step = @object_attribute.step.to_i if  @object_attribute.step.present?


    unless  @object_attribute.business_object_id.present?
      redirect_to({:controller=>"irm/business_objects",:action => "index"})
      return
    end

    # 对post数据进行有效性验证
    validate_result =  request.post?&&@object_attribute.valid?


    if validate_result
      if(@object_attribute.step>1&&params[:pre_step])
        @object_attribute.step = @object_attribute.step.to_i-1
        session[:irm_object_attribute][:step] = @object_attribute.step
      else
        if @object_attribute.step<2
          @object_attribute.step = @object_attribute.step.to_i+1
          session[:irm_object_attribute][:step] = @object_attribute.step
        end
      end
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @object_attribute }
    end
  end

  # GET /object_attributes/1/edit
  def edit
    @object_attribute = Irm::ObjectAttribute.multilingual.find(params[:id])
    @object_attribute.attributes = params[:irm_object_attribute] if request.put?&&params[:irm_object_attribute]
  end

  # POST /object_attributes
  # POST /object_attributes.xml
  def create
    session[:irm_object_attribute].merge!(params[:irm_object_attribute].symbolize_keys)
    @object_attribute = Irm::ObjectAttribute.new(session[:irm_object_attribute])

    respond_to do |format|
      if @object_attribute.save
         session[:irm_object_attribute] = nil
         format.html { redirect_to({:controller=>"irm/business_objects",:action=>"show",:id=>@business_object.id}, {:notice => t(:successfully_created)} ) }
         format.xml  { render :xml => @object_attribute, :status => :created, :location => @object_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /object_attributes/1
  # PUT /object_attributes/1.xml
  def update
    @object_attribute = Irm::ObjectAttribute.find(params[:id])

    respond_to do |format|
      if @object_attribute.update_attributes(params[:irm_object_attribute])
        format.html { redirect_to({:controller=>"irm/business_objects",:action=>"show",:id=>@business_object.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end


  def change_type
    @object_attribute = Irm::ObjectAttribute.multilingual.find(params[:id])
  end

  # DELETE /object_attributes/1
  # DELETE /object_attributes/1.xml
  def destroy
    @object_attribute = Irm::ObjectAttribute.find(params[:id])
    @object_attribute.destroy

    respond_to do |format|
      format.html { redirect_to(:controller=>"irm/business_objects",:action=>"show",:id=>@business_object.id) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @object_attribute = Irm::ObjectAttribute.find(params[:id])
  end

  def multilingual_update
    @object_attribute = Irm::ObjectAttribute.find(params[:id])
    @object_attribute.not_auto_mult=true
    respond_to do |format|
      if @object_attribute.update_attributes(params[:irm_object_attribute])
        format.html { redirect_to({:controller=>"irm/business_objects",:action=>"show",:id=>@business_object.id}, :notice => 'Object attribute was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end


  def new_model_attribute
    @object_attribute = Irm::ObjectAttribute.new(:business_object_id=>params[:bo_id],
                                                 :attribute_type=>"MODEL_ATTRIBUTE",
                                                 :field_type=>"STANDARD_FIELD")

  end


  def create_model_attribute
    @object_attribute = Irm::ObjectAttribute.new(params[:irm_object_attribute])

    respond_to do |format|
      if @object_attribute.save
        format.html { redirect_to({:controller=>"irm/business_objects",:action=>"show",:id=>@business_object.id}, {:notice => t(:successfully_created)} ) }
        format.xml  { render :xml => @object_attribute, :status => :created, :location => @object_attribute }
      else
        format.html { render :action => "new_model_attribute" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    object_attributes_scope = Irm::ObjectAttribute.custom_field.with_attribute_type(I18n.locale).with_relation_bo(I18n.locale).multilingual.query_by_business_object_code(@business_object.business_object_code).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttributesTl.table_name}.name",params[:name])
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.table_name}.attribute_name",params[:attribute_name])
    object_attributes,count = paginate(object_attributes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(object_attributes.to_grid_json([:name,
                                                                          :approval_page_field_flag,:filter_flag,
                                                                          :attribute_name,
                                                                          :attribute_type_name,
                                                                          :relation_bo_name,
                                                                          :relation_column,
                                                                          :data_length,:data_type,
                                                                          :relation_table_alias_name],count))}
    end
  end


  def get_standard_data
    object_attributes_scope = Irm::ObjectAttribute.standard_field.with_attribute_type(I18n.locale).with_relation_bo(I18n.locale).multilingual.query_by_business_object_code(@business_object.business_object_code).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttributesTl.table_name}.name",params[:name])
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.table_name}.attribute_name",params[:attribute_name])
    object_attributes,count = paginate(object_attributes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(object_attributes.to_grid_json([:name,
                                                                          :approval_page_field_flag,:filter_flag,
                                                                          :attribute_name,
                                                                          :attribute_type_name,
                                                                          :relation_bo_name,
                                                                          :relation_column,
                                                                          :data_length,:data_type,
                                                                          :relation_table_alias_name],count))}
    end
  end

  def relation_columns
    object_attributes_scope = Irm::ObjectAttribute.multilingual.table_column.query_by_business_object(params[:business_object_id]).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.view_name}.name",params[:name])

    object_attributes = object_attributes_scope.collect{|i| {:label=>i[:name], :value=>i.id,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>object_attributes.to_grid_json([:label,:value], object_attributes.count)}
    end
  end

  def selectable_columns
    object_attributes_scope = Irm::ObjectAttribute.multilingual.selectable_column.query_by_business_object_code(params[:business_object_code]).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.view_name}.name",params[:name])

    object_attributes = object_attributes_scope.collect{|i| {:label=>i.attribute_name, :value=>i.attribute_name,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>object_attributes.to_grid_json([:label,:value], object_attributes.count)}
    end
  end

  def all_columns
    object_attributes_scope = Irm::ObjectAttribute.multilingual.query_by_business_object_code(params[:business_object_code]).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.view_name}.name",params[:name])

    object_attributes = object_attributes_scope.collect{|i| {:label=>i[:name],:business_object_code=>i[:business_object_code],:business_object_id=>i.business_object_id, :value=>i.attribute_name,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>object_attributes.to_grid_json([:label,:value,:business_object_code,:business_object_id], object_attributes.count)}
    end
  end

  def updateable_columns
    object_attributes_scope = Irm::ObjectAttribute.multilingual.updateable_column.query_by_business_object_code(params[:business_object_code]).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.view_name}.name",params[:name])

    object_attributes = object_attributes_scope.collect{|i| {:label=>i.attribute_name, :value=>i.attribute_name,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>object_attributes.to_grid_json([:label,:value], object_attributes.count)}
    end
  end

  def person_columns
    object_attributes_scope = Irm::ObjectAttribute.multilingual.person_column.query_by_business_object_code(params[:business_object_code]).order(:attribute_name)
    object_attributes_scope = object_attributes_scope.match_value("#{Irm::ObjectAttribute.view_name}.name",params[:name])

    object_attributes = object_attributes_scope.collect{|i| {:name=>i[:name],:label=>i.attribute_name, :value=>i.attribute_name,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>object_attributes.to_grid_json([:label,:value,:name], object_attributes.count)}
    end
  end


  private
  def setup_business_object
    @business_object = Irm::BusinessObject.find(params[:bo_id]) if params[:bo_id]
    @business_object||= Irm::BusinessObject.first
  end
end
