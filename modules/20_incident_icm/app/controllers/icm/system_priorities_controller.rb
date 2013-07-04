class Icm::SystemPrioritiesController < ApplicationController
  def index
    @priority_code = Icm::PriorityCode.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @priority_code }
    end
  end

  def edit_transform

  end

  def update_transform
    sid = Irm::ExternalSystem.current_system.id
    if sid.present? && params[:priority_transforms].present?
      params[:priority_transforms].each do |impact_id,urgences|
        urgences.each do |urgence_id, priority_id|
          exists_priority_transform = Icm::PriorityTransform.with_sid(sid).with_impact_urgence(impact_id, urgence_id).first
          if exists_priority_transform
            if priority_id.present?
              exists_priority_transform.update_attribute(:priority_id, priority_id)
            else
              exists_priority_transform.destroy
            end
          else
            Icm::PriorityTransform.create(:urgence_id => urgence_id,:impact_range_id => impact_id,:priority_id => priority_id, :sid => sid) if priority_id.present?
          end
        end
      end if params[:priority_transforms].any?
    end
    respond_to do |format|
      format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
    end
  end

  def get_data
    priority_codes_scope = Icm::PriorityCode.multilingual.status_meaning.order("weight_values desc")
    priority_codes_scope = priority_codes_scope.match_value("#{Icm::PriorityCode.table_name}.priority_code",params[:priority_code])
    priority_codes_scope = priority_codes_scope.match_value("#{Icm::PriorityCodesTl.table_name}.name",params[:name])
    priority_codes,count = paginate(priority_codes_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(priority_codes.to_grid_json([:priority_code,:name,:weight_values,:status_meaning], count)) }
      format.html  {
        @count = count
        @datas = priority_codes
      }
    end
  end

end