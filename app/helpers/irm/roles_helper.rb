module Irm::RolesHelper
  def available_roles
    all_roles = Irm::Role.enabled.multilingual

    grouped_roles = all_roles.collect{|i| [i.id,i.report_to_role_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    roles = {}
    all_roles.each do |ao|
      roles.merge!({ao.id=>ao})
    end
    leveled_roles = []

    proc = Proc.new{|parent_id,level|
      if(grouped_roles[parent_id.to_s]&&grouped_roles[parent_id.to_s].any?)

        grouped_roles[parent_id.to_s].each do |o|
          roles[o[0]].level = level
          leveled_roles << roles[o[0]]

          proc.call(roles[o[0]].id,level+1)
        end
      end
    }


    grouped_roles["blank"].each do |go|
      roles[go[0]].level = 1
      leveled_roles << roles[go[0]]
      proc.call(roles[go[0]].id,2)
    end

    leveled_roles.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}

  end


  def available_parentable_role(role_id=nil)
    unless role_id.present?
      return available_roles
    end

    all_roles = Irm::Role.enabled.parentable(role_id).multilingual

    grouped_roles = all_roles.collect{|i| [i.id,i.report_to_role_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    roles = {}
    all_roles.each do |ao|
      roles.merge!({ao.id=>ao})
    end
    leveled_roles = []

    proc = Proc.new{|parent_id,level|
      if(grouped_roles[parent_id.to_s]&&grouped_roles[parent_id.to_s].any?)

        grouped_roles[parent_id.to_s].each do |o|
          roles[o[0]].level = level
          leveled_roles << roles[o[0]]

          proc.call(roles[o[0]].id,level+1)
        end
      end
    }


    grouped_roles["blank"].each do |go|
      roles[go[0]].level = 1
      leveled_roles << roles[go[0]]
      proc.call(roles[go[0]].id,2)
    end

    leveled_roles.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}
  end



end