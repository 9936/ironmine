module Yan
  module Jobs
    class JournalElapseRecalculateJob<Struct.new(:sid)
      def perform
        Icm::IncidentJournalElapse.recalculate_distance_by_system(sid)
      end
    end
  end
end