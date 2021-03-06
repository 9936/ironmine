class Irm::FiltersController < ApplicationController
  skip_before_filter :prepare_application
  before_filter :filters_menu  , :except => [:operator_value]
  # Date.today.prev_month.at_beginning_of_month
  # Date.today.at_beginning_of_week-1

  def index
    redirect_to({:action => "new"})
  end

  def show
    @rule_filter = Irm::RuleFilter.multilingual.find(params[:id])
    respond_to do |format|
      format.html{render :layout => "application_full"}
    end
  end



  def multilingual_edit
    @rule_filter = Irm::RuleFilter.find(params[:id])
    respond_to do |format|
      format.html{render :layout => "application_full"}
    end
  end

  def multilingual_update
    @rule_filter = Irm::RuleFilter.find(params[:id])
    @rule_filter.not_auto_mult = true
    respond_to do |format|
      if params[:irm_rule_filter][:rule_filters_tls_attributes]
        params[:irm_rule_filter][:rule_filters_tls_attributes].each do |k, v|
          rule_filter_tl = Irm::RuleFiltersTl.find(v[:id])
          rule_filter_tl.update_attributes(v)
        end
        format.html { redirect_to({:action=>"show"}, :notice => 'Role was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @rule_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @rule_filter = Irm::RuleFilter.new({:filter_type=>"PAGE_FILTER",:bo_code=>params[:bc],:source_code=>params[:sc]})
    0.upto 4 do |index|
      @rule_filter.rule_filter_criterions.build({:seq_num=>index+1})
    end

    respond_to do |format|
      format.html{render :layout => "application_full" }
    end
  end

  def create
    @rule_filter = Irm::RuleFilter.new(params[:irm_rule_filter])
    params[:sc] = @rule_filter.source_code
    params[:bc] = @rule_filter.bo_code
    @rule_filter.own_id = Irm::Person.current.id

    respond_to do |format|
      if @rule_filter.save
        format.html {redirect_back}
        format.xml  {redirect_back}
      else
        format.html { render "new", :layout => "application_full" }
        format.xml  { render :xml => @view_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @rule_filter = Irm::RuleFilter.multilingual.find(params[:id])
    respond_to do |format|
      format.html{render :layout => "application_full" }
    end
  end

  def update
    @rule_filter = Irm::RuleFilter.find(params[:id])

    respond_to do |format|
      if @rule_filter.update_attributes(params[:irm_rule_filter])
        format.html {redirect_back}
        format.xml  {redirect_back}
      else
        format.html { render "edit", :layout => "application_full" }
        format.xml  { render :xml => @action.errors, :status => :unprocessable_entity }
      end
    end
  end

  def operator_value
    @object_attribute = Irm::ObjectAttribute.query(params[:attribute_id]).first
    @rule_filter_criterion = Irm::RuleFilterCriterion.new(:seq_num=>params[:seq_num])
    num = (params[:seq_num]||1).to_i-1
    filter_name = params[:filter_name]|| "irm"
    @named_form = "#{filter_name}_rule_filter[rule_filter_criterions_attributes][#{num}]"
  end


  private

  def filters_menu
    if params[:pca]
      controller_action = params[:pca].split("-")
      function_group_setup(controller_action[0],controller_action[1])
    end
  end

  def redirect_back
    redirect_back_or_default
  end

end
