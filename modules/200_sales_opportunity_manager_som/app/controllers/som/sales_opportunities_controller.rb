class Som::SalesOpportunitiesController < ApplicationController
  layout "application_full"
  # GET /som/sales_opportunities
  # GET /som/sales_opportunities.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /som/sales_opportunities/1
  # GET /som/sales_opportunities/1.xml
  def show
    @sales_opportunity = Som::SalesOpportunity.query(params[:id]).list_all.first

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @sales_opportunity }
    end
  end

  # GET /som/sales_opportunities/new
  # GET /som/sales_opportunities/new.xml
  def new
    @sales_opportunity = Som::SalesOpportunity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @sales_opportunity }
    end
  end

  # GET /som/sales_opportunities/1/edit
  def edit
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    unless current_person?(@sales_opportunity.created_by)|| current_person?(@sales_opportunity.charge_person)||(@sales_opportunity.sales_authorizes.collect{|i| i.person_id}).include?(Irm::Person.current.id)
       redirect_to(:action=>"index")
    end

  end

  # POST /som/sales_opportunities
  # POST /som/sales_opportunities.xml
  def create
    @sales_opportunity = Som::SalesOpportunity.new(params[:som_sales_opportunity])
    respond_to do |format|
      if @sales_opportunity.valid?
         @sales_opportunity.create_sales_authorize_from_str
         @sales_opportunity.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @sales_opportunity, :status => :created, :location => @sales_opportunity }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @som_sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /som/sales_opportunities/1
  # PUT /som/sales_opportunities/1.xml
  def update
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    unless current_person?(@sales_opportunity.created_by)|| current_person?(@sales_opportunity.charge_person)||(@sales_opportunity.sales_authorizes.collect{|i| i.person_id}).include?(Irm::Person.current.id)
      redirect_to(:action=>"index")
    end
    respond_to do |format|
      @sales_opportunity.attributes = params[:som_sales_opportunity]
      if @sales_opportunity.valid?
        @sales_opportunity.create_sales_authorize_from_str
        @sales_opportunity.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /som/sales_opportunities/1
  # DELETE /som/sales_opportunities/1.xml
  def destroy
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    if (current_person?(@sales_opportunity.created_by)||current_person?(@sales_opportunity.charge_person))
      @sales_opportunity.destroy
    end

    respond_to do |format|
      format.html { redirect_to(:action => "index") }
      format.xml { head :ok }
    end
  end


  def get_data
    sales_opportunities_scope = Som::SalesOpportunity.list_all
    sales_opportunities_scope = sales_opportunities_scope.match_value("#{Som::SalesOpportunity.table_name}.short_name", params[:short_name])
    #对可能性进行过渡
    if params[:possibility].present?&&!params[:possibility].include?("all")
      where_str = ""
      where_params = []
      params[:possibility].each { |p|
        if where_str.present?
          where_str << "OR (#{Som::SalesOpportunity.table_name}.possibility > ? and #{Som::SalesOpportunity.table_name}.possibility <= ?)"
        else
          where_str << "(#{Som::SalesOpportunity.table_name}.possibility > ? and #{Som::SalesOpportunity.table_name}.possibility <= ?)"
        end
        where_params << p.split("_").collect { |i| i.to_f*10 }
      }

      sales_opportunities_scope = sales_opportunities_scope.where(([where_str]+where_params).flatten)

    end

    #对年份进行过渡
    if params[:year].present?&&!params[:year].include?("all")
      sales_opportunities_scope = sales_opportunities_scope.where("year(#{Som::SalesOpportunity.table_name}.start_at) in (?)", params[:year])
    end

    #对状态
    if params[:status].present?&&!params[:status].include?("all")
      status_filters=params[:status]
      sales_opportunities_scope = sales_opportunities_scope.as_status(status_filters)
    end

    #与事故单的关系
    if params[:role].present?&&!params[:role].include?("all")
      if (params[:role].include?("CHARGE"))
        sales_opportunities_scope = sales_opportunities_scope.where(:charge_person => Irm::Person.current.id)
      else
        sales_opportunities_scope = sales_opportunities_scope.where("#{Som::SalesOpportunity.table_name}.charge_person != ?", Irm::Person.current.id)
      end
    end

    if params[:order_name]&&params[:order_value]
      case params[:order_name]
        when "start_at"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.start_at #{params[:order_value]}")
        when "end_at"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.end_at #{params[:order_value]}")
        when "sales_status"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.sales_status #{params[:order_value]}")
        when "price"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.price #{params[:order_value]}")
        when "second_price"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.second_price  #{params[:order_value]}")
        when "second_price"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.second_price  #{params[:order_value]}")
      end
    end
    sales_opportunities, count = paginate(sales_opportunities_scope)
    respond_to do |format|
      format.html {
        @datas = sales_opportunities
        @count = count
      }
      format.json { render :json => to_jsonp(sales_opportunities.to_grid_json([:name, :description, :status_meaning], count)) }
      format.xls {
        send_data(sales_data_to_xls(sales_opportunities_scope,
                                    [{:key => :charge_person_name, :label => t(:label_som_sales_opportunity_charge_person)},
                                     {:key => :name, :label => t(:label_som_sales_opportunity_alias_name)},
                                     {:key => :content, :label => t(:label_som_sales_opportunity_alias_content)},
                                     {:key => :potential_customer_name, :label => t(:label_som_sales_opportunity_customer)},
                                     {:key => :region_meaning, :label => t(:label_som_sales_opportunity_region)},
                                     {:key => :address, :label => t(:label_som_sales_opportunity_address)},
                                     {:key => :price_year, :label => t(:label_som_sales_opportunity_price_year)},
                                     {:key => :price, :label => t(:label_som_sales_opportunity_price)},
                                     {:key => :total_price, :label => t(:label_som_sales_opportunity_total_price)},
                                     {:key => :open_at_alias, :label => t(:label_som_sales_opportunity_sales_open_at)},
                                     {:key => :previous_flag, :label => t(:label_som_sales_opportunity_sales_previous_flag)},
                                     {:key => :sales_status_meaning, :label => t(:label_som_sales_opportunity_sales_alias_status)},
                                     {:key => :possibility, :label => t(:label_som_sales_opportunity_sales_alias_possibility)},
                                     {:key => :operation, :label => t(:label_som_sales_opportunity_operations)},
                                     {:key => :hisms, :label => t(:label_som_sales_opportunity_hisms)},
                                     {:key => :ebs, :label => t(:label_som_sales_opportunity_ebs)},
                                     {:key => :siebel, :label => t(:label_som_sales_opportunity_siebel)},
                                     {:key => "hr/peoplesoft", :label => t(:label_som_sales_opportunity_hr)},
                                     {:key => :hyperion, :label => t(:label_som_sales_opportunity_hyperion)},
                                     {:key => :ms, :label => t(:label_som_sales_opportunity_ms)},
                                     {:key => :java, :label => t(:label_som_sales_opportunity_java)},
                                     {:key => :sales_person_name, :label => t(:label_som_sales_opportunity_sales_alias_person)},
                                     {:key => :internal_member, :label => t(:label_som_sales_opportunity_internal_member)},
                                     {:key => :external_member, :label => t(:label_som_sales_opportunity_external_member)}
                                    ]
                  ))
      }
    end
  end


  def sales_data_to_xls(datas, columns, options={})
    datas.each do |data|
      involved_production_info=data.involved_production_info
      unless involved_production_info.nil?
      involved_production_infos=involved_production_info.split(",")
      involved_production_infos.each do |d|
        data["#{d.downcase}"]=t("label_som_sales_opportunity_flag_Y")
      end
      end
      if data.previous_flag.eql?("Y")
        data[:previous_flag]=t("label_som_sales_opportunity_flag_Y")
      else
        data[:previous_flag]=t("label_som_sales_opportunity_flag_N")
      end
      data[:open_at_alias]=data[:open_at].strftime('%Y-%m-%d') unless data[:open_at].nil?
    end
    datas.to_xls(columns, options)
  end


  def edit_reason
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])

  end

  def update_reason
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    @sales_opportunity.update_attributes(params[:som_sales_opportunity])
  end
end
