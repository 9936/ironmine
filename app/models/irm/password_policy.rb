class Irm::PasswordPolicy < ActiveRecord::Base
  set_table_name :irm_password_policies

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

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

  def locked?(times)
    !(self.maximum_attempts.to_i==0||self.maximum_attempts.to_i>times)
  end

  def lock_until_date
    if(self.lockout_period.to_i==0)
      return nil
    else
      return self.lockout_period.to_i.minutes.from_now
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
  def self.current(opu_id)
    self.unscoped.by_opu(opu_id).first
  end

  def self.validate_message(opu_id)
    policy = self.unscoped.by_opu(opu_id).first
    if policy
      return policy.validate_message
    end
  end

  def self.expire?(password_last_update_at,opu_id)
    policy = self.unscoped.by_opu(opu_id).first
    if policy
      return policy.expire?(password_last_update_at)
    end
    return false
  end

  def self.validate_password(password,opu_id)
    policy = self.unscoped.by_opu(opu_id).first
    if policy
      return policy.validate_password(password)
    end
    return true
  end

  def self.random_password(opu_id)
    policy = self.unscoped.by_opu(opu_id).first
    if policy
      return policy.random_password
    end
    return "111111"
  end

  def self.locked?(times,opu_id)
    policy = self.unscoped.by_opu(opu_id).first
    if policy
      return policy.locked?(times)
    end
    return true
  end

  def self.lock_until_date(opu_id)
    policy = self.unscoped.by_opu(opu_id).first
    if policy
      return policy.lock_until_date
    end
    return nil
  end

end