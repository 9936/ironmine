module Irm::ReportTypesHelper
  def selectable_master_detail(bo_id)
    primary_bo = Irm::BusinessObject.multilingual.find(bo_id)
    queue = [{:id=>bo_id,:name=>primary_bo[:name],:level=>0}]
    master_detail_bos = {0=>[{:id=>bo_id.to_s,:name=>primary_bo[:name],:level=>0}]}
    detail_names = {bo_id.to_s=>primary_bo[:name]}
    while queue.length>0
      current = queue.delete_at(0)
      details = detail_bo(current[:id],current[:level])
      master_detail_bos.merge!({current[:id]=>details})
      if details.length>0
        queue = queue+details
        details.each do |d|
          detail_names.merge!({d[:id]=>d[:name]})
        end
      end
    end
    script = %Q(var masterDetails = #{master_detail_bos.to_json},detailNames= #{detail_names.to_json};)
    javascript_tag(script)
  end

  def detail_bo(bo_id,level)
    Irm::BusinessObject.multilingual.query_detail(bo_id).collect{|i| {:id=>i.id.to_s,:name=>i[:name],:level=>level+1}}
  end

  def report_type_fields(report_type)
    object_stats = []
    objects = report_type.report_type_objects.select_all.with_bo(I18n.locale).collect{|i| [i[:relation_business_object_name],i.business_object_id]}
    Irm::ReportTypeField.query_by_report_type(report_type.id).with_bo_object_attribute(I18n.locale).collect{|i| [i[:business_object_name],i[:business_object_id]]}.group_by{|i| [i[0],i[1]]}.each do |key,value|
      object_stats << [key[0],key[1],value.size]
      objects.delete_if{|i| i[1].to_s.eql?(key[1].to_s)}
    end
    objects.each do |o|
      object_stats << [o[0],o[1],0]
    end
    object_stats
  end
end
