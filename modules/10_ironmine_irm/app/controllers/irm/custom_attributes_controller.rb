class Irm::CustomAttributesController < ApplicationController
  def index
    @external_system = Irm::ExternalSystem.multilingual.enabled.find(params[:sid])
    @business_objects = Irm::BusinessObject.with_custom_flag.multilingual.order(:bo_table_name)
  end

  def new
    # 同步session和params中的数据
    if params[:irm_object_attribute]
      session[:irm_object_attribute].merge!(params[:irm_object_attribute].symbolize_keys)
    else
      session[:irm_object_attribute]={:business_object_id=>params[:bo_id],:step=>1,:field_type=>"SYSTEM_CUX_FIELD",:external_system_id => params[:sid]}
    end

    # 将参数转化为对像
    @object_attribute = Irm::ObjectAttribute.new(session[:irm_object_attribute])

    # 设置当前step
    @object_attribute.step = @object_attribute.step.to_i if  @object_attribute.step.present?

    @business_object = Irm::BusinessObject.find(params[:bo_id]) if params[:bo_id]
    @business_object||= Irm::BusinessObject.first

    unless  @object_attribute.business_object_id.present?
      redirect_to({:action => "show", :id=>params[:bo_id], :sid => params[:sid]})
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

  def create
    session[:irm_object_attribute].merge!(params[:irm_object_attribute].symbolize_keys)
    @object_attribute = Irm::ObjectAttribute.new(session[:irm_object_attribute])

    respond_to do |format|
      if @object_attribute.save
        session[:irm_object_attribute] = nil
        format.html { redirect_to({:action=>"show",:id=>params[:bo_id],:sid => params[:sid]}, {:notice => t(:successfully_created)} ) }
        format.xml  { render :xml => @object_attribute, :status => :created, :location => @object_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def update

  end

  def show
    @business_object = Irm::BusinessObject.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business_object }
    end
  end

  def get_data
    business_objects_scope = Irm::BusinessObject.with_custom_flag.multilingual.order(:bo_table_name)
    business_objects_scope = business_objects_scope.match_value("#{Irm::BusinessObjectsTl.table_name}.name",params[:name])
    business_objects_scope = business_objects_scope.match_value("#{Irm::BusinessObject.table_name}.bo_table_name",params[:bo_table_name])
    business_objects_scope = business_objects_scope.match_value("#{Irm::BusinessObject.table_name}.bo_model_name",params[:bo_model_name])
    business_objects_scope = business_objects_scope.match_value("#{Irm::BusinessObject.table_name}.business_object_code",params[:business_object_code])
    business_objects,count = paginate(business_objects_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(business_objects.to_grid_json([:business_object_code,:auto_generate_flag,:bo_table_name,:bo_model_name,:multilingual_flag,:name],count))}
      format.html {
        @count = count
        @datas = business_objects
      }
    end
  end

  #启用的全局自定义字段
  def active
    object_attribute_system = Irm::ObjectAttributeSystem.new(:external_system_id => params[:sid], :object_attribute_id => params[:attribute_id])
    respond_to do |format|
      if object_attribute_system.save
        format.html { redirect_to({:action=>"index",:sid => params[:sid]}, {:notice => t(:successfully_created)} ) }
      else
        format.html { render :action => "show", :sid => params[:sid], :id => params[:attribute_id] }
        format.xml  { render :xml => object_attribute_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  def disable
    object_attribute_system = Irm::ObjectAttributeSystem.where(:external_system_id => params[:sid], :object_attribute_id => params[:attribute_id]).first
    object_attribute_system.destroy
    respond_to do |format|
        format.html { redirect_to({:action=>"index",:sid => params[:sid]}) }
    end
  end

end
