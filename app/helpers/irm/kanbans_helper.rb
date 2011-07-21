module Irm::KanbansHelper
  def ava_kanban_ranges
    selectable_options = []

    #Company
    targets = current_person_accessible_companies_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Company.name.underscore.gsub("\/","_"))}:#{a[0]}","C##{a[1]}",{:query=>a[0],:type=>"C"}]
    end
    #Organization
    targets = current_person_accessible_organizations_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Organization.name.underscore.gsub("\/","_"))}:#{a[0]}","O##{a[1]}",{:query=>a[0],:type=>"O"}]
    end
    #Department
    targets = current_person_accessible_departments_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Department.name.underscore.gsub("\/","_"))}:#{a[0]}","D##{a[1]}",{:query=>a[0],:type=>"D"}]
    end
    #Person
    targets = current_person_accessible_people_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Person.name.underscore.gsub("\/","_"))}:#{a[0]}","P##{a[1]}",{:query=>a[0],:type=>"P"}]
    end
    #Role
    accesses = ava_access_roles
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Role.name.underscore.gsub("\/","_"))}:#{a[0]}","R##{a[1]}",{:query=>a[0],:type=>"R"}]
    end
    selectable_options
  end

  def own_kanban_ranges(kanban_id)
    assignment_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"],[Irm::Person,"P"]]
    own_assignments = Irm::KanbanRange.where(:kanban_id => kanban_id, :status_code => Irm::Constant::ENABLED)

    assignments = []
    own_assignments.each do |assignment|
      assignment_type = assignment_types.detect{|i| i[0].name.eql?(assignment.range_type)}
      assignments<<"#{assignment_type[1]}##{assignment.range_id}"
    end

    assignments.join(",")
  end

  def show_kanban(kanban_id = 1)
    lanes = Irm::Lane.multilingual.query_by_kanban(kanban_id).with_sequence
    lanes_tags = ""
    cards_tags = ""
    lanes.each do |la|
      if la == lanes.first
        position = "l"
      elsif la == lanes.last
        position = "r"
      else
        position = "c"
      end

      lanes_tags << content_tag(:th, content_tag(:div, la[:name]), {:align => "center", :class => "th_" + position})
      ct = ""
      cards = la.cards.multilingual
      cards_array = []
      cards.each do |ca|

        ca_result = ca.prepare_card_content(la.limit)

        ca_result.collect{|p| [p[:id],
                               p[ca.title_attribute_name.to_sym],
                               p[ca.description_attribute_name.to_sym],
                               p[ca.date_attribute_name.to_sym],
                               ca[:background_color],
                               begin
                                 url = ca[:card_url]
                                 ca[:card_url].scan(/\{\S*\}/).each do |cu|
                                   t = cu.clone
                                   cu.gsub!(/[\{\}]/,"")
                                   url.gsub!(t, p[cu.to_sym].to_s)
                                 end
                                 url
                               rescue
                                 "javascript:void(0);"
                               end
                               ]}.each do |cap|
          cards_array << cap
        end
      end

      cards_array.each do |c_array|
        title_tag = content_tag(:tr, content_tag(:td, c_array[1], :class => "card-title"))
        description_tag = content_tag(:tr, content_tag(:td, plain_text(c_array[2]), :class => "card-content"))
        date_tag = content_tag(:div, c_array[3].to_time.strftime("%F %T"), :class => "card-date")

        ct << content_tag(:a,
                content_tag(:div,
                  content_tag(:div, content_tag(:table, raw(title_tag) + raw(description_tag)), :class => "card-div") + raw(date_tag),
                  {:class => "card", :style => "background-color:" + c_array[4]}), {:href=>c_array[5]})
      end

      cards_tags << content_tag(:td, raw(ct), {:class => "td_" + position, :align => "center"})
    end
    lanes_tags = content_tag(:tr, raw(lanes_tags))
    cards_tags = content_tag(:tr, raw(cards_tags))

    kanban_table = content_tag(:table, raw(lanes_tags) + raw(cards_tags), {:cellspacing => "0", :cellpadding => "0"})
    kanban_main = content_tag(:div, raw(kanban_table), {:class => "kanban_body", :style => "width:100%"})

    kanban_main
  end

  def current_person_available_kanbans_array
    Irm::Person.current
  end
end