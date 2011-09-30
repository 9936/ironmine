module Irm::BuColumnsHelper
  def available_parentable_bu_columns(column_id = nil)
    unless column_id.present?
      return available_bu_columns
    end

    all_columns = Irm::BuColumn.enabled.parentable(column_id).multilingual

    grouped_columns = all_columns.collect{|i| [i.id,i.parent_column_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    columns = {}
    all_columns.each do |ao|
      columns.merge!({ao.id=>ao})
    end
    leveled_columns = []

    proc = Proc.new{|parent_id,level|
      if(grouped_columns[parent_id.to_s] && grouped_columns[parent_id.to_s].any?)

        grouped_columns[parent_id.to_s].each do |o|
          columns[o[0]].level = level
          leveled_columns << columns[o[0]]

          proc.call(columns[o[0]].id,level+1)
        end
      end
    }

    grouped_columns["blank"].each do |go|
      columns[go[0]].level = 1
      leveled_columns << columns[go[0]]
      proc.call(columns[go[0]].id,2)
    end if grouped_columns["blank"]

    leveled_columns.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}
  end

  def available_bu_columns
    all_columns = Irm::BuColumn.enabled.multilingual

    grouped_columns = all_columns.collect{|i| [i.id,i.parent_column_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    columns = {}
    all_columns.each do |ao|
      columns.merge!({ao.id=>ao})
    end
    leveled_columns = []

    proc = Proc.new{|parent_id,level|
      if(grouped_columns[parent_id.to_s]&&grouped_columns[parent_id.to_s].any?)

        grouped_columns[parent_id.to_s].each do |o|
          columns[o[0]].level = level
          leveled_columns << columns[o[0]]

          proc.call(columns[o[0]].id,level+1)
        end
      end
    }


    grouped_columns["blank"].each do |go|
      columns[go[0]].level = 1
      leveled_columns << columns[go[0]]
      proc.call(columns[go[0]].id,2)
    end if grouped_columns["blank"]

    leveled_columns.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}

  end
end