module Ndm::ProjectsHelper
  def get_project_list
    Ndm::Project.select_all.enabled.collect{|dp| [dp.name, dp.id]}
  end
end
