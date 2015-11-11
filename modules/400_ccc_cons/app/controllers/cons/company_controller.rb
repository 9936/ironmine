class Cons::CompanyController < ApplicationController

    def index
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @company }
      end
    end

    def new
      @company = Cons::Company.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @company }
      end
    end

    def create
      company = Cons::Company.where("id <> ?", "").order(:company_no).last

      if company
        params[:cons_company][:company_no] = (company.company_no.to_i + 1).to_s
      else
        params[:cons_company][:company_no] = "1000"
      end

      @company = Cons::Company.new(params[:cons_company])
      puts params[:cons_company].inspect

      respond_to do |format|
        if @company.save
          format.html { redirect_to({:action=>"show",:id=>@company.id},:notice => (t :successfully_created))}
          format.xml  { render :xml => @company, :status => :created, :location => @company }
          format.json { render :json=>@company}
          # end

        else
          format.html { render "new" }
          format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
          format.json  { render :json => @company.errors}
        end
      end

    end

    def show
      @company = Cons::Company.find(params[:id])
      respond_to do |format|
        format.json {render :json=>@company}
        format.html
      end
    end

    def edit
      @company = Cons::Company.find(params[:id])
    end

    def update
      @company = Cons::Company.find(params[:id])

      respond_to do |format|
        if @company.update_attributes(params[:cons_company])
          format.html { redirect_to({:action=>"show", :id=>@company.id},:notice => (t :successfully_updated)) }
          format.xml  { head :ok }
          format.json { render :json=>@company}
        else
          @error = @company
          format.html { render "edit" }
          format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
          format.json  { render :json => @company.errors}
        end
      end
    end

    def get_data
      @company = Cons::Company.where("id <> ?", "").with_company_message
      @company = @company.match_value("#{Cons::Company.table_name}.com_name",params[:com_name])
      @company = @company.match_value("#{Cons::Company.table_name}.com_address",params[:com_address])
      @company = @company.match_value("#{Cons::Company.table_name}.com_city",params[:com_city])
      @company = @company.match_value("#{Cons::Company.table_name}.com_province",params[:com_province])

      @company,count = paginate(@company)
      respond_to do |format|
        format.json {render :json=>to_jsonp(@company.to_grid_json([:com_name,:com_address,:com_ZCode,
                                                                    :com_city,:com_province,:com_country,:com_industry], count))}
        format.html {
          @count = count
          @datas = @company
        }
      end
    end

    def searchCompany
      @company = Cons::Company.where("id <> ?", "").with_company_message
      @company = @company.match_value("#{Cons::Company.table_name}.com_name",params[:com_name])

      @company,count = paginate(@company)
      respond_to do |format|
        format.json {render :json=>to_jsonp(@company.to_grid_json([:com_name],count))}

        format.html {
          @count = count
          @datas = @company
        }
      end
    end
  end
