class Irm::CustomAttributesController < ApplicationController
  def index
    @external_system = Irm::ExternalSystem.multilingual.enabled.find(params[:sid])
    unless params[:bo_id].present?
      @business_objects = Irm::BusinessObject.with_system_custom_flag.multilingual.order(:bo_table_name)
    end
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
    validate_result =  request.post? && @object_attribute.valid?

    if validate_result
      if @object_attribute.step > 1 && params[:pre_step]
        @object_attribute.step = @object_attribute.step.to_i - 1
        session[:irm_object_attribute][:step] = @object_attribute.step
      else
        if @object_attribute.step < 2
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
        format.html { redirect_to({:action=>"index",:sid => params[:sid]}, {:notice => t(:successfully_created)} ) }
        format.xml  { render :xml => @object_attribute, :status => :created, :location => @object_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @object_attribute = Irm::ObjectAttribute.multilingual.find(params[:attribute_id])
    @object_attribute.attributes = params[:irm_object_attribute] if request.put?&&params[:irm_object_attribute]
  end

  def update
    @object_attribute = Irm::ObjectAttribute.find(params[:attribute_id])

    respond_to do |format|
      if @object_attribute.update_attributes(params[:irm_object_attribute])
        format.html { redirect_to({:action=>"index",:sid=>params[:sid]}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :sid => params[:sid], :attribute_id => @object_attribute.id }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @object_attribute = Irm::ObjectAttribute.list_all.multilingual.find(params[:attribute_id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @object_attribute }
    end
  end

  def multilingual_edit
    @object_attribute = Irm::ObjectAttribute.find(params[:attribute_id])
  end

  def multilingual_update
    @object_attribute = Irm::ObjectAttribute.find(params[:attribute_id])
    @object_attribute.not_auto_mult=true
    respond_to do |format|
      if @object_attribute.update_attributes(params[:irm_object_attribute])
        format.html { redirect_to({:action=>"show",:attribute_id=> @object_attribute.id, :sid => params[:sid] }, :notice => 'Object attribute was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @object_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def enable_global_custom_fields
    @business_object = Irm::BusinessObject.multilingual.find(params[:bo_id])
  end

  def custom_fields_block
    if params[:model_params].present?&&params[:model_params].is_a?(String)&&params[:model_params].include?("{")
      params[:model_params] = eval(params[:model_params])
    end
    if params[:model_params].present? && params[:model_params].any?
      @model_object = params[:model_name].constantize.new(params[:model_params])
    else
      @model_object = params[:model_name].constantize.new
    end


    #同步默认值
    @model_object = @model_object.merge_default_values

    @request_url = request.url

    respond_to do |format|
      if params[:template_name].present?
        format.html {render params[:template_name] }
      else
        format.html
      end
    end
  end

  def get_data
    @datas = Irm::ObjectAttribute.where(:status_code => "ENABLED").multilingual.list_all.order_by_sequence.real_field.query_by_business_object(params[:bo_id]).where("#{Irm::ObjectAttribute.table_name}.external_system_id=? AND #{Irm::ObjectAttribute.table_name}.field_type = ?", params[:sid], "SYSTEM_CUX_FIELD")
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

  def switch_status
    @object_attribute = Irm::ObjectAttribute.find(params[:attribute_id])
    if @object_attribute.status_code.eql?(Irm::Constant::ENABLED)
      @object_attribute.status_code = Irm::Constant::DISABLED
    else
      @object_attribute.status_code = Irm::Constant::ENABLED
    end
    @object_attribute.not_auto_mult = true
    @object_attribute.save

    respond_to do |format|
      format.html { redirect_to({:action=>"index",:sid => params[:sid]}) }
      format.xml  { head :ok }
    end
  end

  def destroy
    business_object = Irm::ObjectAttribute.find(params[:attribute_id])
    business_object.destroy

    respond_to do |format|
      format.html { redirect_to(:action=>"index", :sid => params[:sid]) }
      format.xml  { head :ok }
    end
  end

  def switch_sequence
    sequence_str = params[:ordered_ids]
    if sequence_str.present?
      sequence = 1
      ids = sequence_str.split(",")
      attributes = Irm::ObjectAttribute.where(:id => ids).index_by(&:id)

      ids.each do |id|
        attribute = attributes[id]
        attribute.display_sequence = sequence
        attribute.not_auto_mult = true
        attribute.save
        sequence += 1
      end if attributes.any?
    end
    respond_to do |format|
      format.json  {render :json => {:success => true}}
    end
  end

end
