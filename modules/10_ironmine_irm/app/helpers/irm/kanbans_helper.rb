module Irm::KanbansHelper
  def show_kanban(profile_id, position_code, mode = "0")
    kanban = Irm::Kanban.select_all.query_by_position_and_profile(profile_id, position_code).enabled
    return false unless kanban.any?
    kanban = kanban.first
    lanes = Irm::Lane.multilingual.query_by_kanban(kanban.id).with_sequence
    lanes_tags = ""
    cards_tags = ""
    lanes.each do |la|
      lane_cards_count = 0

      if la == lanes.first
        position = "l"
      elsif la == lanes.last
        position = "r"
      else
        position = "c"
      end

      ct = ""
      cards = la.cards.multilingual
      cards_array = []
      cards.each do |ca|
        ca_result = ca.prepare_card_content(kanban[:limit],[])
        ca_result.each do |cr|
          begin
           url = ca[:card_url].clone
           ca[:card_url].scan(/\{\S*\}/).each do |cu|
             t = cu.clone
             t2 = cu.clone
             t2.gsub!(/[\{\}]/,"")
             url.gsub!(t, cr[t2.to_sym].to_s)
           end
           cr[:card_url] = url
          rescue
           cr[:card_url] = "javascript:void(0);"
          end
        end if ca_result

        ca_result.collect{|p| [p[:id],
                               p[ca.title_attribute_name.to_sym],
                               p[ca.description_attribute_name.to_sym],
                               p[ca.date_attribute_name.to_sym],
                               ca[:background_color],
                               p[:card_url],
                               ]}.each do |cap|
          cards_array << cap
        end if ca_result
      end
      cards_array.sort!{|x, y| y[3] <=> x[3]}

      lane_cards_count = lane_cards_count + cards_array.size

      cards_array.each do |c_array|
        title_tag = content_tag(:tr, content_tag(:td, c_array[1], :class => "card-title"))
        description_tag = content_tag(:tr, content_tag(:td, plain_text(c_array[2]), :class => "card-content"))
        date_tag = content_tag(:div, c_array[3].to_time.strftime("%F %T"), :class => "card-date")

        ct << content_tag(:a,
                content_tag(:div,
                  content_tag(:div, content_tag(:table, raw(title_tag) + raw(description_tag)), :class => "card-div") + raw(date_tag),
                  {:class => "card", :rel=>"popover","data-original-title"=>c_array[1], "data-content" => c_array[1] + ": " + c_array[2], :style => "background-color:" + c_array[4]}), {:href=>c_array[5]})

        break if c_array == cards_array[kanban[:limit] - 1] #超过限制数时跳出
      end
      lanes_tags << content_tag(:th, content_tag(:div, la[:name] + "(" + lane_cards_count.to_s + "/" + kanban[:limit].to_s + ")"), {:align => "center", :class => "th_" + position})
      cards_tags << content_tag(:td, raw(ct), {:class => "td_" + position, :align => "center"})
    end
    lanes_tags = content_tag(:tr, raw(lanes_tags))
    cards_tags = content_tag(:tr, raw(cards_tags))

    kanban_table = content_tag(:table, raw(lanes_tags) + raw(cards_tags), {:cellspacing => "0", :cellpadding => "0"})
    kanban_main = content_tag(:div, raw(kanban_table), {:class => "kanban_body", :style => "width:100%"})

    if mode == "0"
      return kanban_main
    else
      return ""
    end
  end

  def current_person_available_kanbans_array
    Irm::Person.current
  end

  def available_seconds
    #当前用户看板默认自动刷新时间
    options = []
    (5..60).step(5).each do |i|
      options << [t(:after_n_fresh, :n=> i),i]
    end
    options << [t(:not_auto_refresh),-1]
    options
  end

  def available_kanbans
    kanbans = Irm::Kanban.multilingual.enabled
    kanbans.collect{|p| [p[:name], p.id]}
  end

  def profile_available_kanban_positions(profile_id)
    profile_kanban_pos = Irm::ProfileKanban.select_all.with_position_name.where("profile_id = ?", profile_id).collect(&:position_code)
    positions = Irm::LookupValue.multilingual.enabled.where("lookup_code NOT IN (?)", profile_kanban_pos + ['']).where("lookup_type=?","IRM_KANBAN_POSITION")
    positions = positions.collect{|p| [p[:meaning], p.lookup_code]}
    positions
  end

  def available_kanbans_by_position(position_code)
    kanbans = Irm::Kanban.multilingual.enabled.where(:position_code => position_code)
    kanbans.collect{|p| [p[:name], p.id]}
  end
end