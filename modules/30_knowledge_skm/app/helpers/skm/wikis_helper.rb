module Skm::WikisHelper
  def wiki_formats
    [["AsciiDoc", "asciidoc"],
     ["Creole", "creole"],
     ["Markdown", "markdown"],
     ["MediaWiki", "mediawiki"],
     ["Org-mode", "org"],
     ["Pod", "pod"],
     ["RDoc", "rdoc"],
     ["reStructuredText", "rest"],
     ["Textile", "textile"]]
  end

  def wiki_files(wiki)
    Irm::AttachmentVersion.select_all.where(:source_id => wiki.id, :source_type => wiki.class.name)
  end

  def show_wiki(page, title="", wiki_id=nil, mode=nil)
    if wiki_id.present?
      page.attachments = Irm::AttachmentVersion.select_all.where(:source_id => wiki_id, :source_type => Skm::Wiki.name)
    end
    if mode
      page.mode = mode
    end
    doc = Nokogiri::HTML::DocumentFragment.parse(page.formatted_data.force_encoding("utf-8"))
    if title.present?
      doc = check_h1(title, doc)
    end
    doc = generate_sequence(doc)
    if !mode.present?&&wiki_id.present?&&allow_to?(:controller=>"skm/wikis",:action=>"edit_chapter")
      add_wiki_edit_link(doc,wiki_id)
    end
    doc.to_html
  end


  def check_h1(title, doc)
    if doc.css("h1").length < 1
      doc.children.before(Nokogiri::XML::DocumentFragment.parse("<h1 class='add-h1'>#{title}</h1>"))
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
        n.before(Nokogiri::XML::DocumentFragment.parse("<p class='h2-title'></p>"))
      end
      if "h3".eql?(n.name.downcase)
        h3 +=1
        n.content = "#{h1}.#{h2}.#{h3}. " + n.content
      end
      if "img".eql?(n.name.downcase)
        img +=1
        n.before(Nokogiri::XML::DocumentFragment.parse("<span class='img-alt'>#{t(:label_skm_wiki_img)} #{h1}.#{img} #{n[:alt]}</span>"))
      end
      if "table".eql?(n.name.downcase)
        table +=1
        n.before(Nokogiri::XML::DocumentFragment.parse("<span class='table-alt'>#{t(:label_skm_wiki_table)} #{h1}.#{table}  #{n[:alt]}</span>"))
      end
    end
    doc
  end

  def add_wiki_edit_link(doc,wiki_id)
    sequences = [0,0,0]
    doc.css("h1,h2,h3").each do |n|
      next if (n['class']||"").include?("add-h1")
      type = n.name.downcase.gsub("h","").to_i
      sequences[type-1] = sequences[type-1]+1
      n.children.after(Nokogiri::XML::DocumentFragment.parse("<span class='hedit-link'>[#{link_to(t(:edit),{:controller=>"skm/wikis",:action=>"edit_chapter",:id=>wiki_id,:hdata=>"#{type}##{sequences[type-1]}"})}]</span>"))
    end
  end

  def show_book(book, mode=nil)
    output = ActiveSupport::SafeBuffer.new
    book.wikis.each_with_index do |wiki,index|
      page = wiki.page
      page.attachments = Irm::AttachmentVersion.select_all.where(:source_id => wiki.id, :source_type => Skm::Wiki.name)
      if mode
        page.mode = mode
      end
      doc = Nokogiri::HTML::DocumentFragment.parse(page.formatted_data)
      doc = check_h1(wiki.name, doc)
      # page break
      if(index>0)
        output.safe_concat "<br class='page-break'/>"
      end
      output.safe_concat doc.to_html
    end
    doc = Nokogiri::HTML::DocumentFragment.parse(output)
    doc = generate_sequence(doc)
    doc.to_html
  end
end
