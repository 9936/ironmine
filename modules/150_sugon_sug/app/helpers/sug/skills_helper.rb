module Sug::SkillsHelper
  def available_skills
    Sug::Skill.enabled
  end
end
