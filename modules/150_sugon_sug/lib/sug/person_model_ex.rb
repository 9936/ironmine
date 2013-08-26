module Sug::PersonModelEx
  def self.included(base)
    base.class_eval do
      attr_accessor :skills

      after_save :merge_skills

      has_one :address, :class_name => "Sug::Address", :foreign_key => :source_id, :dependent => :destroy
      accepts_nested_attributes_for :address

      def address_meaning
        address = Sug::Address.with_address_name.query_by_source(self.id, self.class.to_s).first
        if address.present?
          return address[:address_name]
        else
          return ""
        end
      end

      def merge_skills
        if self.skills && self.skills.any?
          delete_skills = []
          self.owned_skills.each do |os|
            #如果技能已经存在
            unless skills.include?(os)
              delete_skills << os
            end
          end
          skills.each do |skill|
            Sug::PersonSkill.create(:person_id => self.id, :skill_id => skill) unless owned_skills.include?(skill)
          end
          #删除技能
          delete_skills.each do |ds|
            person_skill = Sug::PersonSkill.where(:person_id => self.id, :skill_id => ds).first
            person_skill.destroy
          end
        end
      end

      def owned_skills
        Sug::PersonSkill.query_by_person(self.id).collect{|i| i.skill_id}
      end
    end
  end
end