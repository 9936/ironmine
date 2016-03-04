module Yan::EntryHeaderModelEx
  def self.included(base)
    base.class_eval do
      scope :with_read_num, lambda {
                             joins("LEFT OUTER JOIN (SELECT COUNT(*) num,entry_id from skm_entry_operate_histories where operate_code = 'SKM_SHOW' GROUP BY entry_id) rm on #{table_name}.id = rm.entry_id").
                                 select(" rm.num num")
                           }
    end
  end
end