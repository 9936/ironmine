class Cons::CustomerController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def new
    @customer = Cons::Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def create
    flag = true
    @company = Cons::Company.where("com_name = ?", params[:cons_customer][:company]).first
    if @company
      params[:cons_customer][:company_id] = @company.id.to_s
    else
      flag = false
    end

    customer = Cons::Customer.where("id <> ?", "").order(:customer_no).last

    if customer
      puts customer.customer_no
      params[:cons_customer][:customer_no] = (customer.customer_no.to_i + 1).to_s
    else
      params[:cons_customer][:customer_no] = "2000"
    end
    @customer = Cons::Customer.new(params[:cons_customer])
    puts params[:cons_customer].inspect

    respond_to do |format|
      if Irm::Person.where("login_name = ?",params[:cons_customer][:login_name]).length > 0 || !flag
        if Irm::Person.where("login_name = ?",params[:cons_customer][:login_name]).length > 0
          @customer.errors.add(:login_name,"login_name already exists")
        end
        if !flag
          @customer.errors.add(:company,"Please input company")
        end
        format.html { render "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
        format.json  { render :json => @customer.errors}
      else
        if @customer.save
        @person = Irm::Person.new({
                                      :opu_id => "001n00012i8IyyjJakd6Om",
                                      :password => params[:cons_customer][:password],
                                      :first_name => params[:cons_customer][:customer_name],
                                      :login_name => params[:cons_customer][:login_name],
                                      :email_address => params[:cons_customer][:customer_email],
                                      :profile_id => params[:cons_customer][:profile_id],
                                      :organization_id => params[:cons_customer][:organization_id],
                                      :bussiness_phone => params[:cons_customer][:customer_telNo],
                                      :password_updated_at=> Time.now
                                  })
        @person.save!
        format.html { redirect_to({:action=>"show",:id=>@customer.id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
        format.json { render :json=>@customer}
        # end
        else
          format.html { render "new" }
          format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
          format.json  { render :json => @customer.errors}
        end
      end
    end

  end

  def show
    @customer = Cons::Customer.find(params[:id])
    puts @customer.companyName
    respond_to do |format|
      format.json {render :json=>@customer}
      format.html
    end
  end

  def edit
    @customer = Cons::Customer.find(params[:id])
  end

  def update
    @customer = Cons::Customer.find(params[:id])

    @company = Cons::Company.where("com_name = ?", params[:cons_customer][:company]).first
    params[:cons_customer][:company_id] = @company.id.to_s

    respond_to do |format|
      if @customer.update_attributes(params[:cons_customer])
        format.html { redirect_to({:action=>"show", :id=>@customer.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@customer}
      else
        @error = @customer
        format.html { render "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
        format.json  { render :json => @customer.errors}
      end
    end
  end


  def searchCustomerNo
    @customer = Cons::Customer.where("id <> ?", "").with_customer_message
    @customer = @customer.match_value("#{Cons::Customer.table_name}.customer_no",params[:customer_no])

    @customer,count = paginate(@customer)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@customer.to_grid_json([:customer_no,:customer_name], count))}
      format.html {
        @count = count
        @datas = @customer
      }
    end
  end

  def get_data
    @customer = Cons::Customer.where("id <> ?", "").with_customer_message
    @customer = @customer.match_value("#{Cons::Customer.table_name}.customer_name",params[:customer_name])
    @customer = @customer.match_value("#{Cons::Customer.table_name}.customer_tel",params[:customer_tel])
    @customer = @customer.match_value("#{Cons::Customer.table_name}.customer_email",params[:customer_email])
    @customer = @customer.match_value("#{Cons::Customer.table_name}.customer_comment",params[:customer_comment])

    @customer,count = paginate(@customer)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@customer.to_grid_json([:customer_name,:customer_sex,:customer_duty,
                                                                     :customer_status,:customer_tel,:customer_email,:customer_comment], count))}
      format.html {
        @count = count
        @datas = @customer
      }
    end
  end
end
