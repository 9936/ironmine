module Irm::SearchHelper
  # 高亮搜索结果
  def search_result_highlight(hit, field)
    field = field.to_sym
    if highlight = hit.highlight(field)
      raw highlight.format { |word| "<em>#{word}</em>" }
    else
      #限制整篇文章显示
      begin
        hit.result.send(field)
        truncate(hit.result.send(field),{:length => 1000,:omission => '......'})
      rescue
        nil
      end
    end
  end


  def entry_header_content(entry_header, limit=1000)
    content = ''
    if entry_header
      entry_header.entry_details.each do |detail|
        content += detail[:entry_content]
      end
    end
    omission = link_to("......", {:controller => "skm/entry_headers", :action=>"show",:id => entry_header[:id]})
    content = truncate(content,{:length => limit,:omission => omission})
    raw content
  end

  #初始化搜索选项设置
  def init_search_options(selected = params[:search_option_str].split(" "))
    search_entities = Ironmine::Acts::Searchable.searchable_entity
    search_options_hash = {}
    search_entities.each do |key, value|
      search_options_hash[key.to_s] = {:label =>t("label#{build_meaning(key)}"), :name => "search_option#{build_meaning(key)}"}
    end
    #search_options_hash = {Chm::ChangeRequest.name.to_s => {:label =>t(:label_chm_change_request), :name => "search_option_chm_change_request"},
    #                       Icm::IncidentRequest.name.to_s =>{:label=> t(:label_icm_incident_request), :name => "search_option_icm_incident_request"},
    #                       Skm::EntryHeader.name.to_s => {:label => t(:label_skm_entry_header), :name => "search_option_skm_entry"},
    #                       Irm::Bulletin.name.to_s => {:label => t(:label_irm_bulletin), :name => "search_option_irm_bulletin"},
    #                       Irm::AttachmentVersion.name.to_s => {:label => t(:label_search_attachment), :name => "search_option_irm_attachment"}}
    html = ''
    if selected.include?("ALL")
      li = "<li class='current'><em></em>#{t(:all)}<span class='check-btn'>"
      li += check_box_tag("search_option_all", "ALL", true,{:id => "searchAll", :class => "searchOptions"})
      li += "<span></li>"
    else
      li = "<li><em></em>#{t(:all)}<span class='check-btn'>"
      li += check_box_tag("search_option_all", "ALL", false,{:id => "searchAll", :class => "searchOptions"})
      li += "<span></li>"
    end
    html += li
    search_options_hash.each do |key, value|
      if selected.include?(key)
        li = "<li class='current'><em></em>#{value[:label]}<span class='check-btn'>"
        li += check_box_tag(value[:name], key, true, :class => "searchOptions")
        li += "<span></li>"
      else
        li = "<li><em></em>#{value[:label]}<span class='check-btn'>"
        li += check_box_tag(value[:name], key, false, :class => "searchOptions")
        li += "<span></li>"
      end
      html += li
    end
    html.html_safe
  end
  #分页显示记录
  def new_paginate(start_page = 1, total=0, page = 1, per_page = 10, current_to_pre=1)
    total_page = total % per_page == 0? total/per_page : total/per_page + 1
    page_html = ''
    if page > start_page
      page_html += link_to t(:label_search_previous_page), "javascript:void(0);", :page => page - current_to_pre.to_i
    end
    if page < total_page
      page_html += link_to t(:label_search_next_page), "javascript:void(0);", :page => page + 1
    end
    page_html.html_safe
  end

  #分页显示记录
  def init_paginate(total=0, page = 1, per_page = 10, limit_page = 10)
    #总的页码
    total_page = total % per_page == 0? total/per_page : total/per_page + 1
    page_html = ''

    if total_page >= page and page > 0 and total_page > 1
      #计算显示的开始页码和结尾页码
      start_page = page - (limit_page % 2 == 0? limit_page/2 - 1 : limit_page/2)
      end_page = page + limit_page/2
      if start_page < 1
        start_page = 1
        if total_page > limit_page
          end_page = limit_page
        else
          end_page = total_page
        end
      end
      if end_page > total_page
        end_page = total_page
        if (end_page - limit_page) > 0
          start_page = end_page - limit_page + 1
        else
          start_page = 1
        end
      end
      #显示前一页
      if page > 1
        page_html += link_to t(:label_search_previous_page), "javascript:void(0);", :page => page - 1
      end
      #显示中间页码
      (start_page..end_page).each do |i|
        if i.to_i.eql?(page.to_i)
          page_html += "<strong class='current'>#{i}</strong>"
        else
          page_html += link_to i.to_s, "javascript:void(0);", :page => i
        end
      end
      #显示下一页
      if page < total_page
        page_html += link_to t(:label_search_next_page), "javascript:void(0);", :page => page + 1
      end
    end
    page_html.html_safe
  end

  #初始化时间设置
  def init_time_limit(selected = '')
    unless selected.present?
      selected = 'all'
    end
    time_options_hash = {"all" => t(:label_before_forever),
                         "day" => t(:label_before_one_day),
                         "week" => t(:label_before_one_week),
                         "month" => t(:label_before_one_month),
                         "year" => t(:label_before_one_year)}
    html = ''
    time_options_hash.each do |key, value|
      if key.eql?(selected)
        li = "<li class='current'><em></em>#{value}<span class='check-btn'>"
        li += radio_button_tag :time_limit, key.to_s, true
        li += "<span></li>"
      else
        li = "<li><em></em>#{value}<span class='check-btn'>"
        li += radio_button_tag :time_limit, key.to_s, false
        li += "<span></li>"
      end
      html += li
    end
    html.html_safe
  end

  #过滤掉html标签
  def plain_text(html_input)
    sanitize(truncate(html_input,{:length => 100,:omission => '......'}), :tags=>["em"])
  end

  #根据模块显示搜索的配置可选项
  def init_search_option
    html = "<ul>"
    search_entities = Ironmine::Acts::Searchable.searchable_entity
    if search_entities.any? and search_entities.count == 1
      html += "<li style='width:100%;'>" + check_box_tag("search_option_all", "ALL", true,{:id => "checkAllSearchOptions", :class => "searchOptions"})
      html += "<label for='checkAllSearchOptions' style='display:inline-block'>#{t(:all)}</label></li>"
    end
    search_entities.each do |key, value|
      html += "<li>" + check_box_tag("#{value}", key, true, :class => "searchOptions")
      html += "<label for="+"search_option#{build_meaning(key)}"+" style='display:inline-block'>#{t("label#{build_meaning(key)}")}</label>"
      html += "</li>"
    end
    html += "</ul>"
    html.html_safe
  end

  def build_meaning(str)
    str.gsub(/::/,'').gsub(/([A-Z])/){ "_#{$1.downcase}" }
  end
end