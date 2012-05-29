module Irm::ReportTypeSectionsHelper
  def field_source(report_type_id)
    tree_nodes = []
    report_type = Irm::ReportType.find(report_type_id)
    exclude_object_attribute_ids = Irm::ReportTypeField.query_by_report_type(report_type.id).collect{|i| i[:object_attribute_id]}
    report_type.report_type_objects.each do |rto|
      bo = Irm::BusinessObject.multilingual.find(rto.business_object_id)
      bo_node = {:id=>bo.id,:type=>'business_object',:text=>bo[:name],:bo_id=>bo.id,:leaf=>false,:children=>[]}
      bo.object_attributes.multilingual.each do |oa|
        next if oa.attribute_type.eql?("MODEL_COLUMN")||exclude_object_attribute_ids.include?(oa.id.to_s)
        bo_node[:children] << {:id=>oa.id,:type=>'object_attribute',:text=>oa[:name],:bo_id=>bo.id,:bo_name=>bo[:name],:boa_id=>oa.id,:data_type=>oa.data_type,:default_selection_flag=>false,:leaf=>true}
      end
      tree_nodes << bo_node
    end
    tree_nodes
  end

  def section_field(report_type_id)
    section_fields = []
    report_type = Irm::ReportType.find(report_type_id)
    report_type.report_type_sections.each do |rts|
      section_node = {:id=>rts.id,:type=>"section",:section_id=>rts.id,:text=>rts.name,:draggable=>false,:leaf=>false,:children=>[]}
      rts.report_type_fields.with_bo_object_attribute(I18n.locale).select_all.each do |rto|
        section_node[:children] << {:id=>rto.id,:type=>'section_field',:section_field_id=>rto.id,:text=>rto[:object_attribute_name],:bo_id=>rto[:business_object_id],:bo_name=>rto[:business_object_name],:boa_id=>rto.object_attribute_id,:data_type=>rto[:data_type],:default_selection_flag=>rto.default_selection_flag,:leaf=>true}
    end
      section_fields << section_node
    end
    section_fields
  end
end
