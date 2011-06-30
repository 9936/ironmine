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

  def report_type_object_relations

  end
end
