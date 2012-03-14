module Com::ConfigClassesHelper
  def available_config_classes
    all_config_classes = Com::ConfigClass.multilingual.where("leaf_flag=?", Irm::Constant::SYS_NO)

    grouped_config_classes = all_config_classes.collect{|i| [i.id,i.parent_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    config_classes = {}
    all_config_classes.each do |ac|
      config_classes.merge!({ac.id=>ac})
    end
    leveled_config_classes = []
    proc = Proc.new{|parent_id,level|
      if grouped_config_classes[parent_id.to_s]&&grouped_config_classes[parent_id.to_s].any?

        grouped_config_classes[parent_id.to_s].each do |o|
          config_classes[o[0]].level = level
          leveled_config_classes << config_classes[o[0]]

          proc.call(config_classes[o[0]].id,level+1)
        end
      end
    }
    grouped_config_classes["blank"].each do |go|
      config_classes[go[0]].level = 1
      leveled_config_classes << config_classes[go[0]]
      proc.call(config_classes[go[0]].id,2)
    end

    leveled_config_classes.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}
  end

  def level_str(level=1)
    if level.eql?(1)
      return ""
    else
      str = ""
      (level-1).times do
        str << "&nbsp;&nbsp;&nbsp;&nbsp;"
      end
    end
    str
  end
end
