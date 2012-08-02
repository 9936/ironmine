module Irm::LicensesHelper
  def available_license
    Irm::License.multilingual.enabled.collect{|i| [i[:name],i.id]}
  end

  def available_grouped_functions(function_ids=[])
    fs = Irm::Function.multilingual.enabled.with_function_group(I18n.locale).where(:public_flag=>Irm::Constant::SYS_NO,:login_flag=>Irm::Constant::SYS_NO)
    if function_ids.any?
      fs.delete_if{|i| !function_ids.include?(i.id)}
    end
    fs.group_by{|i| i[:zone_code]}
  end
end
