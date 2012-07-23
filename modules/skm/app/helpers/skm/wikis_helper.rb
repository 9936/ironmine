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

  def show_wiki(page,title="",wiki_id=nil,mode=nil)
    if wiki_id.present?
      page.attachments = Irm::AttachmentVersion.select_all.where(:source_id=>wiki_id,:source_type=>Skm::Wiki.name)
    end
    if mode
      page.mode = mode
    end
    doc = Nokogiri::HTML::DocumentFragment.parse(page.formatted_data)
    if title.present?
      doc = check_h1(title,doc)
    end
    doc = generate_sequence(doc)
    doc.to_html
  end


  def check_h1(title,doc)
    if doc.css("h1").length < 1
      doc.children.before(Nokogiri::XML::DocumentFragment.parse("<h1>#{title}</h1>"))
    end

    doc
  end

  def generate_sequence(doc)
    h1 = 0
    h2 = 0
    h3 = 0
    img = 0
    table = 0
    doc.css("h1,h2,h3,img,table").each do |n|
      if "h1".eql?(n.name.downcase)
        h2 = 0
        h3 = 0
        img = 0
        table = 0
        h1 +=1
        n.content = "#{h1}. " + n.content
      end
      if "h2".eql?(n.name.downcase)
        h3 = 0
        h2 +=1
        n.content = "#{h1}.#{h2}. " + n.content
      end
      if "h3".eql?(n.name.downcase)
        h3 +=1
        n.content = "#{h1}.#{h2}.#{h3}. " + n.content
      end
      if "img".eql?(n.name.downcase)
        img +=1
        n.before(Nokogiri::XML::DocumentFragment.parse("<label class='img-alt'>#{t(:label_skm_wiki_img)} #{h1}.#{img} #{n[:alt]}</label>"))
      end
      if "table".eql?(n.name.downcase)
        table +=1
        n.before(Nokogiri::XML::DocumentFragment.parse("<label class='table-alt'>#{t(:label_skm_wiki_table)} #{h1}.#{table}  #{n[:alt]}</label>"))
      end
    end
    doc
  end
end
