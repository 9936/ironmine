class Icm::Hooks::AddIncidentToHomePageHook < Fwk::Hook::Listener
  def  home_index_before_portal(context)
    puts "hook 6"
    "<div>test</div>"
  end
end