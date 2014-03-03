module Dem::ProjectsHelper
  def get_project_list
    Dem::Project.select_all.enabled.collect{|dp| [dp.name, dp.id]}
  end
end
