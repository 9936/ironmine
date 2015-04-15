class Win::CustomerOrdersController < ApplicationController
  layout "application_full"

  def index

  end

  def import
    Win::CustomerOrder.import(params[:file])
    redirect_to({:controller => "win/customer_orders",:action => "index"}, notice: "Success.")
  end


  def get_data
    batch_number = Win::CustomerOrder.latest_batch(Irm::Person.current.id)
    bases_scope = Win::CustomerOrder.query_by_batch_number(batch_number).enabled.ordered
    bases,count = paginate(bases_scope)
    respond_to do |format|
      format.html  {
        @datas = bases
        @count = count
      }
    end
  end
end