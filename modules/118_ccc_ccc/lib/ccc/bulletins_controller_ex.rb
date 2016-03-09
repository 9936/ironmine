module Ccc::BulletinsControllerEx
  def self.included(base)
    base.class_eval do
      def get_data
        rec = Irm::Bulletin.list_all.with_author.without_delete.accessible(Irm::Person.current.id).with_order
        respond_to do |format|
          format.html  {
            @datas,@count = paginate(rec)
          }
          format.json  {
            bulletins,count = paginate(rec)
            render :json => to_jsonp(bulletins.to_grid_json([:id, :bulletin_title,:published_date,:page_views,:author], count)) }
        end
      end

      def get_data_limit
        rec = Irm::Bulletin.list_all.with_author.without_delete.accessible(Irm::Person.current.id).with_order.take(10)
        respond_to do |format|
          format.html  {
            @datas = rec
            @count = rec.count
          }
          format.json  {
            render :json => to_jsonp(rec.to_grid_json([:id, :bulletin_title,:published_date,:page_views,:author], 10)) }
        end
      end
    end
  end
end