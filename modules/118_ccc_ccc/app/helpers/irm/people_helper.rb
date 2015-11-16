module Irm::PeopleHelper
   def person_title
    Irm::LookupValue.query_by_lookup_type("IRM_PERSON_TITLE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
   end

   def available_uid_person
     Irm::Person.real.collect{|p| ["#{p[:login_name]}(#{p[:full_name]})",p[:id]]}
   end

   def available_people
     Irm::Person.real.enabled.order("CONVERT(full_name USING gbk)").collect{|p| ["#{p[:full_name]}(#{p[:login_name]})",p[:id]]}
   end

  def current_person_accessible_people_full
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
    accessable_companies = Irm::Company.multilingual.query_by_ids(accesses)
    accessable_companies.collect{|p| [p[:name], p.id]}


    people = []
    accesses.each do |t|
      te = Irm::Person.list_all.enabled.where("#{Irm::Person.table_name}.company_id = ?", t)
      people = people + te if te.size > 0
    end

    people = people.uniq
    people.collect{|p| [p[:company_name] +"-" +p[:organization_name] +"-" +p[:full_name], p.id]}
  end

   def available_person
     people = Irm::Person.real.order("full_name_pinyin").collect{|p|[p.name,p[:id]]}
     needed_to_replace = people.detect{|person| Irm::Person.current.id.eql?(person[1])}
     if needed_to_replace
       people.delete_if{|person| Irm::Person.current.id.eql?(person[1])}
       people.unshift([Irm::Person.current.full_name,Irm::Person.current.id])
     end
     people
   end

   def replied_avatar(journal)
     if(journal[:avatar_file_name])
       Irm::Person.avatar_url({:id=>journal[:replied_by],:updated_at=>journal[:avatar_updated_at],:filename=>journal[:avatar_file_name]},:medium)
     else
       "/images/default_medium_avatar.jpg"
     end
   end

   def person_avatar(person_id)
     person = Irm::Person.where("id=?",person_id).first
     if person&&person.avatar_file_name
       person.avatar.url(:medium)
     else
       "/images/default_medium_avatar.jpg"
     end
   end

   def person_time_zone(time_zone)
     Time.zone = time_zone
     time_zone_meaning = Time.zone.to_s
     Time.zone = Irm::Person.current.time_zone || 'Beijing'
     time_zone_meaning
   end

   def available_consultant_types
     all_consultantTypes = Ccc::ConsultantType.enabled.multilingual
     all_consultantTypes.collect{|i|[i[:name],i.id]}
   end
   def available_sexes
     all_sexes = Ccc::Sex.enabled.multilingual
     all_sexes.collect{|i|[i[:name],i.id]}
   end
   def available_consultant_statuses
     all_consultantStatuses = Ccc::ConsultantStatus.enabled.multilingual
     all_consultantStatuses.collect{|i|[i[:name],i.id]}
   end
   def available_consultant_levels
     all_consultantLevels = Ccc::ConsultantLevel.enabled.multilingual
     all_consultantLevels.collect{|i|[i[:name],i.id]}
   end

   def available_consultant_modules
     all_consultant_modules = Ccc::ConsultantModule.enabled.multilingual
     all_consultant_modules.collect{|i|[i[:name],i.id]}
   end

   def available_customer_statuses
     all_customer_statuses = Ccc::CustomerStatus.enabled.multilingual
     all_customer_statuses.collect{|i|[i[:name],i.id]}
   end


end