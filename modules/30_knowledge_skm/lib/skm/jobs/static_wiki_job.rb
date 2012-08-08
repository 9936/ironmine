class Skm::Jobs::StaticWikiJob<Struct.new(:wiki_id)
  def perform
    wiki = Skm::Wiki.query(wiki_id).first
    Skm::WikiToStatic.instance.wiki_to_static(wiki)  if  wiki.present?
  end
end