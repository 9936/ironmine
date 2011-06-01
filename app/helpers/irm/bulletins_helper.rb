module Irm::BulletinsHelper
  def ava_access_companies
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
    accessable_companies = Irm::Company.multilingual.query_by_ids(accesses)
    accessable_companies.collect{|p| [p[:name], p.id]}
  end

  def ava_access_organizations
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
    accessable_organizations = Irm::Organization.multilingual.query_wrap_info(I18n.locale).enabled.where("#{Irm::Organization.table_name}.company_id IN (?)", accesses)
    accessable_organizations.collect{|p| [p[:company_name] + "-" + p[:name], p.id]}
  end

  def ava_access_departments
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
#    accessable_companies = Irm::Company.multilingual.query_by_ids(accesses)
    departments = []
    accesses.each do |t|
      te = Irm::Department.multilingual.query_wrap_info(I18n.locale).enabled.where("#{Irm::Department.table_name}.company_id = ?", t)
      departments = departments + te if te.size > 0
    end

    departments = departments.uniq
    departments.collect{|p| [p[:company_name] +"-" +p[:organization_name] +"-" +p[:name], p.id]}
  end

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
    accesses = ava_access_companies
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Company.name.underscore.gsub("\/","_"))}:#{a[0]}","C##{a[1]}",{:query=>a[0],:type=>"C"}]
    end
    #Organization
    accesses = ava_access_organizations
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Organization.name.underscore.gsub("\/","_"))}:#{a[0]}","O##{a[1]}",{:query=>a[0],:type=>"O"}]
    end
    #Department
    accesses = ava_access_departments
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
end