module Irm::BulletinsHelper

  def prepare_bulletin_files(bulletin)
    # file belongs to journal
    @bulletin_files = Irm::AttachmentVersion.query_all.where(:source_id => bulletin.id).where(:source_type => Irm::Bulletin.name)
    @bulletin_files
  end

  def list_bulletin_file

    return if @bulletin_files.nil?
    file_lists = ""
    @bulletin_files.each do |f|
      description = "<a target='_blank' href='#{f.data.url}' stats=""><div class='fileInfo'><div title='#{f.data.original_filename}' class='fileName'><b>#{f.data.original_filename}</b>&nbsp;(#{f.file_size_kb} KB)</div>
                     <div title='#{f.description}' class='fileDesc'>#{f.description}</div></div></a>"
      file_lists << content_tag(:div, description.html_safe,{:class=>"fileItem"}).html_safe
    end
    content_tag(:div,file_lists.html_safe,{:class=>"fileList"})
  end

  def list_bulletin_existed_attachments(bulletin)
    html = ""
    attachments = Irm::Attachment.list_all.where("source_id = ? AND source_type = ?", bulletin.id, Irm::Bulletin.name)
    if attachments && attachments.any?
      attachments.each do |a|
        d1 = content_tag(:td, "", :class => "dataCol")
        d2 = content_tag(:td, a.file_name, :class => "dataCol")
        d3 = content_tag(:td, a.category_name, :class => "dataCol")
        d4 = content_tag(:td, a.description, :class => "dataCol")
        d5 = content_tag(:td, link_to(t(:delete),{:controller => "irm/bulletins", :action => "remove_exits_attachments",:att_id => a.latest_version_id, :bulletin_id => bulletin.id}, :remote => "true", :confirm => t(:label_are_you_sure)), :class => "dataCol")
        r = content_tag(:tr, d1 + d2 + d3 + d4 + d5)
        html << r
      end
    end
    raw(html)
  end
end