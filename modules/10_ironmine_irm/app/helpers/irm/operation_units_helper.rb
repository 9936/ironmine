module Irm::OperationUnitsHelper
  #根据当前运维中心的primary_person_id 显示名称
  def get_primary_person_name_by_id(person_id)
    admin = Irm::Person.select("full_name").where("id=?", person_id).first
    if admin and admin.present?
      admin[:full_name]
    else
      nil
    end
  end

  #根据当前的运维中心的id 查找用户  available
  def available_people_by_opu_id(opu_id)
    Irm::Person.select("id, full_name").where("opu_id=?", opu_id).collect{|i|[i[:full_name],i[:id]]}
  end
end
