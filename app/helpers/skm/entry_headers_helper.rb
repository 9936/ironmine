module Skm::EntryHeadersHelper
  def show_last_ten_entry_header
    entry_headers = Skm::EntryHeader.list_all.published.current_entry.order("updated_at DESC").limit(10)
    html_content = ""
    entry_headers.each do |e|
      html_content << content_tag(:tr,
                                  content_tag(:td, link_to(get_list_icon + e.entry_title, {:controller => "skm/entry_headers", :action => "show", :id => e.id}, {:title => e.entry_title})))
    end
    raw(html_content)
  end

  def show_skm_sidebar_navigate
    html_content = ""
    base_content = ""
    #根据Feature #1176 移除此功能
    raw(base_content)
  end

  def list_exist_attachments_during_create(attachments)
    html = ""
    if attachments && attachments.any?
      attachments.each do |a|
        d1 = content_tag(:td, "", :class => "dataCol")
        d2 = content_tag(:td, link_to(t(:delete), {:controller => "skm/entry_headers", :action => "remove_exits_attachment_during_create", :att_id => a.latest_version_id}, :remote => "true"), :class => "dataCol")
        d3 = content_tag(:td, a.file_name, :class => "dataCol")
        d4 = content_tag(:td, a.category_name, :class => "dataCol")
        d5 = content_tag(:td, a.description, :class => "dataCol")
        r = content_tag(:tr, d1 + d2 + d3 + d4 + d5)
        html << r
      end
    end
    raw(html)
  end

  def list_exist_skm_entry_attachments(attachments, entry_header_id)
    html = ""
    if attachments && attachments.any?
      attachments.each do |a|
        d1 = content_tag(:td, "", :class => "dataCol")
        d2 = content_tag(:td, link_to(t(:delete), {:controller => "skm/entry_headers", :action => "remove_exits_attachment", :entry_header_id => entry_header_id, :att_id => a.latest_version_id},:confirm => t(:label_delete_confirm), :remote => "true"), :class => "dataCol")
        d3 = content_tag(:td, a.file_name, :class => "dataCol")
        d4 = content_tag(:td, a.category_name, :class => "dataCol")
        d5 = content_tag(:td, a.description, :class => "dataCol")
        r = content_tag(:tr, d1 + d2 + d3 + d4 + d5)
        html << r
      end
    end
    raw(html)
  end
end