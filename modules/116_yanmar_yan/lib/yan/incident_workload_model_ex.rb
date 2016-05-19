module Yan::IncidentWorkloadModelEx
  def self.included(base)
    base.class_eval do
      belongs_to :group, :class_name => "Irm::Group"
      attr_accessor :start_date_time,:end_date_time,:start_date

      def group_name
        Irm::Group.multilingual.find(self.group_id)[:name]
      end
    end
  end
end