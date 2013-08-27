module Sug::PersonModelEx
  def self.included(base)
    base.class_eval do
      attr_accessor :skills

      after_save :merge_skills

      has_one :address, :class_name => "Sug::Address", :foreign_key => :source_id, :dependent => :destroy
      accepts_nested_attributes_for :address


      #查找出含有指定类别的工程师，将含是否具有该机能的进行分开
      scope :skilled_people, lambda{|country_id, province_id, city_id, district_id, category_id|
        if country_id.present?
          where_sql = "sa.country_id='#{country_id}' "
          if province_id.present?
            where_sql << "AND sa.province_id='#{province_id}' "
            if city_id.present?
              where_sql << "AND sa.city_id='#{city_id}' "
              if district_id.present?
                where_sql << "AND sa.district_id='#{district_id}' "
              end
            end
          end
        else
          where_sql = "1=1"
        end
        where_sql << " AND cs.category_id='#{category_id}'"

        joins("JOIN #{Sug::Address.table_name} sa ON sa.source_id=#{table_name}.id").
            joins("JOIN #{Sug::PersonSkill.table_name} ps ON ps.person_id=#{table_name}.id").
            joins("JOIN #{Sug::CategorySkill.table_name} cs ON cs.skill_id=ps.skill_id").
            where(where_sql)
      }

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