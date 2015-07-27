module Ysq::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      attr_accessor :if_private_reply

      validates_presence_of :incident_category_id
      validates_presence_of :incident_sub_category_id
      validates_presence_of :report_source_code

      def re_summary
        content = self.summary
        content = content.gsub(/&nbsp;/,' ')
        content = content.gsub(/[[:blank:]]/, ' ')
        return content
      end
    end
  end
end