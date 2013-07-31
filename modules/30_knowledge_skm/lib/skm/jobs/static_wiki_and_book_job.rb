class Skm::Jobs::StaticWikiAndBookJob<Struct.new(:event_id)
  def perform
  	event = Irm::Event.find(event_id)
  	if event.end_at.nil?
  		if event.bo_code.eql?(Irm::BusinessObject.class_name_to_code(Skm::Wiki.name))
  			wiki = Skm::Wiki.find(event.business_object_id)
  			Skm::WikiToStatic.instance.wiki_to_static(wiki)
  	  elsif event.bo_code.eql?(Irm::BusinessObject.class_name_to_code(Skm::Book.name))
  	    	book = Skm::Book.find(event.business_object_id)
  	    	Skm::WikiToStatic.instance.book_to_static(book)
  		end
  		event.end_at = Time.now
      event.save
    end
  end
end