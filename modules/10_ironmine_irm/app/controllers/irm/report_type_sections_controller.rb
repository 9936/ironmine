class Irm::ReportTypeSectionsController < ApplicationController
  def index
    @report_type = Irm::ReportType.find(params[:report_type_id])
  end


  def update
    @report_type = Irm::ReportType.find(params[:report_type_id])
    sections = params[:irm_report_type_sections].values
    exists_section_ids = []
    exists_field_ids = []
    sections.each_with_index do |section_param,index|
      section = nil
      if(section_param["section_id"].present?)
        section = Irm::ReportTypeSection.where(:report_type_id=>@report_type.id).find(section_param["section_id"])
      end
      if section
        section.update_attribute(:section_sequence,index)
      else
        section = @report_type.report_type_sections.create(:name=>section_param["name"],:section_sequence=>index)
      end
      exists_section_ids << section.id
      section_param["fields"].values.each_with_index do |field_param,fi|
        field = nil
        if(field_param["section_field_id"].present?)
          field =Irm::ReportTypeField.find(field_param["section_field_id"])
        end
        if field
          field.update_attributes(:section_id=>section.id,:default_selection_flag=>field_param["default_selection_flag"])
        else
           field = section.report_type_fields.create(:object_attribute_id=>field_param["boa_id"],:default_selection_flag=>field_param["default_selection_flag"])
        end
        exists_field_ids << field.id
      end
    end
    Irm::ReportTypeField.query_by_report_type(@report_type).select_all.each do |rtf|
      rtf.destroy unless exists_field_ids.include?(rtf.id)
    end
    # delete unusable section
    Irm::ReportTypeSection.where(:report_type_id=>@report_type.id).where("id NOT IN (?)",["#"]+exists_section_ids).each{|i| i.destroy}
    respond_to do |format|
      format.js
    end
  end


  def field_source
    tree_nodes = []
    @report_type = Irm::ReportType.find(params[:report_type_id])
    exclude_object_attribute_ids = Irm::ReportTypeField.query_by_report_type(@report_type.id).collect{|i| i[:object_attribute_id]}
    @report_type.report_type_objects.each do |rto|
      bo = Irm::BusinessObject.multilingual.find(rto.business_object_id)
      bo_node = {:id=>bo.id,:type=>'business_object',:text=>bo[:name],:bo_id=>bo.id,:leaf=>false,:children=>[]}
      bo.object_attributes.multilingual.each do |oa|
        next if oa.attribute_type.eql?("MODEL_COLUMN")||exclude_object_attribute_ids.include?(oa.id.to_s)
        bo_node[:children] << {:id=>oa.id,:type=>'object_attribute',:text=>oa[:name],:bo_id=>bo.id,:bo_name=>bo[:name],:boa_id=>oa.id,:data_type=>oa.data_type,:default_selection_flag=>false,:leaf=>true}
      end
      tree_nodes << bo_node
    end
    respond_to do |format|
      format.json {render :json=>tree_nodes.to_json}
    end
  end


  def section_field
    section_fields = []
    @report_type = Irm::ReportType.find(params[:report_type_id])
    @report_type.report_type_sections.each do |rts|
      section_node = {:id=>rts.id,:type=>"section",:section_id=>rts.id,:text=>rts.name,:draggable=>false,:leaf=>false,:children=>[]}
      rts.report_type_fields.with_bo_object_attribute(I18n.locale).select_all.each do |rto|
        section_node[:children] << {:id=>rto.id,:type=>'section_field',:section_field_id=>rto.id,:text=>rto[:object_attribute_name],:bo_id=>rto[:business_object_id],:bo_name=>rto[:business_object_name],:boa_id=>rto.object_attribute_id,:data_type=>rto[:data_type],:default_selection_flag=>Irm::Constant::SYS_YES.eql?(rto.default_selection_flag),:leaf=>true}
    end
      section_fields << section_node
    end
    respond_to do |format|
      format.json {render :json=>section_fields.to_json}
    end
  end



end
