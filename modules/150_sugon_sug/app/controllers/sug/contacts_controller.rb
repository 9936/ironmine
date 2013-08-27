class Sug::ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.xml
  def index
    @contacts = Sug::Contact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Sug::Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Sug::Contact.new
    @contact.addresses.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Sug::Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Sug::Contact.new(params[:sug_contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Sug::Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:sug_contact])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Sug::Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    contacts_scope = Sug::Contact.list_all
    contacts_scope = contacts_scope.match_value("contact.name",params[:name])
    contacts,count = paginate(contacts_scope)
    respond_to do |format|
      format.html  {
        @datas = contacts
        @count = count
      }
      format.json {render :json=>to_jsonp(contacts.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
