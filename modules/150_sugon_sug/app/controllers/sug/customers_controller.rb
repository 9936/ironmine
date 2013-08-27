class Sug::CustomersController < ApplicationController
  # GET /customers
  # GET /customers.xml
  def index
    @customers = Sug::Customer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Sug::Customer.select_all.with_address.with_parent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @customer = Sug::Customer.new
    @customer.build_address

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Sug::Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = Sug::Customer.new(params[:sug_customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = Sug::Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:sug_customer])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Sug::Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @customer = Sug::Customer.find(params[:id])
  end

  def multilingual_update
    @customer = Sug::Customer.find(params[:id])
    @customer.not_auto_mult=true
    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to({:action => "show"}, :notice => 'Sug::Customer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def nicknames

  end

  def create_nickname
    if params[:sug_customer]
      customer_ids = params[:sug_customer][:status_code].split(",")
      if customer_ids.any? && params[:sug_customer][:nickname].present?
         Sug::Customer.update_all({:nickname => params[:sug_customer][:nickname]}, ["id in(?)", customer_ids])
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action => "nicknames"}, :notice => t(:successfully_updated)) }
      format.xml  { head :ok }
    end
  end

  def owned_contacts
    contact_scope = Sug::Contact.list_all.owned_by_customer(params[:id])
    contact_scope = contact_scope.match_value("#{Sug::Contact.table_name}.first_name", params[:first_name])
    contact_scope = contact_scope.match_value("#{Sug::Contact.table_name}.last_name", params[:last_name])
    contacts,count = paginate(contact_scope)
    respond_to do |format|
      format.html  {
        @datas = contacts
        @count = count
      }
    end
  end

  def available_contacts
    contact_scope = Sug::Contact.list_all.available_by_customer(params[:id])
    contact_scope = contact_scope.match_value("#{Sug::Contact.table_name}.first_name", params[:first_name])
    contact_scope = contact_scope.match_value("#{Sug::Contact.table_name}.last_name", params[:last_name])
    contacts,count = paginate(contact_scope)
    respond_to do |format|
      format.html  {
        @datas = contacts
        @count = count
      }
    end
  end

  def create_contacts
    if params[:sug_customer] && params[:sug_customer][:status_code] && params[:id]
      contact_ids = params[:sug_customer][:status_code].split(",")
      contact_ids.each do |contact_id|
        Sug::CustomerContact.create(:contact_id => contact_id, :customer_id => params[:id])
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action => "show", :id => params[:id]}) }
      format.xml  { head :ok }
    end
  end

  def remove_contacts
    if params[:sug_customer] && params[:sug_customer][:temp_id_string] && params[:id]
      contact_ids = params[:sug_customer][:temp_id_string].split(",")
      contact_ids.each do |contact_id|
        customer_contact = Sug::CustomerContact.where(:contact_id => contact_id, :customer_id => params[:id]).first
        customer_contact.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action => "show", :id => params[:id]}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    customers_scope = Sug::Customer.select_all.with_address.with_parent
    customers_scope = customers_scope.match_value("#{Sug::Customer.table_name}.name", params[:name])
    customers,count = paginate(customers_scope)
    respond_to do |format|
      format.html  {
        @datas = customers
        @count = count
      }
    end
  end
end
