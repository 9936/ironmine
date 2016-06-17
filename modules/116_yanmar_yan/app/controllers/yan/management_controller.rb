class Yan::ManagementController < ApplicationController


    layout "application_full"

    def index
      @management = Yan::Management.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @management }
      end
    end

    def get_data
      management = Yan::Management.where("id IS NOT NULL")
      management = management.match_value("#{Yan::Management.table_name}.management_code", params[:management_code]) if params[:management_code].present?
      management = management.match_value("#{Yan::Management.table_name}.name", params[:name]) if params[:name].present?
      management,count = paginate(management)
      respond_to do |format|
        format.html  {
          @datas = management
          @count = count
        }
      end
    end
    def new
      @management = Yan::Management.new
    end

    def create

      @management = Yan::Management.new(params[:yan_management])
      if @management.save
        respond_to do |format|
          format.html {redirect_back_or_default}
          format.js
        end
      end
    end

    def edit
      @management = Yan::Management.find(params[:id])
    end
    def update
      @management = Yan::Management.find(params[:id])
      if @management.update_attributes(params[:yan_management])
        respond_to do |format|
          format.html { render :action => "index" }
          format.js
        end
      end
    end

    def show
      @management = Yan::Management.find(params[:id])
    end

    def delete
      @management = Yan::Management.find(params[:id])
      if @management.delete
        respond_to do |format|
          format.html {redirect_back_or_default}
          format.js
        end
      end
    end



end
