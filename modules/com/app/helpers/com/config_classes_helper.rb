module Com::ConfigClassesHelper
  def available_config_classes
    all_config_classes = Com::ConfigClass.multilingual.where("leaf_flag=?", Irm::Constant::SYS_NO)

    if all_config_classes.nil? || !all_config_classes.present?
      []
    else
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
  end

  #将分类以树形展示
  def config_classes_tree_data
    config_classes = Com::ConfigClass.multilingual.enabled
    data = {:root=>[]}
    config_classes.each do |cc|
      #如果不是父级节点直接添加到根节点上，否则添加到对应的parent_id节点上
      if cc.parent_id.present?
        data[cc.parent_id] ||= []
        data[cc.parent_id] << cc
      else
        data[:root] << cc
      end
    end
    ul_html = "<ul id='config_classes_tree' class='treeview-red'>"
    data[:root].each do |cc|
      ul_html << build_tree(cc,data)
    end
    ul_html << "</ul>"
    raw ul_html
  end

  #构建树状结构
  def build_tree(cc, data)
    li_html = ''
    if data[cc.id].present?
      li_html << "<li>
                    <span class='name' >#{cc[:name]}</span>
                    <span class='actions'>#{link_to(t(:edit),{:action => "edit", :id => cc[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span> |
                    <span class='actions'>#{link_to(t(:show),{:action => "show", :id => cc[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span>
                    <ul>"
      #不是子节点才由新建action
      if cc[:leaf_flag].eql?(Irm::Constant::SYS_NO)
        li_html << "<li><span class='actions add-child'>#{link_to(t(:new),{:action => "new", :parent_id => cc[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span></li>"
      end
      data[cc.id].each do |sub_cc|
        li_html << build_tree(sub_cc,data)
      end
      li_html << "</ul></li>"
    else
      li_html << "<li><span class='name'>#{cc[:name]}</span>
                  <span class='actions'>#{link_to(t(:edit),{:action => "edit", :id => cc[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span> |
                  <span class='actions'>#{link_to(t(:show),{:action => "show", :id => cc[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span>"
      #不是子节点才由新建action
      if cc[:leaf_flag].eql?(Irm::Constant::SYS_NO)
        li_html << "<ul><li><span class='actions add-child'>#{link_to(t(:new),{:action => "new", :parent_id => cc[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span></li>"
        li_html << "</ul></li>"
      else
        li_html << "</li>"
      end
    end
    li_html
  end
end
