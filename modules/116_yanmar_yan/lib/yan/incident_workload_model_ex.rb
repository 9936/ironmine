module Yan::IncidentWorkloadModelEx
  def self.included(base)
    base.class_eval do
      belongs_to :group, :class_name => "Irm::Group"

      def group_name
        Irm::Group.multilingual.find(self.group_id)[:name]
      end
    end
  end
end