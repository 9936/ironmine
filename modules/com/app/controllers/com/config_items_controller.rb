class Com::ConfigItemsController < ApplicationController
  # GET /com/config_items
  # GET /com/config_items.xml
  def index

  end

  # GET /com/config_items/1
  # GET /com/config_items/1.xml
  def show
    @config_item = Com::ConfigItem.select_all.with_config_class.with_managed_group.with_managed_person.find(params[:id])
    @config_item_attributes=Com::ConfigItemAttribute.select_all.with_attribute_name.query_by_config_item_id(@config_item[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_item }
    end
  end

  # GET /com/config_items/new
  # GET /com/config_items/new.xml
  def new
    @config_item = Com::ConfigItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_item }
    end
  end
  def get_dynamic_attributes
     @config_attributes=Com::ConfigAttribute.query_attributes_by_class_id(params[:config_class_id])
     @attribute_values={}
      if session[:config_item_attribute]
        @attribute_values=session[:config_item_attribute]
        session[:config_item_attribute]=nil
      elsif params[:config_item_id]
         Com::ConfigItemAttribute.query_by_config_item_id(params[:config_item_id]).each {|i| @attribute_values.merge!({i[:config_attribute_id]=>i[:value]})}
      end
     @config_attributes
  end

  # GET /com/config_items/1/edit
  def edit
    @config_item = Com::ConfigItem.find(params[:id])
    @config_item_attribute=Com::ConfigItemAttribute.query_by_config_item_id(@config_item.id)
  end

  # POST /com/config_items
  # POST /com/config_items.xml
  def create
    @config_item = Com::ConfigItem.new(params[:com_config_item])
    success_flag=[]
    success_flag<<@config_item.save
    @errors={}
    attributes={}
    Com::ConfigAttribute.query_attributes_by_class_id(@config_item[:config_class_id]).collect {|i| attributes.merge!(i[:id]=>{:name=>i[:name],:required_flag=>i[:required_flag]}) }
    if !success_flag.include?(false)
      config_item_attributes= params[:config_item_attribute]
      config_item_attributes.each do |config_item_attribute|
        attribute=Com::ConfigItemAttribute.new
        attribute.config_item_id=@config_item.id

        if(attributes["#{config_item_attribute[0]}"][:required_flag].eql?("Y")&&config_item_attribute[1].blank? )
          #验证失败
          #将用户的未保存的输入暂存到SESSION中
          session[:config_item_attribute]=params[:config_item_attribute]
          success_flag<<false
        else
          attribute.config_attribute_id=config_item_attribute[0]
          attribute.value=config_item_attribute[1]
        end

        success_flag<<attribute.save
        @errors.merge!({attributes["#{config_item_attribute[0]}"][:name]=>attribute.errors}) if attribute.errors.messages.present?
      end  if config_item_attributes
    else
      session[:config_item_attribute]=params[:config_item_attribute]
    end



    respond_to do |format|
      if !success_flag.include?(false)
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_item, :status => :created, :location => @config_item }
      elsif @config_item.id
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_item.errors }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_item.errors }
      end
    end
  end

  # PUT /com/config_items/1
  # PUT /com/config_items/1.xml
  def update
    @config_item = Com::ConfigItem.find(params[:id])
    success_flag=[]
    success_flag<<@config_item.update_attributes(params[:com_config_item])
    @errors={}
    attributes={}
    Com::ConfigAttribute.query_attributes_by_class_id(@config_item[:config_class_id]).collect {|i| attributes.merge!(i[:id]=>{:name=>i[:name],:required_flag=>i[:required_flag]}) }
    if !success_flag.include?(false)
        config_item_attributes= params[:config_item_attribute]
        #清空之前的属性值
        Com::ConfigItemAttribute.query_by_config_item_id(@config_item.id).delete_all
        config_item_attributes.each do |config_item_attribute|
           attribute=Com::ConfigItemAttribute.new
           attribute.config_item_id=@config_item.id
           if(attributes["#{config_item_attribute[0]}"][:required_flag].eql?("Y")&&config_item_attribute[1].blank? )
             #验证失败
             #将用户的未保存的输入暂存到SESSION中
             session[:config_item_attribute]=params[:config_item_attribute]
             success_flag<<false
           else
             attribute.config_attribute_id=config_item_attribute[0]
             attribute.value=config_item_attribute[1]
           end
           success_flag<<attribute.save
           @errors.merge!({attributes["#{config_item_attribute[0]}"][:name]=>attribute.errors}) if attribute.errors.messages.present?
        end  if config_item_attributes
    else
        session[:config_item_attribute]=params[:config_item_attribute]
    end
    respond_to do |format|
      if  !success_flag.include?(false)
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /com/config_items/1
  # DELETE /com/config_items/1.xml
  def destroy
    @config_item = Com::ConfigItem.find(params[:id])
    @config_item.destroy

    respond_to do |format|
      format.html { redirect_to(com_config_items_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    com_config_items_scope = Com::ConfigItem.select_all.with_config_class.with_managed_group.with_managed_person
    com_config_items_scope = com_config_items_scope.match_value("#{Com::ConfigClass.view_name}.name",params[:config_class_name])
    com_config_items_scope = com_config_items_scope.match_value("#{Icm::SupportGroup.multilingual_view_name}.name",params[:managed_group_name])
    com_config_items_scope = com_config_items_scope.match_value("#{Irm::Person.table_name}.full_name",params[:managed_person_name])
    com_config_items_scope = com_config_items_scope.match_value("#{Com::ConfigItem.table_name}.item_number",params[:item_number])
    com_config_items,count = paginate(com_config_items_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(com_config_items.to_grid_json([:item_number,:config_class_name,:managed_group_name,:managed_person_name,:last_checked_at],count))}
    end
  end
end
