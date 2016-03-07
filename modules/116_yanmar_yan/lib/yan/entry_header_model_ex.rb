module Yan::EntryHeaderModelEx
  def self.included(base)
    base.class_eval do
      scope :with_read_num, lambda {
                             joins("LEFT OUTER JOIN (SELECT COUNT(*) num,entry_id from skm_entry_operate_histories where operate_code = 'SKM_SHOW_HTML' GROUP BY entry_id) rm on #{table_name}.id = rm.entry_id").
                                 select(" rm.num read_num")
                           }
      scope :with_download_num, lambda {
                            joins("LEFT OUTER JOIN (SELECT COUNT(*) num,entry_id from skm_entry_operate_histories where operate_code = 'SKM_SHOW_PDF' GROUP BY entry_id) dm on #{table_name}.id = dm.entry_id").
                                select(" dm.num download_num")
                          }
      scope :with_zan_num, lambda {
                                joins("LEFT OUTER JOIN (SELECT COUNT(*) num,rating_object_id from irm_ratings where bo_name = 'Skm::EntryHeader' GROUP BY rating_object_id) zm on #{table_name}.id = zm.rating_object_id").
                                    select(" zm.num zan_num")
                              }
    end
  end
end