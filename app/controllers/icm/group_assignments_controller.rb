class Icm::GroupAssignmentsController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end    
  end

  def new
    @group_assignment = Icm::GroupAssignment.new
#    @return_url= request.env['HTTP_REFERER']

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group_assignment }
    end    
  end

  def create
    @group_assignment = Icm::GroupAssignment.new(params[:icm_group_assignment])
    assignment_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Person,"P"],[Uid::ExternalSystem, "E"],[Slm::ServiceCatalog, "S"]]
    respond_to do |format|
      if @group_assignment.save

        if params[:selected_actions] && params[:selected_actions].present?
          selected_assignments = params[:selected_actions].split(",")

          selected_assignments.each do |assignment_str|
            next unless assignment_str.strip.present?
            assignment = assignment_str.split("#")
            assignment_type = assignment_types.detect{|i| i[1].eql?(assignment[0])}

            Icm::GroupAssignmentDetail.create({:group_assignment_id => @group_assignment.id,
                                        :source_type => assignment_type[0].name,
                                        :source_id => assignment[1]})
          end if selected_assignments.any?
        end

        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @group_assignment, :status => :created, :location => @group_assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @group_assignment = Icm::GroupAssignment.find(params[:id])
  end

  def update
    @group_assignment = Icm::GroupAssignment.find(params[:id])
    assignment_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Person,"P"],[Uid::ExternalSystem, "E"],[Slm::ServiceCatalog, "S"]]

    respond_to do |format|
      if @group_assignment.update_attributes(params[:icm_group_assignment])
        if params[:selected_actions] && params[:selected_actions].present?
          selected_assignments = params[:selected_actions].split(",")

          assignment_records = @group_assignment.group_assignment_details
          assignment_records.each do |t|
            type_short = assignment_types.detect{|i| i[0].name.eql?(t.source_type)}
            t.destroy unless selected_assignments.include?(type_short[1]+"#"+t.source_id.to_s)
          end
          assignments_array = @group_assignment.group_assignment_details.collect{|p| [p.source_type, p.source_id]}

          selected_assignments.each do |assignment_str|
            next unless assignment_str.strip.present?
            assignment = assignment_str.split("#")
            assignment_type = assignment_types.detect{|i| i[1].eql?(assignment[0])}
            next if assignments_array.include?([assignment_type[0].name, assignment[1].to_i])

            Icm::GroupAssignmentDetail.create({:group_assignment_id => @group_assignment.id,
                                        :source_type => assignment_type[0].name,
                                        :source_id => assignment[1]})
          end
        end
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @group_assignment = Icm::GroupAssignment.find(params[:id])
    @group_assignment.destroy

    respond_to do |format|
      format.html { redirect_to({:action => "index"}) }
      format.xml  { head :ok }
    end    
  end

  def get_data
    group_assignments_scope = Icm::GroupAssignment.list_all
    group_assignments,count = paginate(group_assignments_scope)

    respond_to do |format|
      format.json  {render :json => to_jsonp(group_assignments.to_grid_json(
                                                 [:company_name,:organization_name,
                                                  :support_role_name,:vendor_group_flag,
                                                  :oncall_group_flag, :support_group_code, :support_group_name, :status_code], count)) }
    end    
  end
end