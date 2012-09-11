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

end
