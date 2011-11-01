module Irm::ReportsHelper
  def report_category_type_script
    report_types = Irm::ReportType.multilingual.collect{|i| [i[:name],i.id,i.category_id,i[:description]]}
    report_types_hash = {}
    report_types.each do |rt|
      if(report_types_hash[rt[2]])
        report_types_hash[rt[2]] << rt
      else
        report_types_hash[rt[2]] = [rt]
      end
    end
    content_for(:page_script,"var reportTypeData = #{report_types_hash.to_json};".html_safe)
  end


  def report_page_step_title
    ["",I18n.t(:label_irm_report_step_report_type),
     I18n.t(:label_irm_report_step_base_info),
     I18n.t(:label_irm_report_step_column),
     I18n.t(:label_irm_report_step_group),
     I18n.t(:label_irm_report_step_data_filter)]
  end

  def available_report_sections(report_type_id)
    Irm::ReportTypeSection.where(:report_type_id=>report_type_id).collect{|i| [i[:name],i.id]}
  end

  def available_report_fields(report_type_id)
    report_type_sections = Irm::ReportTypeSection.where(:report_type_id=>report_type_id)
    report_type_fields = Irm::ReportTypeField.select_all.query_by_report_type(report_type_id).with_bo_object_attribute(I18n.locale)
    sections_hash = {}
    report_type_sections.each{|i| sections_hash.merge!(i.id=>i.name)}
    report_fields = []
    report_type_fields.each do |rtf|
      if(sections_hash[rtf.section_id])
        report_fields << ["#{sections_hash[rtf.section_id]}:#{rtf[:object_attribute_name]}",rtf.id,{:type=>rtf.section_id,:query=>rtf[:object_attribute_name]}]
      end
    end
    report_fields
  end

  def report_column_str(report)
    if(report.report_columns_str.present?)
      return report.report_columns_str
    end
    if(report.report_columns.size>0)
      return report.report_columns.collect{|i| i.field_id}.join(",")
    else
      return ""
    end
  end

  def available_groupable_report_column(report)
    report_columns_str = report.report_columns_str
    if(!report_columns_str.present?&&report.report_columns.size>0)
      report_columns_str = report.report_columns.collect{|i| i.field_id}
    end
    report_type_sections = Irm::ReportTypeSection.where(:report_type_id=>report.report_type_id)
    report_type_fields = Irm::ReportTypeField.select_all.query_by_report_type(report.report_type_id).with_bo_object_attribute(I18n.locale)
    sections_hash = {}
    report_type_sections.each{|i| sections_hash.merge!(i.id=>i.name)}
    report_fields = []
    report_type_fields.each do |rtf|
      if(report_columns_str.include?(rtf.id)&&sections_hash[rtf.section_id])
        report_fields << ["#{sections_hash[rtf.section_id]}:#{rtf[:object_attribute_name]}",rtf.id,{:type=>rtf.data_type}]
      end
    end
    report_fields
  end

  def available_report_group_date_type
    Irm::LookupValue.query_by_lookup_type("IRM_REPORT_DATE_GROUP_TYPE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_report_group_sort_type
    Irm::LookupValue.query_by_lookup_type("IRM_REPORT_GROUP_COLUMN_SORT").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_filter_field(report_type_id)
    report_type_sections = Irm::ReportTypeSection.where(:report_type_id=>report_type_id)
    report_type_fields = Irm::ReportTypeField.select_all.query_by_report_type(report_type_id).filter_column.with_bo_object_attribute(I18n.locale)
    sections_hash = {}
    report_type_sections.each{|i| sections_hash.merge!(i.id=>i.name)}
    report_fields = {}
    report_type_fields.each do |rtf|
      if(report_fields[rtf.section_id])
        report_fields[rtf.section_id] << ["#{sections_hash[rtf.section_id]}:#{rtf[:object_attribute_name]}",rtf.id]
      else
        report_fields[rtf.section_id] = [["#{sections_hash[rtf.section_id]}:#{rtf[:object_attribute_name]}",rtf.id]]
      end
    end
    grouped_report_fields = {}
    report_fields.keys.each do |key|
      grouped_report_fields[sections_hash[key]] = report_fields[key]
    end
    grouped_report_fields
  end

  def available_date_filter_field(report_type_id)
    report_type_sections = Irm::ReportTypeSection.where(:report_type_id=>report_type_id)
    report_type_fields = Irm::ReportTypeField.select_all.query_by_report_type(report_type_id).filter_column.date_column.with_bo_object_attribute(I18n.locale)
    sections_hash = {}
    report_type_sections.each{|i| sections_hash.merge!(i.id=>i.name)}
    report_fields = {}
    report_type_fields.each do |rtf|
      if(report_fields[rtf.section_id])
        report_fields[rtf.section_id] << ["#{sections_hash[rtf.section_id]}:#{rtf[:object_attribute_name]}",rtf.id]
      else
        report_fields[rtf.section_id] = [["#{sections_hash[rtf.section_id]}:#{rtf[:object_attribute_name]}",rtf.id]]
      end
    end
    grouped_report_fields = {}
    report_fields.keys.each do |key|
      grouped_report_fields[sections_hash[key]] = report_fields[key]
    end
    grouped_report_fields
  end



  def render_report_filter_field(field_id,form)
    filed = Irm::ReportTypeField.query(field_id).first
    if(filed)
      oa = Irm::ObjectAttribute.find(filed.object_attribute_id)
      render_operator_and_value(oa,form)
    else
      render_operator_and_value(nil,form)
    end
  end




  def group_report_metadata(report,group_fields)
    fields = group_fields
    metadata = report.report_meta_data
    grouped_data = []
    # 报表数据一组分组
    case group_fields[0][2]
      when nil
        grouped_data = metadata.group_by{|i| i[fields[0][0]]}
      when "DAY"
        grouped_data = metadata.group_by{|i| i[fields[0][0]].strftime("%Y-%m-%d")}
      when "MONTH"
        grouped_data = metadata.group_by{|i| i[fields[0][0]].strftime("%Y-%m")}
      when "YEAR"
        grouped_data = metadata.group_by{|i| i[fields[0][0]].year.to_s}
    end

    # 报表数据二级分组
    grouped_data.dup.each do |key,value|
      case group_fields[1][2]
        when nil
          grouped_data[key] = value.group_by{|i| i[fields[1][0]]}
        when "DAY"
          grouped_data[key] = value.group_by{|i| i[fields[1][0]].strftime("%Y-%m-%d")}
        when "MONTH"
          grouped_data[key] = value.group_by{|i| i[fields[1][0]].strftime("%Y-%m")}
        when "YEAR"
          grouped_data[key] = value.group_by{|i| i[fields[1][0]].year.to_s}
      end
    end  if(fields.size==2)
    # 返回分组后的数据
    grouped_data
  end

  # generate group report html
  def group_report(report)
    # 报表表头信息
    report_headers = report.report_header
    #　报表分组列信息
    group_fields =  report.group_fields

    # 报表分组字段
    group_field_keys = group_fields.collect{|i| i[0]}

    # 报表分组后需要显示的列
    display_headers = report_headers.collect{|i| i unless group_field_keys.include?(i[0]) }.compact
    grouped_html = ""


    # 生成表头
    table_header = ""
    display_headers.each do |dh|
      table_header << content_tag(:th,dh[1],{},false)
    end

    # table body
    meta_data = group_report_metadata(report,group_fields)
    table_body = ""
    level_one_label = report_headers.detect{|i| i[0].eql?(group_fields[0][0])}[1]
    level_two_label = ""
    if(group_fields.size>1)
      level_two_label = report_headers.detect{|i| i[0].eql?(group_fields[1][0])}[1]
    end
    meta_data.sort{|a,b| if a[0]&&b[0]; a[0]<=>b[0]; else; a[0]? 1:0; end}.map do |level_one_key,level_one_value|

      level_one_summary_amount = 0
      if(group_fields.size>1)
        level_one_value.values.each{|i| level_one_summary_amount+=i.size }
      else
        level_one_summary_amount = level_one_value.size
      end
      table_body << %Q(
        <tr class="group group1">
          <td colspan="#{display_headers.size-1}">
            <strong>#{level_one_label} : #{level_one_key}</strong>
          </td>
          <td style="float:right;">
            <strong>(#{level_one_summary_amount} #{t(:label_irm_report_records)})</strong>
          </td>
        </tr>
      )
      table_body << %Q(<tr class="break break1"><td colspan="#{display_headers.size}">&nbsp;</td></tr>)
      if(group_fields.size>1)
        level_one_value..sort{|a,b| if a[0]&&b[0]; a[0]<=>b[0]; else; a[0]? 1:0; end}.map do |level_two_key,level_two_value|
          level_two_summary_amount = level_two_value.size
          table_body << %Q(
            <tr class="group group2">
              <td colspan="#{display_headers.size-1}">
                <strong>#{level_two_label} : #{level_two_key}</strong>
              </td>
              <td style="float:right;">
                <strong>(#{level_two_summary_amount} #{t(:label_irm_report_records)})</strong>
              </td>
            </tr>
          )
          table_body << %Q(<tr class="break break2"><td colspan="#{display_headers.size}">&nbsp;</td></tr>)
          level_two_value.each do |data|
            table_body << %Q(<tr>)
            display_headers.each do |dh|
              table_body << %Q(<td>#{data[dh[0]]}</td>)
            end
            table_body << %Q(</tr>)
          end if report.show_detail?
        end
      else
        level_one_value.each do |data|
          table_body << %Q(<tr>)
          display_headers.each do |dh|
            table_body << %Q(<td>#{data[dh[0]]}</td>)
          end if report.show_detail?
          table_body << %Q(</tr>)
        end
      end
    end

    table_content = ""
    table_content << "<thead><tr>#{table_header}</tr></thead>"
    table_content << "<tbody>#{table_body}</tbody>"
    table_content
  end



  def matrix_report_metadata(report,matrix_fields)
    fields = matrix_fields
    metadata = report.report_meta_data
    grouped_data = []
    case group_fields[0][2]
      when nil
        grouped_data = metadata.group_by{|i| i[fields[0][0]]}
      when "DAY"
        grouped_data = metadata.group_by{|i| i[fields[0][0]].strftime("%Y-%m-%d")}
      when "MONTH"
        grouped_data = metadata.group_by{|i| i[fields[0][0]].strftime("%Y-%m")}
      when "YEAR"
        grouped_data = metadata.group_by{|i| i[fields[0][0]].year.to_s}
    end


    grouped_data.dup.each do |key,value|
      case group_fields[1][2]
        when nil
          grouped_data[key] = value.group_by{|i| i[fields[1][0]]}
        when "DAY"
          grouped_data[key] = value.group_by{|i| i[fields[1][0]].strftime("%Y-%m-%d")}
        when "MONTH"
          grouped_data[key] = value.group_by{|i| i[fields[1][0]].strftime("%Y-%m")}
        when "YEAR"
          grouped_data[key] = value.group_by{|i| i[fields[1][0]].year.to_s}
      end
    end  if(fields.size==2)
    grouped_data
  end


  def current_reports(bo_name,category="REPORT")
    folder_ids = Irm::Person.current.report_folders.collect{|i| i.id}
    Irm::Report.multilingual.query_by_folders(folder_ids).with_report_type(I18n.locale).with_report_folder(I18n.locale).filter_by_folder_access(Irm::Person.current.id).query_by_bo_name(bo_name)
  end
end