module Irm::CustomId
  def self.included(base)
    base.class_eval do
      before_create :setup_custom_id

      private
      def setup_custom_id
        id_column = self.class.columns.detect{|i| i.primary}
        if id_column&&id_column.type.eql?(:string)&&id_column.limit==24
          self.id = Irm::IdGenerator.instance.generate(self.class.table_name)
        end
      end
    end
  end
end
