class Irm::LdapAuthRule < ActiveRecord::Base
  set_table_name :irm_ldap_auth_rules
  belongs_to :ldap_auth_header,:foreign_key=>:ldap_auth_header_id,:primary_key=>:id

  before_create :build_sequence

  validates_presence_of :ldap_auth_header_id, :attr_field, :operator_code, :attr_value, :template_person_id

  scope :order_by_sequence,lambda{
    self.order("sequence ASC")
  }

  scope :with_auth_header,lambda{|header_id|
    self.where(:ldap_auth_header_id => header_id )
  }

  scope :with_person,lambda{
    joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{table_name}.template_person_id").
        select("#{Irm::Person.table_name}.full_name,#{table_name}.*")
  }
  #Irm::LdapAuthRule.get_template_person({:email => 'li.zhang04@hand-china.com'}, '001L00084jJHZsV5hJxwfY')
  def self.get_template_person(field_to_value,header_id)
    rule_scoped = self.order_by_sequence.with_auth_header(header_id)

    #查看是否有这些属性，如果同时存在多个需要根据sequence排序
    new_field_to_value = {}
    ordered_rules = rule_scoped.where(:attr_field => field_to_value.keys)
    ordered_rules.each do |rule|
      new_field_to_value[rule.attr_field.to_sym] = field_to_value[rule.attr_field.to_sym]
    end

    #查找是否含有field和value的记录
    new_field_to_value.each do |field, value|

      #第一步查找等于的
      rule = rule_scoped.where("attr_field = ? AND operator_code = ? AND attr_value = ?", field, 'E', value).first
      if rule.present?
        return rule.template_person_id
      else

        #第二步查找包含的
        rules = rule_scoped.where("attr_field =? AND operator_code = ?", field, 'I')
        rules.each do |r|
          rule = r
          if rule.attr_value and rule.regex_include(value)
            return rule.template_person_id
          end
          if r == rules.last

            #第三步查找不等于的
            rule = rule_scoped.where("attr_field = ? AND operator_code =? AND attr_value != ?", field, 'N', value).first
            return rule.template_person_id if rule
          end
        end

        #第三步查找不等于的
        rule = rule_scoped.where("attr_field = ? AND operator_code =? AND attr_value != ?", field, 'N', value).first
        return rule.template_person_id if rule
      end
    end if new_field_to_value.any?
    return nil
  end

  def regex_include(str)
    reg_str = self.attr_value.gsub(/%/,'.*')
    reg = Regexp.new("#{reg_str}")
    str.match(reg)
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
