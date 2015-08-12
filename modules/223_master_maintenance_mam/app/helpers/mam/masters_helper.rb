module Mam::MastersHelper
  def mam_demo_label(demo_text, length_limit = '')
    color = '#7c7c7c'
    if length_limit.blank?
      val = "<div style='display:block;color:#{color}'>Example: #{demo_text}.</div>"
    else
      val = "<div style='display:block;color:#{color}'>Example: #{demo_text}. #{length_limit} characters limited.</div>"
    end
    return raw(val)
  end

  def process_mam_replies(msg)
    msg
  end

  def mam_can_close?(master)
    if allow_to_function?(:update_close) && !master.support_person_id.nil?
      return true
    else
      return false
    end
  end

  def mam_can_update_status?(master)
    if allow_to_function?(:update_status)
      return true
    else
      return false
    end
  end

  def mam_can_edit?(master)
    if allow_to_function?(:edit_master)
      return true
    else
      return false
    end
  end

  def mam_can_assign?(master)
    if allow_to_function?(:update_assign)
      return true
    else
      return false
    end
  end

  def mam_can_receive?(master)
    if allow_to_function?(:update_receive)
      return true
    else
      return false
    end
  end

  def available_master_status_code
    Irm::LookupValue.get_lookup_value("MAM_STATUS").where("lookup_code <> 'MAM_CLOSE'").collect{|a| [a[:meaning], a[:lookup_code]]}
  end

  def mam_available_support_group(system_id)
    val = Mam::SystemGroup.select_all.
        with_support_group(I18n.locale).
        where("system_id = ?", system_id).collect{|a| [a[:support_group_name], a[:support_group_id]]}
    return val
  end
end
