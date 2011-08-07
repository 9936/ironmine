class Skm::ColumnsController < ApplicationController
  def index

  end

  def new

  end

  def get_columns_data
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
end