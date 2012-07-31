module Fwk::Sunspot
  class IndexingJob < Struct.new(:entry, :id)
    def perform
      obj = entry.constantize.unscoped.find_by_id(id)
      Sunspot.session.original_session.index!(*obj)
    end
  end
end