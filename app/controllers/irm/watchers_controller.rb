class Irm::WatchersController < ApplicationController
  def add_watcher
    @watchable = eval(params[:watchable_type]).find(params[:watchable_id])
    watcher = Irm::Person.find(params[:watcher])
    @watchable.add_watcher(watcher)
    @watchable.save

    prepare_order

    respond_to do |format|
      format.js {render :add_watcher}
    end
  end

  def delete_watcher
    @watchable = eval(params[:watchable_type]).find(params[:watchable_id])
    wat = @watchable.watchers.where("member_id = ? AND watchable_id = ? AND watchable_type = ?",
                              params[:watcher_id],
                              params[:watchable_id],
                              params[:watchable_type])
    wat.first.destroy

    prepare_order

    respond_to do |format|
      format.js {render :add_watcher}
    end
  end

  def order
    @watchable = eval(params[:watchable_type]).find(params[:watchable_id])

    prepare_order

    respond_to do |format|
      format.js {render :add_watcher}
    end
  end

  private
  def prepare_order
    @order_target = params[:order_target].present? ? params[:order_target] : "#{Irm::Watcher.table_name}.created_at"
    @order_type = params[:order_type].present? ? params[:order_type] : "DESC"
    @new_order_type = @order_type == "DESC" ? "ASC" : "DESC"
  end
end