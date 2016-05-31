class Ccc::CommentController < ApplicationController
  def get_data
    comment = Ccc::Comment.where("blog_id = ?", params[:id])
    comment,count = paginate(comment)

    respond_to do |format|
      format.html  {
        @datas = comment
        @count = count
      }
    end
  end

  def new
    @comment = Ccc::Comment.new
    @blog_id = params[:blog_id]
  end

  def create
    puts 111111
    puts params[:ccc_comment]
    puts params[:blog_id]
    puts params.inspect
    puts 222222
    @comment = Ccc::Comment.new(params[:ccc_comment])
    @comment.blog_id = params[:blog_id]
    if @comment.save
      respond_to do |format|
        format.html {redirect_back_or_default}
        format.js
      end
    end
  end

  def delete
    @comment = Ccc::Comment.find(params[:id])
    if @comment.delete
      respond_to do |format|
        format.html {redirect_back_or_default}
        format.js
      end
    end
  end
end
