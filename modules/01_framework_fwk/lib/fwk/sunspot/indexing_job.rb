module Fwk::Sunspot
  class IndexingJob < Struct.new(:entry, :id,:sunspot_method)
    def perform
      obj = entry.constantize.unscoped.find_by_id(id)
      sunspot_method ||= 'index'
      sunspot_method = sunspot_method.to_sym
      case sunspot_method
        when :index
          Sunspot.session.original_session.index!(*obj)
        when :remove
          Sunspot.session.original_session.remove!(*obj)
        when :commit
          Sunspot.session.original_session.commit
        else
          raise "Error: undefined protocol for SunspotWorker: #{sunspot_method}"
      end

    end
  end
end