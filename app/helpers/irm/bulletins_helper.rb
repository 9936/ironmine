module Irm::BulletinsHelper
  def ava_access_roles
    roles = Irm::Role.multilingual.enabled.where("#{Irm::Role.table_name}.company_id = ?", Irm::Company.current.id)
    roles.collect{|p| [p[:name], p.id]}
  end

  def show_accesses(bulletin)
    ba = Irm::BulletinAccess.list_all(bulletin.id)
    tags = ""
    line_count = 0
    ba.each do |t|
      if t.access_type == "DEPARTMENT"
        tags = tags + content_tag(:tr,
                                content_tag(:td, t(:label_irm_bulletin_selected_departments), {:class => "labelCol"}) +
                                content_tag(:td, raw(t.name + content_tag(:a, raw("&nbsp;&nbsp;") + t(:delete), {:href => "javascript:void(0);", :onclick => "remove_line('" + line_count.to_s+ "');"})), {:class => "data2Col"}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][type]", :value => t.access_type}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][access_id]", :value => t.access_id}),
                                {:id => "tr_" + line_count.to_s})
      elsif t.access_type == "ORGANIZATION"
        tags = tags + content_tag(:tr,
                                content_tag(:td, t(:label_irm_bulletin_selected_organizations), {:class => "labelCol"}) +
                                content_tag(:td, raw(t.name + content_tag(:a, raw("&nbsp;&nbsp;") + t(:delete), {:href => "javascript:void(0);", :onclick => "remove_line('" + line_count.to_s+ "');"})), {:class => "data2Col"}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][type]", :value => t.access_type}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][access_id]", :value => t.access_id}),
                                {:id => "tr_" + line_count.to_s})
      elsif t.access_type == "COMPANY"
        tags = tags + content_tag(:tr,
                                content_tag(:td, t(:label_irm_bulletin_selected_companies), {:class => "labelCol"}) +
                                content_tag(:td, raw(t.name + content_tag(:a, raw("&nbsp;&nbsp;") + t(:delete), {:href => "javascript:void(0);", :onclick => "remove_line('" + line_count.to_s+ "');"})), {:class => "data2Col"}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][type]", :value => t.access_type}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][access_id]", :value => t.access_id}),
                                {:id => "tr_" + line_count.to_s})
      elsif t.access_type == "ROLE"
        tags = tags + content_tag(:tr,
                                content_tag(:td, t(:label_irm_bulletin_selected_roles), {:class => "labelCol"}) +
                                content_tag(:td, raw(t.name + content_tag(:a, raw("&nbsp;&nbsp;") + t(:delete), {:href => "javascript:void(0);", :onclick => "remove_line('" + line_count.to_s+ "');"})), {:class => "data2Col"}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][type]", :value => t.access_type}) +
                                content_tag(:input, "", {:type => "hidden", :name => "accesses[" +line_count.to_s+ "][access_id]", :value => t.access_id}),
                                {:id => "tr_" + line_count.to_s})
      end
      line_count += 1;
    end
    raw(tags)
  end

  def ava_bulletin_accesses
    selectable_options = []
#    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]

    #Company
    accesses = current_person_accessible_companies_full
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Company.name.underscore.gsub("\/","_"))}:#{a[0]}","C##{a[1]}",{:query=>a[0],:type=>"C"}]
    end
    #Organization
    accesses = current_person_accessible_organizations_full
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Organization.name.underscore.gsub("\/","_"))}:#{a[0]}","O##{a[1]}",{:query=>a[0],:type=>"O"}]
    end
    #Department
    accesses = current_person_accessible_departments_full
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Department.name.underscore.gsub("\/","_"))}:#{a[0]}","D##{a[1]}",{:query=>a[0],:type=>"D"}]
    end
    #Role
    accesses = ava_access_roles
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Role.name.underscore.gsub("\/","_"))}:#{a[0]}","R##{a[1]}",{:query=>a[0],:type=>"R"}]
    end

    selectable_options
  end

  def own_bulletin_accesses(bulletin_id)
    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]
    bulletin_accesses = Irm::BulletinAccess.where(:bulletin_id => bulletin_id, :status_code => Irm::Constant::ENABLED)
    accesses = []
    bulletin_accesses.each do |access|
      access_type = access_types.detect{|i| i[0].name.eql?(access.access_type)}
      accesses<<"#{access_type[1]}##{access.access_id}"
    end
    accesses.join(",")
  end

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
        d2 = content_tag(:td, link_to(t(:delete),
                                      {:controller => "irm/bulletins", :action => "remove_exits_attachments",
                                       :att_id => a.latest_version_id, :bulletin_id => bulletin.id}, :remote => "true", :confirm => t(:label_are_you_sure)), :class => "dataCol")
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