module Ironmine
  Gollum::Markup.send(:include,Skm::Gollum::Markup)
  Gollum::Page.send(:include,Skm::Gollum::Page)
  WIKI = Gollum::Wiki.new(Rails.root.join("..","wiki", ".git"))

end