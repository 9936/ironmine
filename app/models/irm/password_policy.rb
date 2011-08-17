class Irm::PasswordPolicy < ActiveRecord::Base
  set_table_name :irm_password_policies

  query_extend

  def validate_password(password)
    result = true
    # 验证密码长度
    if self.minimum_length
      result = result&&password.length>=self.minimum_length.to_i
    end
    # 验证密码复杂度
    if result&&self.complexity_requirement&&"1".eql?(self.complexity_requirement)
      result = result&&password.scan(/\d/).length>0&&password.scan(/[a-zA-Z]/).length>0
    end
    result
  end

  def expire?(password_last_update_at)
    if password_last_update_at&&self.expire_in &&self.expire_in.to_i>0&& (Time.now - password_last_update_at) > self.expire_in.to_i.days
      return true
    else
      return false
    end
  end

  def validate_message
    message = ""
    message << I18n.t(:label_irm_psw_policy_min_length) +":  #{self.minimum_length}"
    if self.complexity_requirement&&!"0".eql?(self.complexity_requirement)
      message << "  ,"
      message << I18n.t(:label_irm_psw_policy_complexity_requirement)
      message << ": "
      message << Irm::LookupValue.get_meaning("IRM_PSW_COMPLEXITY_REQ",self.complexity_requirement)
    end
    message
  end


  def random_password
    password = "111111"
    # 验证密码长度
    if self.minimum_length
      password = Irm::IdGenerator.instance.generate(self.class.table_name)
      password = password[22-self.minimum_length.to_i,22]
    end
    # 验证密码复杂度
    if self.complexity_requirement&&"1".eql?(self.complexity_requirement)
      password<<"a1"
    end
    password
  end

  # class method
  def self.validate_message
    if self.first
      return self.first.validate_message
    end
  end

  def self.expire?(password_last_update_at)
    if self.first
      return self.first.expire?(password_last_update_at)
    end
    return false
  end

  def self.validate_password(password)
    if self.first
      return self.first.validate_password(password)
    end
    return true
  end

  def self.random_password
    if self.first
      return self.first.random_password
    end
    return "111111"
  end

end