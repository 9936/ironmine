class Icm::Hooks::AddIncidentToHomePageHook < Fwk::Hook::Listener
  def  home_index_before_portal(context)
    "<div>test#{context.to_json}</test>"
  end
end