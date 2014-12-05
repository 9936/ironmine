module Mam::SystemsHelper
  def mam_ava_system_for_person(person_id)
    Mam::SystemPerson.
        joins(",#{Mam::System.table_name} sys").
        select("sys.system_name system_name, sys.id id").
        where("sys.id = #{Mam::SystemPerson.table_name}.system_id").
        where("person_id = ?", person_id).collect{|t| [t[:system_name], t[:id]]}
  end
end
