module Ironmine
  WIKI = Gollum::Wiki.new(Rails.root.join("..","wiki", ".git"))
end