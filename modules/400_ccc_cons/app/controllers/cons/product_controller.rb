class Cons::ProductController < ApplicationController

    def index
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @product }
      end
    end

    def new
      @product = Cons::Product.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @product }
      end
    end

    def create

      product = Cons::Product.where("id <> ?", "").order(:product_no).last

      if product
        params[:cons_product][:product_no] = (product.product_no.to_i + 1).to_s
      else
        params[:cons_product][:product_no] = "4000"
      end

      @product = Cons::Product.new(params[:cons_product])
      puts params[:cons_product].inspect

      respond_to do |format|
        if @product.save
          format.html { redirect_to({:action=>"show",:id=>@product.id},:notice => (t :successfully_created))}
          format.xml  { render :xml => @product, :status => :created, :location => @product }
          format.json { render :json=>@product}
          # end

        else
          format.html { render "new" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
          format.json  { render :json => @product.errors}
        end
      end
    end

    def show
      @product = Cons::Product.find(params[:id])
      respond_to do |format|
        format.json {render :json=>@product}
        format.html
      end
    end

    def edit
      @product = Cons::Product.find(params[:id])
    end

    def update
      @product = Cons::Product.find(params[:id])

      respond_to do |format|
        if @product.update_attributes(params[:cons_product])
          format.html { redirect_to({:action=>"show", :id=>@product.id},:notice => (t :successfully_updated)) }
          format.xml  { head :ok }
          format.json { render :json=>@product}
        else
          @error = @product
          format.html { render "edit" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
          format.json  { render :json => @product.errors}
        end
      end
    end

    def get_data
      @product = Cons::Product.where("id <> ?", "").with_product_message
      @product = @product.match_value("#{Cons::Product.table_name}.pro_name",params[:pro_name])

      @product,count = paginate(@product)
      respond_to do |format|
        format.json {render :json=>to_jsonp(@product.to_grid_json([:pro_name,:pro_manager,:pro_type,
                                                                    :pro_pricing_type,:pro_begin_date,:pro_end_date,:pro_group], count))}
        format.html {
          @count = count
          @datas = @product
        }
      end
    end
end
