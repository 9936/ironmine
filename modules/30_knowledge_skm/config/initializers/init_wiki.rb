module Ironmine
  Gollum::Markup.send(:include,Skm::Gollum::Markup)
  Gollum::Page.send(:include,Skm::Gollum::Page)
  Grit::Repo.send(:include,Skm::Gollum::Repo)
  WIKI = Gollum::Wiki.new(Rails.root.join("..","wiki", ".git"))

end