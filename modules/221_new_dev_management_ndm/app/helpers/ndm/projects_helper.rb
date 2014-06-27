module Ndm::ProjectsHelper
  def get_project_list
    Ndm::Project.with_member(Irm::Person.current.id).select_all.enabled.collect{|dp| [dp.name, dp.id]}
  end

  def get_project_newable_list
    Ndm::Project.with_newable_member(Irm::Person.current.id).select_all.enabled.collect{|dp| [dp.name, dp.id]}
  end

  def get_importable_project_list
    Ndm::Project.with_importable_member(Irm::Person.current.id).select_all.enabled.collect{|dp| [dp.name, dp.id]}
  end
end
