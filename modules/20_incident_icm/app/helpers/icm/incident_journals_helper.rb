module Icm::IncidentJournalsHelper
  def prepare_request_files(incident_request)
    # file belongs to journal
    @request_files = Irm::AttachmentVersion.query_all.query_by_incident_request(incident_request.id).group_by{|a| a.source_id}
    # file belongs to request
    files_belong_to_request = Irm::AttachmentVersion.query_incident_request_file((incident_request.id))

    @request_files.merge!({0=>files_belong_to_request}) if files_belong_to_request.size > 0 #防止事故单没有附件的时候, 产生一个空的数组
  end

  def list_all_files
    html = ""
    @request_files.values.flatten.each do |e|
      html << "<div style='padding-bottom:5px;'><a target='_blank' href='#{e.data.url}' stats="">
              <div class='file-info'><div title='#{e.data.original_filename}' class='file-name'><b>#{e.data.original_filename}(#{e.file_size_kb}KB)</b></div>
              </div></a></div>"
    end
    raw(html)
  end

  def list_request_file

    return if @request_files[0].nil?||@request_files[0].size<1
    file_lists = ""
    @request_files[0].each do |f|
      file_lists << show_file(f)
    end
    content_tag(:div,file_lists.html_safe,{:class=>"file-list"})
  end

  def list_journals(incident_request)
    journals = Icm::IncidentJournal.list_all(incident_request.id).with_enabled.enabled.includes(:incident_histories).default_order
    unless params[:format].eql?('pdf')
      render :partial=>"icm/incident_journals/list_journals",:locals=>{:journals=>journals,:grouped_files=>@request_files}
    else
      journals
    end
  end

  def display_all_journals?(incident_request)
    if has_offline_journals?(incident_request)
      if allow_to_function?(:delete_recover_any_journals)
        return true
      elsif allow_to_function?(:delete_recover_my_journals) and has_my_offline_journasl?(incident_request)
         return true
      else
        return false
      end
    else
      return false
    end
  end

  def has_offline_journals?(incident_request)
    Icm::IncidentJournal.with_offline.list_all(incident_request.id).any?
  end

  def has_my_offline_journasl?(incident_request)
    Icm::IncidentJournal.with_replied_person(Irm::Person.current.id).list_all(incident_request.id).any?
  end

  def list_all_journals(incident_request)
    if allow_to_function?(:delete_recover_any_journals)
      journals = Icm::IncidentJournal.list_all(incident_request.id).includes(:incident_histories).default_order
    else
      journals = Icm::IncidentJournal.list_all(incident_request.id).with_mine_all(Irm::Person.current.id).includes(:incident_histories).default_order
    end
    render :partial=>"icm/incident_journals/list_all_journals",:locals=>{:journals=>journals,:grouped_files=>@request_files}
  end

  def journals_size(incident_request)
    Icm::IncidentJournal.with_enabled.list_all(incident_request.id).size
  end

  def all_journals_size(incident_request)
    Icm::IncidentJournal.list_all(incident_request.id).size
  end

  def list_journal_files(grouped_files,journal)
    return if grouped_files[journal.id].nil?||grouped_files[journal.id].size<1
    file_lists = ""
    grouped_files[journal.id].each do |f|
      file_lists << show_file(f)
    end
     content_tag(:div,file_lists.html_safe,{:class=>"file-list"})
  end

  # show file
  def show_file(f, with_image = true)
    image_path = nil
    image_path = f.data.url(:thumb) if f.image?
    image_path = theme_image_path(Irm::AttachmentVersion.file_type_icon(f.data.original_filename)) unless image_path
    link = ""
    link = "<div class='file-icon' style='*display:inline-block;'>#{image_tag(image_path,:alt => "#{f.description}", :title => "#{f.description}",:style => "width:20px;height:20px;") }</div>" if with_image
    description = "<a target='_blank' href='#{f.data.url}' stats='' style='float:left'>
                    <div class='file-info'>
                      <div title='#{f.data.original_filename}' class='file-name'><b>#{f.data.original_filename}</b></div>
                    </div>
                   </a>"
    delete_link = ""
    delete_link << "<a data-remote=true data-confirm='#{I18n.t(:label_delete_confirm)}' href='#{url_for(:controller => "icm/incident_requests",
                                               :action => "remove_attachment",
                                               :attachment_id => f.id)}'>#{btn_delete_icon}</a>" if allow_to_function?(:remove_attachment) || f.created_by == Irm::Person.current.id
    content_tag(:div, (content_tag(:div, link.html_safe + description.html_safe, {:class=>"file-item"}) +
        "&nbsp;&nbsp;".html_safe + delete_link.html_safe).html_safe,{:class=>"fileItem"}).html_safe
  end

  def process_message(msg)
    file_names = msg.scan(/!([a-zA-Z\d\-_]+\.[a-z]+)!/)
    file_names.each do |file_name_array|
      file_name = file_name_array[0]
      @request_files.each do |key,files|
        file = files.detect{|f| f.data.original_filename.eql?(file_name)}
        if(file&&file.image?)
          msg = msg.gsub(/!#{file_name}!/,"<img  class='msgImage' title='#{file.data.original_filename}\n#{file.description}' src='#{file.data.url}'/>")
          break
        end
      end
    end
    msg
  end

  def incident_close_code
    close = Icm::IncidentStatus.enabled.query_by_close_flag(Irm::Constant::SYS_YES).first
    close ||= {:incident_status_code=>"CLOSE_STATUS"}
    close[:incident_status_code]
  end

  def available_close_code
    Icm::CloseReason.multilingual.collect{|i|[i[:name],i.id]}
  end


  def available_passable_supporter(group_id)
    people =  Irm::GroupMember.select_all.with_person(I18n.locale).assignable.query_by_support_group(group_id).order("CONVERT( #{Irm::Person.table_name}.full_name USING gbk )").collect{|p|[p[:person_name],p[:person_id]]}
    people.delete_if{|p| Irm::Person.current.id.eql?(p[1])}
  end

  def available_upgradable_supporter(group_id)
    support_group = Icm::SupportGroup.query(group_id).first
    return [] unless support_group&&support_group.parent_group_id
    people =  Irm::GroupMember.select_all.with_person(I18n.locale).assignable.query_by_support_group(support_group.parent_group_id).order_id.collect{|p|[p[:person_name],p[:person_id]]}
    people
  end


  def upgrade_support_group_name(group_id)
    support_group = Icm::SupportGroup.query(group_id).first
    return "" unless support_group&&support_group.parent_group_id
    Icm::SupportGroup.query(support_group.parent_group_id).with_group(I18n.locale).first[:name]
  end

end
