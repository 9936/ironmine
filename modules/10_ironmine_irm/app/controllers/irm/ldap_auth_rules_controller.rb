class Irm::LdapAuthRulesController < ApplicationController
  # GET /ldap_auth_rules
  # GET /ldap_auth_rules.xml
  def index
    @ldap_auth_rules = Irm::LdapAuthRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ldap_auth_rules }
    end
  end

  # GET /ldap_auth_rules/1
  # GET /ldap_auth_rules/1.xml
  def show
    @ldap_auth_rule = Irm::LdapAuthRule.with_person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ldap_auth_rule }
    end
  end

  # GET /ldap_auth_rules/new
  # GET /ldap_auth_rules/new.xml
  def new
    @ldap_auth_rule = Irm::LdapAuthRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ldap_auth_rule }
    end
  end

  # GET /ldap_auth_rules/1/edit
  def edit
    @ldap_auth_rule = Irm::LdapAuthRule.find(params[:id])
  end

  # POST /ldap_auth_rules
  # POST /ldap_auth_rules.xml
  def create
    @ldap_auth_rule = Irm::LdapAuthRule.new(params[:irm_ldap_auth_rule])
    @ldap_auth_rule.ldap_auth_header_id = params[:ah_id]
    respond_to do |format|
      if @ldap_auth_rule.save
        format.html { redirect_to({:controller => "irm/ldap_auth_headers",:action=>"show",:id=>params[:ah_id]}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @ldap_auth_rule, :status => :created, :location => @ldap_auth_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ldap_auth_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ldap_auth_rules/1
  # PUT /ldap_auth_rules/1.xml
  def update
    @ldap_auth_rule = Irm::LdapAuthRule.find(params[:id])

    respond_to do |format|
      if @ldap_auth_rule.update_attributes(params[:irm_ldap_auth_rule])
        format.html { redirect_to({:controller => "irm/ldap_auth_headers",:action=>"show",:id=>params[:ah_id]}, :notice => t(:successfully_created)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ldap_auth_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ldap_auth_rules/1
  # DELETE /ldap_auth_rules/1.xml
  def destroy
    @ldap_auth_rule = Irm::LdapAuthRule.find(params[:id])
    @ldap_auth_rule.destroy

    respond_to do |format|
      format.html { redirect_to({:controller => "irm/ldap_auth_headers",:action=>"show",:id=>params[:ah_id]}) }
      format.xml  { head :ok }
    end
  end

  def switch_sequence
    sequence_str = params[:ordered_ids]
    if sequence_str.present?
      sequence = 0
      rule_ids = sequence_str.split(",")
      rules = Irm::LdapAuthRule.where(:id => rule_ids).index_by(&:id)
      rule_ids.each do |id|
        rule = rules[id]
        rule.sequence = sequence
        rule.save
        sequence += 1
      end
    end
    respond_to do |format|
      format.json  {render :json => {:success => true}}
    end
  end


  def get_data
    ldap_auth_rules_scope = Irm::LdapAuthRule.order_by_sequence.with_person.find_all_by_ldap_auth_header_id(params[:ah_id])
    respond_to do |format|
      format.html  {
        @datas = ldap_auth_rules_scope
        @count = ldap_auth_rules_scope.count
      }
    end
  end
end
