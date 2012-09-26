class Irm::LookupValuesController < ApplicationController

  def index
    redirect_to(:controller=>"irm/lookup_types",:action=>"index")
    #if !params[:lookup_type].blank?
    #  @lookup_type = Irm::LookupType.multilingual.query_wrap_info(I18n::locale).query_by_lookup_type(params[:lookup_type]).first
    #else
    #  @lookup_type= Irm::LookupType.new
    #end
    #
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @mail_templates }
    #end
  end

  def new
    @lookup_value = Irm::LookupValue.new(:lookup_type=>params[:lookup_type])
  end

  def show
    @lookup_value = Irm::LookupValue.multilingual.find(params[:id])

    @lookup_type = Irm::LookupType.multilingual.query_by_lookup_type(@lookup_value.lookup_type).first
  end

  # multi language
  def multilingual_edit
    @lookup_value = Irm::LookupValue.find(params[:id])
  end

  def multilingual_update
    @lookup_value = Irm::LookupValue.find(params[:id])
    @lookup_value.not_auto_mult=true
    respond_to do |format|
      if @lookup_value.update_attributes(params[:irm_lookup_type])
        format.html { render({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end


  def edit
    @lookup_value = Irm::LookupValue.multilingual.find(params[:id])
  end


  def create
    @lookup_value = Irm::LookupValue.new(params[:irm_lookup_value])

    respond_to do |format|
      if @lookup_value.save
        format.html {
          lookup_type = Irm::LookupType.multilingual.query_by_lookup_type(@lookup_value.lookup_type).first
          redirect_to({:controller => "irm/lookup_types",:action=>"show",:id=>lookup_type.id})
        }
        format.xml  { render :xml => @lookup_value, :status => :created, :location => @lookup_value }
      else
        format.html { render "new" }
        format.xml  { render :xml => @lookup_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @lookup_value = Irm::LookupValue.find(params[:id])

    respond_to do |format|
      if @lookup_value.update_attributes(params[:irm_lookup_value])
        format.html {
          lookup_type = Irm::LookupType.multilingual.query_by_lookup_type(@lookup_value.lookup_type).first
          redirect_to({:controller => "irm/lookup_types",:action=>"show",:id=>lookup_type.id})
        }
        format.xml  { head :ok }
      else
        format.html { render "edit" }
        format.xml  { render :xml => @lookup_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_lookup_values
    lookup_type=params[:lookup_type]
    @lookup_values = Irm::LookupValue.order_by_sequence.query_by_lookup_type(lookup_type).query_wrap_info(I18n.locale).multilingual
    @lookup_values = @lookup_values.match_value("#{Irm::LookupValue.table_name}.lookup_code",params[:lookup_code])
    @lookup_values = @lookup_values.match_value("#{Irm::LookupValuesTl.table_name}.meaning",params[:meaning])
    @lookup_values = @lookup_values.match_value("#{Irm::LookupValuesTl.table_name}.description",params[:description])
    @lookup_values,count = paginate(@lookup_values)
    respond_to do |format|
      format.json  {render :json =>to_jsonp(@lookup_values.to_grid_json(['R',:lookup_code,:lookup_type,:meaning,:description,:start_date_active,:end_date_active,:status_meaning],
                                                                               count)) }
      format.html  {
        @count= count
        @datas = @lookup_values
      }

    end
  end

  def select_lookup_type
    if !params[:lookup_type].blank?
      @lookup_type = Irm::LookupType.multilingual.query_wrap_info(I18n::locale).
                          query_by_lookup_type(params[:lookup_type]).first
    else
      @lookup_type= Irm::LookupType.new
    end
    render :action => "index"
  end


  def up_value
    current_value = Irm::LookupValue.find(params[:id])
    #查找出lookup_type
    lookup_type = Irm::LookupType.where(:lookup_type => current_value.lookup_type).first
    if current_value.present?
      pre_value = current_value.pre_value
      tmp_sequence = current_value.sequence
      current_value.sequence = pre_value.sequence
      pre_value.sequence = tmp_sequence
      current_value.not_auto_mult = pre_value.not_auto_mult = true
      current_value.save
      pre_value.save
    end
    redirect_to({:controller => "irm/lookup_types",:action => "show",:id => lookup_type.id })
  end

  def down_value
    current_value = Irm::LookupValue.find(params[:id])
    lookup_type = Irm::LookupType.where(:lookup_type => current_value.lookup_type).first
    if current_value.present?
      next_value = current_value.next_value
      tmp_sequence = current_value.sequence
      current_value.sequence = next_value.sequence
      next_value.sequence = tmp_sequence
      current_value.not_auto_mult = next_value.not_auto_mult = true
      current_value.save
      next_value.save
    end
    redirect_to({:controller => "irm/lookup_types",:action => "show",:id => lookup_type.id })
  end

end
