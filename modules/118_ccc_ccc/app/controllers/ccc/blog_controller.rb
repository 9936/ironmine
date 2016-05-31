class Ccc::BlogController < ApplicationController

  layout "application_full"

  def index
    @blog = Ccc::Blog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  def get_data
    blog = Ccc::Blog.where("id IS NOT NULL")
    blog = blog.match_value("#{Ccc::Blog.table_name}.title", params[:title]) if params[:title].present?
    blog = blog.match_value("#{Ccc::Blog.table_name}.author", params[:author]) if params[:author].present?
    blog,count = paginate(blog)
    respond_to do |format|
      format.html  {
        @datas = blog
        @count = count
      }
    end
  end
  def new
    @blog = Ccc::Blog.new
  end

  def create

    @blog = Ccc::Blog.new(params[:ccc_blog])
    if @blog.save
      respond_to do |format|
        format.html {redirect_back_or_default}
        format.js
      end
    end
  end

  def edit
    @blog = Ccc::Blog.find(params[:id])
  end
  def update
    @blog = Ccc::Blog.find(params[:id])
    if @blog.update_attributes(params[:ccc_blog])
      respond_to do |format|
        format.html { render :action => "index" }
        format.js
      end
    end
  end

  def show
    @blog = Ccc::Blog.find(params[:id])
  end

  def delete
    @blog = Ccc::Blog.find(params[:id])
    if @blog.delete
      respond_to do |format|
        format.html {redirect_back_or_default}
        format.js
      end
    end
  end

end
