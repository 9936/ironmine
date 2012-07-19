module Ironmine
  Gollum::Markup.send(:include,Irm::Gollum::Markup)
  Gollum::Page.send(:include,Irm::Gollum::Page)
  WIKI = Gollum::Wiki.new(Rails.root.join("..","wiki", ".git"))

end