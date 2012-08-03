class Com::ConfigItemsController < ApplicationController
  layout "bootstrap_application_full"
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

    params[:config_item_attribute].each do |config_item_attribute|
      @config_item.config_item_attributes.build(:config_attribute_id=>config_item_attribute[0],:value=>config_item_attribute[1])
    end  if params[:config_item_attribute]

    respond_to do |format|
      if @config_item.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_item, :status => :created, :location => @config_item }
        format.json { render :json=>@config_item}
      else

        format.html {
          session[:config_item_attribute]=params[:config_item_attribute]
          render :action => "new"
        }
        format.xml  { render :xml => @config_item.errors }
        format.json { render :json=>@config_item.errors}
      end
    end
  end

  # PUT /com/config_items/1
  # PUT /com/config_items/1.xml
  def update
    @config_item = Com::ConfigItem.find(params[:id])

    Com::ConfigItemAttribute.query_by_config_item_id(@config_item.id).delete_all
    params[:config_item_attribute].each do |config_item_attribute|
      @config_item.config_item_attributes.build(:config_attribute_id=>config_item_attribute[0],:value=>config_item_attribute[1])
    end  if params[:config_item_attribute]

    respond_to do |format|
      if  @config_item.update_attributes(params[:com_config_item])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@config_item}
      else

        format.html {
          session[:config_item_attribute]=params[:config_item_attribute]
          render :action => "edit"
        }
        format.xml  { render :xml => @config_item.errors, :status => :unprocessable_entity }
        format.json { render :json=>@config_item.errors}
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
    com_config_items_scope = com_config_items_scope.match_value("#{Com::ConfigItem.table_name}.config_class_id",params[:config_class_id]) if params[:config_class_id] && params[:config_class_id].present? && params[:config_class_id] != "root"
    com_config_items_scope = com_config_items_scope.match_value("#{Icm::SupportGroup.multilingual_view_name}.name",params[:managed_group_name])
    com_config_items_scope = com_config_items_scope.match_value("#{Irm::Person.table_name}.full_name",params[:managed_person_name])
    com_config_items_scope = com_config_items_scope.match_value("#{Com::ConfigItem.table_name}.item_number",params[:item_number])
    com_config_items,@count = paginate(com_config_items_scope)


    respond_to do |format|
      format.html {
        @merged_config_items=[]
            if params[:config_class_id].present?&&params[:config_class_id] != "root"
               #取出当前类别所有的需要显示的属性
               @class_attributes=Com::ConfigAttribute.query_attributes_by_class_id(params[:config_class_id]).where(:display_flag=>'Y')
               #取出当前这一页数据对应的所有的配置项扩展属性
               config_item_ids=com_config_items.collect {|i| i.id}
               config_item_attributes=Com::ConfigItemAttribute.where(:config_item_id=>config_item_ids)
               #将数据构造成grouped_config_item_attributes[配置项ID][扩展属性ID]的访问形式
               grouped_config_item_attributes=config_item_attributes.group_by {|i| i[:config_item_id]}
               grouped_config_item_attributes.each do |config_item_id,ci_attributes|
                 attributes_values_hash={}
                 ci_attributes.each {|cia| attributes_values_hash.merge!({cia[:config_attribute_id]=>cia[:value]})}
                 grouped_config_item_attributes[config_item_id]=attributes_values_hash
               end if grouped_config_item_attributes.present?
               #遍历每条配置项数据，给每条数据追加扩展属性字段
               com_config_items.each do |config_item|
                 merged_config_item=config_item.attributes.symbolize_keys
                 @class_attributes.each do |class_attribute|
                   merged_config_item.merge!({class_attribute[:id].to_sym=>grouped_config_item_attributes[config_item.id][class_attribute[:id]]}) if grouped_config_item_attributes[config_item.id].present?
                 end
                  @merged_config_items<<merged_config_item
               end if grouped_config_item_attributes.present?
            end
            @merged_config_items=com_config_items if @merged_config_items.blank?
      }
      format.json {
        com_config_items=com_config_items.includes(:config_item_attributes)
        com_config_items.each do |config_item|
              config_item[:config_item_attributes]=config_item.config_item_attributes.collect {|i| i.attributes}
        end
        render :json=>to_jsonp(com_config_items.to_grid_json([:item_number,:config_class_id,:managed_group_id,:managed_person_id,:last_checked_at,:status_code,:config_item_attributes],@count))
      }
    end
  end
end
