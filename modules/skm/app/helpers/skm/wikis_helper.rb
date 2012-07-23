module Skm::WikisHelper
  def wiki_formats
    [["AsciiDoc","asciidoc"],
     ["Creole","creole"],
     ["Markdown","markdown"],
     ["MediaWiki","mediawiki"],
     ["Org-mode","org"],
     ["Pod","pod"],
     ["RDoc","rdoc"],
     ["reStructuredText","rest"],
     ["Textile","textile"]]
  end

  def wiki_files(wiki)
    Irm::AttachmentVersion.select_all.where(:source_id=>wiki.id,:source_type=>wiki.class.name)
  end
end
