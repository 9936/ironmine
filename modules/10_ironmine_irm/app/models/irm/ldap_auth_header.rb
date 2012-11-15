class Irm::LdapAuthHeader < ActiveRecord::Base
  set_table_name :irm_ldap_auth_headers
  belongs_to :ldap_source, :foreign_key => :ldap_source_id, :primary_key => :id
  has_many :ldap_auth_attributes
  has_many :ldap_auth_rules

  #对必填属性进行校验
  validates_presence_of :name, :auth_cn, :ldap_login_name_attr, :ldap_email_address_attr, :template_person_id, :ldap_source_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }


  scope :with_ldap_source, lambda {
    joins("JOIN #{Irm::LdapSource.table_name} ON #{Irm::LdapSource.table_name}.id = #{table_name}.ldap_source_id").
        select("#{Irm::LdapSource.table_name}.name ldap_source_name")
  }

  scope :with_template_person, lambda {
    joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{table_name}.template_person_id").
        select("#{Irm::Person.table_name}.full_name template_person_name")
  }

  scope :query_by_ldap_source, lambda { |ldap_source_id|
    where(:ldap_source_id => ldap_source_id)
  }


  def self.list_all
    select("#{table_name}.*").with_ldap_source.with_template_person
  end

  def self.try_to_login(login_name, password)
    self.enabled.each do |auth_header|
      begin
        attrs = auth_header.authenticate(login_name, password)
      rescue => e
        logger.error "Error during authentication: #{e.message}"
        attrs = nil
      end
      return attrs if attrs
    end
    return nil
  end


  def authenticate(login_name, password)
    login_filter = Net::LDAP::Filter.eq(self.ldap_login_name_attr, login_name)
    return_attrs = {:login_name => self.ldap_login_name_attr, :email_address => self.ldap_email_address_attr}
    # setup person
    person_attr = {}
    self.ldap_auth_attributes.each do |attr|
      return_attrs[attr.local_attr.to_sym] = attr.ldap_attr
    end

    ldap = Net::LDAP.new
    ldap.host = self.ldap_source.host
    ldap.port = self.ldap_source.port
    Irm::OperationUnit.current = Irm::OperationUnit.find(self.ldap_source.opu_id)
    # 使用UID作为登录名
    if self.ldap_source.anonymous?&&self.ldap_login_name_attr.eql?("uid")
      ldap.search(:auth => {:method => :simple, :dn => "uid=#{login_name},#{self.auth_cn}", :password => password},
                  :base => self.auth_cn,
                  :filter => login_filter,
                  # only ask for the DN if on-the-fly registration is disabled
                  :attributes => (['dn']+return_attrs.values)) do |return_entry|
        exists_person = Irm::Person.where(:login_name => login_name).first
        return exists_person.id if exists_person

        filed_to_value = {}
        return_attrs.each do |key, value|
          return_value = self.class.get_attr(return_entry, value).force_encoding("utf-8")
          filed_to_value[value.to_sym] = return_value if return_value.present?
          person_attr[key]= return_value if return_value
        end
        person_attr[:auth_source_id] = self.id
        person_attr[:email_address] = "#{person_attr[:login_name]}@ironmine.com" unless person_attr[:email_address].present?
        person_attr[:first_name] = login_name unless person_attr[:first_name].present?

        person = create_ldap_person(person_attr,filed_to_value)
        return person.id if person

      end
    else
      ldap.search(:auth => self.ldap_source.auth_options,
                  :base => self.ldap_source.base_dn,
                  :filter => login_filter,
                  :attributes => (['dn'])) do |entry|
        dn = entry.dn

        ldap.search(:auth => {:method => :simple, :dn => dn, :password => password},
                    :base => self.auth_cn,
                    :filter => login_filter,
                    # only ask for the DN if on-the-fly registration is disabled
                    :attributes => (['dn']+return_attrs.values)) do |return_entry|
          exists_person = Irm::Person.where(:login_name => login_name).first
          return exists_person.id if exists_person

          filed_to_value = {}
          return_attrs.each do |key, value|
            return_value = self.class.get_attr(return_entry, value).force_encoding("utf-8")
            filed_to_value[value.to_sym] = return_value if return_value.present?
            person_attr[key]= return_value if return_value.present?
          end

          person_attr[:auth_source_id] = self.id
          person_attr[:email_address] = "#{person_attr[:login_name]}@ironmine.com" unless person_attr[:email_address].present?
          person_attr[:first_name] = login_name unless person_attr[:first_name].present?

          person = create_ldap_person(person_attr,filed_to_value)
          return person.id if person

        end
      end
    end


    return nil

  end


  def create_ldap_person(person_attr, filed_to_value = {})
    #首先查找规则中的模板用户，当不存在时候用自身的模板用户同步数据
    if filed_to_value.any?
      template_person_id = Irm::LdapAuthRule.get_template_person(filed_to_value,self.id)
      unless template_person_id.present?
        template_person_id = self.template_person_id
      end
    else
      template_person_id = self.template_person_id
    end

    template_person = Irm::Person.find(template_person_id)

    person = template_person.attributes.merge(person_attr.stringify_keys!)
    # setup person and password
    random_password = Irm::PasswordPolicy.random_password(template_person.opu_id)
    person.merge!({:password => random_password, :password_confirmation => random_password})
    person = Irm::Person.new(person)
    person.save
    return nil if person.errors.any?
    template_person.external_system_people.each do |pr|
      person.external_system_people.create(:external_system_id => pr.external_system_id)
    end

    template_person.group_members.each do |gm|
      person.group_members.create(:group_id => gm.group_id)
    end

    person
  end


  def self.get_attr(entry, attr_name)
    if !attr_name.blank? &&entry[attr_name].present?
      entry[attr_name].is_a?(Array) ? entry[attr_name].first : entry[attr_name]
    end
  end

end
