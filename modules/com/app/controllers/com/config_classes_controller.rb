class Com::ConfigClassesController < ApplicationController
  # GET /config_classes
  # GET /config_classes.xml
  def index
    all_config_classes = Com::ConfigClass.query_parent(I18n.locale).multilingual
    grouped_config_classes = all_config_classes.collect{|i| [i.id,i.parent_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    config_classes = {}
    all_config_classes.each do |ac|
      config_classes.merge!({ac.id=>ac})
    end
    @leveled_config_classes = []
    proc = Proc.new{|parent_id,level|
      if grouped_config_classes[parent_id.to_s]&&grouped_config_classes[parent_id.to_s].any?

        grouped_config_classes[parent_id.to_s].each do |o|
          config_classes[o[0]].level = level
          @leveled_config_classes << config_classes[o[0]]
          proc.call(config_classes[o[0]].id,level+1)
        end
      end
    }
    grouped_config_classes["blank"].each do |go|
      config_classes[go[0]].level = 1
      @leveled_config_classes << config_classes[go[0]]
      proc.call(config_classes[go[0]].id,2)
    end

    unless params[:mode].present?
      params[:mode] = cookies['config_class_view']
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @leveled_config_classes }
    end
  end

  # GET /config_classes/1
  # GET /config_classes/1.xml
  def show
    @config_class = Com::ConfigClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_class }
    end
  end

  # GET /config_classes/new
  # GET /config_classes/new.xml
  def new
    @config_class = Com::ConfigClass.new(:leaf_flag => Irm::Constant::SYS_NO)
    if params[:parent_id].present?
      @config_class.parent_id = params[:parent_id]
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_class }
    end
  end

  # GET /config_classes/1/edit
  def edit
    @config_class = Com::ConfigClass.multilingual.find(params[:id])
  end

  # POST /config_classes
  # POST /config_classes.xml
  def create
    @config_class = Com::ConfigClass.new(params[:com_config_class])

    respond_to do |format|
      if @config_class.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_class, :status => :created, :location => @config_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /config_classes/1
  # PUT /config_classes/1.xml
  def update
    @config_class = Com::ConfigClass.find(params[:id])

    respond_to do |format|
      if @config_class.update_attributes(params[:com_config_class])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /config_classes/1
  # DELETE /config_classes/1.xml
  def destroy
    @config_class = Com::ConfigClass.find(params[:id])
    @config_class.destroy

    respond_to do |format|
      format.html { redirect_to(config_classes_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @config_class = Com::ConfigClass.find(params[:id])
  end

  def multilingual_update
    @config_class = Com::ConfigClass.find(params[:id])
    @config_class.not_auto_mult=true
    respond_to do |format|
      if @config_class.update_attributes(params[:com_config_class])
        format.html { redirect_to({:action => "show"}, :notice => 'Config class was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    config_classes_scope = Com::ConfigClass.multilingual
    config_classes_scope = config_classes_scope.match_value("#{Com::ConfigClass.table_name}.code",params[:code])
    config_classes_scope = config_classes_scope.match_value("#{Com::ConfigClassesTl.table_name}.name",params[:name])
    config_classes,count = paginate(config_classes_scope)
    #config_classes = flag_to_img_icon(config_classes)
    respond_to do |format|
      format.json {render :json=>to_jsonp(config_classes.to_grid_json([:code,:name,:description,:status_meaning,:leaf_flag],count))}
    end
  end

  private
  def flag_to_img_icon(config_classes)
    config_classes.each do |c|
      c.leaf_flag = check_img(c.leaf_flag)
    end
    config_classes
  end
  def check_img(value = "")
     content_tag(:img, "",{:class => "checkImg", :width => "21", :height => "14",
                           :src => theme_image_path("#{value}.png") }) if !value.blank?
  end
end
