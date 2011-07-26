class Irm::CardsController < ApplicationController
  def index

  end

  def new
    session[:irm_card] = nil unless params[:step].present?

    if params[:irm_card]
      session[:irm_card].merge!(params[:irm_card])
      session[:irm_card][:step] = params[:step].to_i - 1
    elsif params[:step].present? && params[:step].to_i == 1
      session[:irm_card][:step] = params[:step].to_i - 1
    else
      session[:irm_card]={}
      session[:irm_rule_filter] = nil
      session[:irm_card][:step] = 1
    end
    @card = Irm::Card.new(session[:irm_card])

    if params[:step].present? && @card.valid?
      @card.step = @card.step.to_i+1
      session[:irm_card][:step] = @card.step
    end
    if @card.step.eql?(2)
      if session[:irm_rule_filter]
        @rule_filter =Irm::RuleFilter.new(session[:irm_rule_filter])
      else
        @rule_filter =Irm::RuleFilter.create_for_source(@card.bo_code,Irm::Card.name,0)
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @card }
    end
  end

  def create
    session[:irm_card].merge!(params[:irm_card])
    session[:irm_rule_filter] = params[:irm_rule_filter]
    @card = Irm::Card.new(session[:irm_card])
    @rule_filter = Irm::RuleFilter.new(session[:irm_rule_filter])

    respond_to do |format|
      if @card.valid?&&@rule_filter.valid?
         @card.save
         @rule_filter.source_id = @card.id
         @rule_filter.source_type = Irm::Card.name
         @rule_filter.save
         session[:irm_rule_filter] = nil
         session[:irm_card] = nil
        format.html { redirect_to({:action => "show",:id=>@card.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @card, :status => :created, :location => @card }
      else
        format.html { render :action => "new", :step => "2" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @card = Irm::Card.multilingual.find(params[:id])
  end

  def update
    @card = Irm::Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:irm_card])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    card_scope = Irm::Card.multilingual.enabled.status_meaning
    cards, count = paginate(card_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(cards.to_grid_json(
                                              [:card_code, :name,:description, :background_color, :font_color,:status_meaning,:system_flag],
                                              count))}
    end
  end

  def show
    @card = Irm::Card.multilingual.find(params[:id])
    @rule_filter = Irm::RuleFilter.query_by_source(Irm::Card.name,@card.id).first
  end

  def edit_rule
    @card = Irm::Card.multilingual.find(params[:id])
    @rule_filter = Irm::RuleFilter.query_by_source(Irm::Card.name,@card.id).first
    @return_url= params[:return_url] || request.env['HTTP_REFERER']
  end

  def update_rule
    @card = Irm::Card.multilingual.find(params[:id])
    @rule_filter = Irm::RuleFilter.query_by_source(Irm::Card.name,@card.id).first
    respond_to do |format|
      if @rule_filter.update_attributes(params[:irm_rule_filter])
        if params[:return_url]
          format.html { redirect_to(params[:return_url], :notice => t(:successfully_updated)) }
          format.xml  { head :ok }
        else
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rule_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  def multilingual_edit
    @card = Irm::Card.find(params[:id])
  end

  def multilingual_update
    @card = Irm::Card.find(params[:id])
    @card.not_auto_mult=true
    respond_to do |format|
      if @card.update_attributes(params[:irm_card])
        format.html { render({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end
end