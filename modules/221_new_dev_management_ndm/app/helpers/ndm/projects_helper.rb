module Ndm::ProjectsHelper
  def get_project_list
    Ndm::Project.with_member(Irm::Person.current.id).select_all.enabled.collect{|dp| [dp.name, dp.id]}
  end
end
