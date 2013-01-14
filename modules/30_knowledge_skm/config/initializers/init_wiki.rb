module Ironmine
  wiki_yml_name = Rails.root.join("config", "wiki.yml")
  wiki_yml = YAML.load_file(wiki_yml_name)
  if wiki_yml["base_path"] and File::exists?(Pathname.new("#{wiki_yml["base_path"]}.git"))
    wiki_path = Pathname.new("#{wiki_yml["base_path"]}.git")
  else
    wiki_path = Rails.root.join("..","wiki", ".git")
  end

  Gollum::Markup.send(:include,Skm::Gollum::Markup)
  Gollum::Page.send(:include,Skm::Gollum::Page)
  Grit::Repo.send(:include,Skm::Gollum::Repo)
  begin
    WIKI = Gollum::Wiki.new(wiki_path)
  rescue
    wiki_path_str = wiki_path.to_s.gsub(/.git/, '')
    puts "Something is error, you can try the script:`mkdir #{wiki_path_str}; cd #{wiki_path_str} && git init`"
  end
end