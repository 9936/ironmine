class Irm::ReadedBulletin < ActiveRecord::Base
  set_table_name :irm_readed_bulletins

  #加入activerecord的通用方法和scope
 query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}



  def self.unread_bulletin
    bulletin_ids=self.select("bulletin_id").where(:person_id=>Irm::Person.current.id)
    ids=[]
    bulletin_ids.each do |id|
      ids<<id.bulletin_id
    end
    rec = Irm::Bulletin.select_all_top.with_author.without_delete.accessible(Irm::Person.current.id).sticky.with_order.not_in_bulletin_ids(ids).list_all
    @unreaded=rec
  end


  def self.set_readed(readed)
    readed.each do |read|
        self.create(:person_id=>Irm::Person.current.id,:bulletin_id=>read.id)
    end
  end

end
