class Skm::EntryHeaderRelation < ActiveRecord::Base
  set_table_name :skm_entry_header_relations

  scope :list_all, lambda{|entry_header_id|
    select("eh.id entry_id, eh.entry_title entry_title, eh.published_date published_date, eh.version_number version_number, eh.doc_number doc_number, #{table_name}.relation_type relation_type,#{table_name}.source_id source_id, #{table_name}.target_id target_id, #{table_name}.id relation_id").
        joins(",#{Skm::EntryHeader.table_name} eh").
        where("(eh.id = #{table_name}.source_id AND ? = #{table_name}.target_id) OR (eh.id = #{table_name}.target_id AND ? = #{table_name}.source_id)", entry_header_id, entry_header_id)
  }

  scope :existed_relation, lambda{|source_id, target_id|
    where("(#{table_name}.source_id = ? AND #{table_name}.target_id = ?) OR (#{table_name}.source_id = ? AND #{table_name}.target_id = ?)", source_id, target_id, target_id, source_id)
  }

end
