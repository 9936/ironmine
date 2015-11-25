module Skm::EntryHeadersHelper
 def available_skm_statuses
   Skm::EntryStatus.enabled.multilingual.collect{|i|[i[:name],i.id]}
 end

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
        d1 = content_tag(:td, "", :class => "data-col")
        d2 = content_tag(:td, a.file_name, :class => "data-col")
        d3 = content_tag(:td, a.category_name, :class => "data-col")
        d4 = content_tag(:td, a.description, :class => "data-col")
        d5 = content_tag(:td, link_to(t(:delete), {:controller => "skm/entry_headers", :action => "remove_exits_attachment_during_create", :att_id => a.latest_version_id}, :remote => "true"), :class => "data-col")
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
        d1 = content_tag(:td, link_to(t(:delete), {:controller => "skm/entry_headers", :action => "remove_exits_attachment", :entry_header_id => entry_header_id, :att_id => a.latest_version_id},:confirm => t(:label_delete_confirm), :remote => "true"), :class => "label-col")
        d2 = content_tag(:td, a.file_name, :class => "data-col-1")
        d3 = content_tag(:td, a.category_name, :class => "data-col-2")
        d4 = content_tag(:td, a.description, :class => "data-col-3")
        #d5 = content_tag(:td, link_to(t(:delete), {:controller => "skm/entry_headers", :action => "remove_exits_attachment", :entry_header_id => entry_header_id, :att_id => a.latest_version_id},:confirm => t(:label_delete_confirm), :remote => "true"), :class => "data-col")

        r = content_tag(:tr, d1 + d2 + d3 + d4)# + d5)
        html << r
      end
    end
    raw(html)
  end

  def list_skm_entry_attachments(attachments, entry_header_id)
    html = ""
    if attachments && attachments.any?
      attachments.each do |a|
        version = a.last_version_entity
        d1 = content_tag(:td, "", {:class => "data-col", :style => "width:100%"})
        d2 = content_tag(:td, raw("<a target='_blank' href='#{version.data.url}' >#{version.data.original_filename}</a>"), {:class => "data-col", :style => "width:20%"})
        #d3 = content_tag(:td, a.category_name, :class => "data-col")
        d4 = content_tag(:td, a.description, :class => "data-col")
        d5 = content_tag(:td, link_to(t(:delete), {:controller => "skm/entry_headers", :action => "remove_exits_attachment", :entry_header_id => entry_header_id, :att_id => a.latest_version_id},:confirm => t(:label_delete_confirm), :remote => "true"), :class => "data-col")
        r = content_tag(:tr, raw(d2+ d5 + d1))
        html << r
      end
    end
    raw(html)
  end

  #查看知识库是否有拒绝的状态
  def has_approval_deny?(entry_header_id)
    Skm::EntryApprovalPerson.query_approval_deny_by_entry_header_id(entry_header_id).any?? true : false
  end

  #知识频道的审核人员可以编辑知识
  def can_edit_header?(entry_header)
    if entry_header.is_a?(String)
      entry_header = Skm::EntryHeader.where(:id => entry_header).first
    end
    if allow_to_function?(:edit_skm_entries)
      true
    elsif !entry_header[:channel_id] || entry_header[:author_id].eql?(Irm::Person.current.id)
      false
    else
      Skm::ChannelApprovalPerson.where(:channel_id => entry_header[:channel_id], :person_id => Irm::Person.current.id).any?
    end
  end

  def display_content(entry_header_id, text)
    text = text.gsub(/\r\n/, '<br/>')
    if params[:format].eql?("pdf")
      text = text.gsub(/\!\[\]\((.+?)\)/i){"<span class='image-container'><img class='page-break' src='#{request.protocol}#{request.host_with_port}#{$1}'/></span>"}
    else
      text = text.gsub(/\!\[\]\((.+?)\)/i){"<span class='image-container'><img src='#{$1}'/></span>"}
    end
    if params[:format].eql?("pdf")
      text.gsub(/\!(.+?\.(bmp|gif|jpg|jpe|jpeg|png))\!/){
        version = Irm::AttachmentVersion.where("source_id=? AND source_file_name=?", entry_header_id, $1).first
        if version.present?
          "<span class='image-container'><img class='page-break' src='#{request.protocol}#{request.host_with_port}#{version.url}'/></span>"
        end
      }
    else
      text.gsub(/\!(.+?\.(bmp|gif|jpg|jpe|jpeg|png))\!/){
        version = Irm::AttachmentVersion.where("source_id=? AND source_file_name=?", entry_header_id, $1).first
        if version.present?
          "<span class='image-container'><img src='#{version.url}'/></span>"
        end
      }
    end
  end

end