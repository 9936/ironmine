class Skm::WikiToStatic
  include Singleton

  def wiki_to_static(wiki, mode=nil)
    tmp_folder = "#{Rails.root.to_s}/tmp/skm/wikis/wiki_static/#{wiki.id}/#{wiki.md5_flag}"
    if !cached_static?(tmp_folder)
      static_folder = check_folder("#{Rails.root.to_s}/tmp/skm/wikis/wiki_static/#{wiki.id}", wiki.md5_flag)
      wiki_to_pdf(wiki, static_folder)
      wiki_to_html(wiki, static_folder)
    end

    if mode.present?
      if mode.to_sym.eql?(:pdf)
        return tmp_folder+"/pdf.pdf"
      else
        return tmp_folder+"/html.html"
      end
    end

  end


  def wiki_to_doc(wiki, mode=nil)
    doc = page_to_doc(wiki.page, wiki.name, wiki.id, mode)
    doc = generate_sequence(doc)
  end

  def book_to_static(book, mode=nil)
    tmp_folder = "#{Rails.root.to_s}/tmp/skm/books/wiki_static/#{book.id}/#{book.md5_flag}"
    if !cached_static?(tmp_folder)
      static_folder = check_folder("#{Rails.root.to_s}/tmp/skm/books/wiki_static/#{book.id}", book.md5_flag)
      book_to_pdf(book, static_folder)
      book_to_html(book, static_folder)
    end

    if mode.present?
      if mode.to_sym.eql?(:pdf)
        return tmp_folder+"/pdf.pdf"
      else
        return tmp_folder+"/html.html"
      end
    end

  end

  def book_static_exists?(book)
    File.exists?("#{Rails.root.to_s}/tmp/skm/books/wiki_static/#{book.id}/#{book.md5_flag}")
  end

  def wiki_static_exists?(wiki)
    File.exists?("#{Rails.root.to_s}/tmp/skm/wikis/wiki_static/#{wiki.id}/#{wiki.md5_flag}")
  end


  def sync_wiki_static(wiki_id)
    Delayed::Job.enqueue(Skm::Jobs::StaticWikiJob.new(wiki_id))
    Skm::Book.by_wiki(wiki_id).select_all.each do |b|
      Delayed::Job.enqueue(Skm::Jobs::StaticBookJob.new(b.id))
    end
  end

  def sync_book_static(book_id)
    Delayed::Job.enqueue(Skm::Jobs::StaticBookJob.new(book_id))
  end

  private


  def wiki_to_pdf(wiki, folder)
    html_doc = wiki_to_doc(wiki, :pdf)
    pdf_str = to_pdf_html(html_doc)

    pdf = WickedPdf.new.pdf_from_string(pdf_str, {:print_media_type => false,
                                                  :encoding => 'utf-8',
                                                  :book => true,
                                                  :page_size => 'A4',
                                                  :toc => {:header_text => I18n.t(:label_skm_wiki_table_of_content), :disable_back_links => true}})


    save_path = "#{folder}/pdf.pdf"
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    save_path
  end

  def wiki_to_html(wiki, folder)
    html_doc = wiki_to_doc(wiki)
    save_path = "#{folder}/html.html"
    File.open(save_path, 'wb') do |file|
      file << html_doc.to_html
    end
    save_path
  end

  def book_to_pdf(book, folder)
    html_doc = book_to_doc(book, :pdf)
    pdf_str = to_pdf_html(html_doc)

    pdf = WickedPdf.new.pdf_from_string(pdf_str, {:print_media_type => false,
                                                  :encoding => 'utf-8',
                                                  :book => true,
                                                  :page_size => 'A4',
                                                  :toc => {:header_text => I18n.t(:label_skm_wiki_table_of_content), :disable_back_links => true}})


    save_path = "#{folder}/pdf.pdf"
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    save_path
  end

  def book_to_html(book, folder)
    html_doc = book_to_doc(book)
    save_path = "#{folder}/html.html"
    File.open(save_path, 'wb') do |file|
      file << html_doc.to_html
    end
    save_path
  end

  def book_to_doc(book, mode=nil)
    output = ActiveSupport::SafeBuffer.new
    book.wikis.each_with_index do |wiki, index|
      doc = page_to_doc(wiki.page, wiki.name, wiki.id, mode)
      output.safe_concat doc.to_html
    end
    doc = Nokogiri::HTML::DocumentFragment.parse(output)
    doc = generate_sequence(doc)
    doc
  end


  def page_to_doc(page, title="", wiki_id=nil, mode=nil)
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
    doc
  end


  def check_folder(folder_parent, folder)
    FileUtils.rm_r Dir.glob("#{folder_parent}/*")
    tmp_folder = "#{folder_parent}/#{folder}"
    FileUtils.mkdir_p(tmp_folder, :mode => 0700)
    tmp_folder
  end

  def cached_static?(folder)
    File.exists?("#{folder}/html.html")||File.exists?("#{folder}/pdf.pdf")
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
        if h1 >1
          n.before(Nokogiri::XML::DocumentFragment.parse("<p class='page-break'/>"))
        end
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
        n.before(Nokogiri::XML::DocumentFragment.parse("<span class='img-alt'>#{I18n.t(:label_skm_wiki_img)} #{h1}.#{img} #{n[:alt]}</span>"))
      end
      if "table".eql?(n.name.downcase)
        table +=1
        n.before(Nokogiri::XML::DocumentFragment.parse("<span class='table-alt'>#{I18n.t(:label_skm_wiki_table)} #{h1}.#{table}  #{n[:alt]}</span>"))
      end
    end
    doc
  end

  def to_pdf_html(doc)
    %Q{
       <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
       <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
         <head>
           <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
             #{wicked_pdf_stylesheet_link_tag("markdown")}
           <style type="text/css">
               .markdown-body{
                   font-family: inherit;
               }
               p.page-break{page-break-after: always;clear:both;display:block;height:1px; }
           </style>
         </head>
         <body>
           <div class="markdown-body" style="width: 551pt;text-align: left;margin: 0 auto;">
             #{doc.to_html}
           </div>
         </body>
       </html>
    }
  end

  def wicked_pdf_stylesheet_link_tag(*sources)
    sources.collect { |source|
      "<style type='text/css'>#{Rails.application.assets.find_asset(source+".css")}</style>"
    }.join("\n").html_safe
  end

end