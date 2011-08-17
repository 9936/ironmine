class Skm::ColumnAccess < ActiveRecord::Base
  set_table_name :skm_column_accesses
  belongs_to :column

  def current_person_accessible?(person = Irm::Person.current)
    p_company_id = person.company_id
    p_department_id = person.department_id
    p_organization_id = person.organization_id
    begin
      p_profile_id = person.profile.id
    rescue
      p_profile_id = ""
    end

    ret = case self.source_type
            when Irm::Company.name
              self.source_id.to_s.eql?(p_company_id.to_s)
            when Irm::Department.name
              self.source_id.to_s.eql?(p_department_id.to_s)
            when Irm::Organization.name
              self.source_id.to_s.eql?(p_organization_id.to_s)
            when Irm::Profile.name
              self.source_id.to_s.eql?(p_profile_id.to_s)
            else
              false
          end
    ret
  end

  def source
    eval(self.source_type).where(:id => self.source_id).first
  end
end