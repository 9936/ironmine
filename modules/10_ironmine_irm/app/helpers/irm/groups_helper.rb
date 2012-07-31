module Irm::GroupsHelper

  def available_group
    all_groups = Irm::Group.enabled.multilingual

    grouped_groups = all_groups.collect{|i| [i.id,i.parent_group_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    groups = {}
    all_groups.each do |ao|
      groups.merge!({ao.id=>ao})
    end
    leveled_groups = []

    proc = Proc.new{|parent_id,level|
      if(grouped_groups[parent_id.to_s]&&grouped_groups[parent_id.to_s].any?)

        grouped_groups[parent_id.to_s].each do |o|
          groups[o[0]].level = level
          leveled_groups << groups[o[0]]

          proc.call(groups[o[0]].id,level+1)
        end
      end
    }

    return [] unless grouped_groups["blank"]&&grouped_groups["blank"].any?
    grouped_groups["blank"].each do |go|
      groups[go[0]].level = 1
      leveled_groups << groups[go[0]]
      proc.call(groups[go[0]].id,2)
    end

    leveled_groups.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}

  end


  def available_parentable_group(group_id=nil)
    unless group_id.present?
      return available_group
    end

    all_groups = Irm::Group.enabled.parentable(group_id).multilingual

    grouped_groups = all_groups.collect{|i| [i.id,i.parent_group_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    groups = {}
    all_groups.each do |ao|
      groups.merge!({ao.id=>ao})
    end
    leveled_groups = []

    proc = Proc.new{|parent_id,level|
      if(grouped_groups[parent_id.to_s]&&grouped_groups[parent_id.to_s].any?)

        grouped_groups[parent_id.to_s].each do |o|
          groups[o[0]].level = level
          leveled_groups << groups[o[0]]

          proc.call(groups[o[0]].id,level+1)
        end
      end
    }

    return [] unless grouped_groups["blank"]&&grouped_groups["blank"].any?
    grouped_groups["blank"].each do |go|
      groups[go[0]].level = 1
      leveled_groups << groups[go[0]]
      proc.call(groups[go[0]].id,2)
    end

    leveled_groups.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}


  end
end
