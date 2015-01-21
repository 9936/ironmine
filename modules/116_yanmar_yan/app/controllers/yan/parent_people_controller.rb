class Yan::ParentPeopleController < ApplicationController
  def delete_from_parent
    @parent_person = Yan::ParentPerson.new(params[:yan_parent_person])

    respond_to do |format|
      if(!params[:temp_id_string].blank?)
        params[:temp_id_string].split(",").delete_if{|i| i.blank?}.each do |id|
          esp = Yan::ParentPerson.where(:parent_person_id => id).first
          esp.destroy
        end
      end
      format.html { redirect_to({:controller => "irm/people", :action=>"show", :id => params[:id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @parent_person.errors, :status => :unprocessable_entity }
    end
  end

  def new_from_person
    @person = Irm::Person.find(params[:id])
    @parent_person = Yan::ParentPerson.new(:person_id=>params[:id])
    @parent_person.status_code = ""

    respond_to do |format|
      format.html { render :layout => "application_full" }
      format.xml  { render :xml => @application }
    end
  end

  def create_from_person
    @parent_person = Yan::ParentPerson.new(params[:yan_parent_person])
    respond_to do |format|
      if true
        @parent_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Yan::ParentPerson.create(:person_id=>params[:id],:parent_person_id=>id)
        end if @parent_person.status_code.present?

          format.html { redirect_to({:controller => "irm/people",:action=>"show",:id=>params[:id]}, :notice => t(:successfully_created)) }
          format.xml  { render :xml => @parent_person, :status => :created}

      else
        @parent_person.errors.add(:status_code,"")
        format.html { render :action => "new_from_person" }
        format.xml  { render :xml => @parent_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_owned_parents_data
    parent_scope = Irm::Person.select("full_name, email_address, #{Irm::Person.table_name}.id").with_organization(I18n.locale).
        joins(",#{Yan::ParentPerson.table_name} pp").
        where("pp.parent_person_id = #{Irm::Person.table_name}.id").where("pp.person_id = ?", params[:id])
    parent_scope = parent_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    parent_scope = parent_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    parent_scope = parent_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    parents, count = paginate(parent_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(parents.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = parents
        @count = count
      }
    end
  end

  def get_ava_parents_data
    parent_scope = Irm::Person.select("full_name, email_address, #{Irm::Person.table_name}.id").
        with_organization(I18n.locale).
        where("NOT EXISTS(SELECT 1 FROM yan_parent_people pp WHERE pp.parent_person_id = #{Irm::Person.table_name}.id AND pp.person_id = ?) ", params[:id])
    parent_scope = parent_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    parent_scope = parent_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    parent_scope = parent_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    parents, count = paginate(parent_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(parents.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = parents
        @count = count
      }
    end
  end
end
