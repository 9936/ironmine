module Yan::RatingModelEx
  def self.included(base)
    base.class_eval do
      after_create :trigger_survey

      def trigger_survey
        #当评价对象为事故单，且评分小于6分给支持人员触发调查问卷
        if self.bo_name.eql?("Icm::IncidentRequest") && self.grade.to_i < 6
          #在支持人员的主页显示一份调查问卷
          puts "============trigger incident survey============"
        end

      end
    end
  end
end