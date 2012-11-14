class Irm::LdapAuthRule < ActiveRecord::Base
  set_table_name :irm_ldap_auth_rules
  belongs_to :ldap_auth_header,:foreign_key=>:ldap_auth_header_id,:primary_key=>:id

  before_create :build_sequence

  scope :order_by_sequence,lambda{
    self.order("sequence ASC")
  }

  scope :with_person,lambda{
    joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{table_name}.template_person_id").
        select("#{Irm::Person.table_name}.full_name,#{table_name}.*")
  }

  def self.get_template_person(field_to_value)
    #查找是否含有field和value的记录
    field_to_value.each do |field, value|
      rule = self.order_by_sequence.where("attr_field = ? AND attr_value = ?", field, value).first
      if rule.present?
        if rule.operator_code.eql?('E')
          return rule.template_person_id
        else
          rule = self.order_by_sequence.where("attr_field = ? AND attr_value != ?", field, value).first
          if !rule.attr_value.eql?(value) and rule.operator_code.eql?('N')
            return rule.template_person_id
          else
            return nil
          end
        end
      end
    end
  end

  private
    #构建sequence
    def build_sequence
      current_sequence = Irm::LdapAuthRule.select("sequence").order("sequence DESC").first
      if current_sequence.present?
        self.sequence = current_sequence[:sequence] + 1
      else
        self.sequence = 1
      end
    end
end
