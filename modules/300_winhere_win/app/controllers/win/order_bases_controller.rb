class Win::OrderBasesController < ApplicationController
  layout "application_full"

  def index

  end

  def import
    Win::OrderBase.import(params[:file])
    redirect_to({:controller => "win/order_bases",:action => "index"}, notice: "Success.")
  end


  def get_data
    bases_scope = Win::OrderBase.enabled
    bases,count = paginate(bases_scope)
    respond_to do |format|
      format.html  {
        @datas = bases
        @count = count
      }
    end
  end
end
