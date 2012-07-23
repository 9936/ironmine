module Skm::WikiTemplatesHelper
  def available_wiki_templates
    Skm::WikiTemplate.select("id,name").by_person(Irm::Person.current.id).collect{|i| [i.name,i.id]}
  end
end
