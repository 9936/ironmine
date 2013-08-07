class Skm::WikiToStatic
  include Singleton

  def wiki_to_static(wiki, mode=nil)
    tmp_folder = "#{Rails.root.to_s}/tmp/skm/wikis/wiki_static/#{wiki.id}/#{wiki.md5_flag}"

    #if mode.present?
    #  if mode.to_sym.eql?(:html)&&File.exist?(tmp_folder+"/html.html")
    #    return tmp_folder+"/html.html"
    #  end
    #
    ##  if mode.to_sym.eql?(:html)
    ##    wiki_to_html(wiki, static_folder)
    ##    return tmp_folder+"/html.html"
    ##  end
    #end

    if !cached_static?(tmp_folder)&&mode.nil?
      Delayed::Worker.logger.debug("if !cached_static?(tmp_folder)&&mode.nil?")
      static_folder = check_folder("#{Rails.root.to_s}/tmp/skm/wikis/wiki_static/#{wiki.id}", wiki.md5_flag)
      wiki_to_pdf(wiki, static_folder)
      wiki_to_html(wiki, static_folder)
      wiki_to_word(static_folder)
      wiki_to_docx(static_folder)
    end

    if cached_static?(tmp_folder)&&mode.present?
      if mode.to_sym.eql?(:pdf)
        return tmp_folder+"/pdf.pdf"
      elsif mode.to_sym.eql?(:doc)
        return tmp_folder+"/doc.doc"
      elsif mode.to_sym.eql?(:docx)
        return tmp_folder+"/docx.docx"
      else
        return tmp_folder+"/html.html"
      end
    end
  end


  def wiki_to_static?(wiki, mode=nil)
    tmp_folder = "#{Rails.root.to_s}/tmp/skm/wikis/wiki_static/#{wiki.id}/#{wiki.md5_flag}"
    if mode.present?
      if mode.to_sym.eql?(:pdf)
        if !File.exist?(tmp_folder+"/pdf.pdf")
          publish_job(wiki)
          return false
        end
      elsif mode.to_sym.eql?(:doc)
        if !File.exist?(tmp_folder+"/doc.doc")
          publish_job(wiki)
          return false
        end
      elsif mode.to_sym.eql?(:docx)
        if !File.exist?(tmp_folder+"/docx.docx")
          publish_job(wiki)
          return false
        end
      elsif mode.to_sym.eql?(:html)
        if !File.exist?(tmp_folder+"/html.html")
          publish_job(wiki)
          return false
        end
      end
    elsif mode.nil?
      if !File.exist?(tmp_folder+"/html.html")||!File.exist?(tmp_folder+"/pdf.pdf")||!File.exist?(tmp_folder+"/doc.doc")||!File.exist?(tmp_folder+"/docx.docx")
        publish_job(wiki)
        return false
      end
    end
    return true
  end


  def wiki_to_doc(wiki, mode=nil)
    doc = page_to_doc(wiki.page, wiki.name, wiki.id, mode)
    doc = generate_sequence(doc)
  end

  def book_to_static?(book, mode=nil)
    tmp_folder = "#{Rails.root.to_s}/tmp/skm/books/wiki_static/#{book.id}/#{book.md5_flag}"
    if mode.present?
      if mode.to_sym.eql?(:pdf)
        if !File.exist?(tmp_folder+"/pdf.pdf")
          publish_job(book)
          return false
        end

      else
        if !File.exist?(tmp_folder+"/html.html")
          publish_job(book)
          return false
        end
      end
    else
      if !File.exist?(tmp_folder+"/html.html")||!File.exist?(tmp_folder+"/pdf.pdf")
        publish_job(book)
        return false
      end
    end
    return true
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


  def sync_wiki_static(wiki_id)
    publish_job(Skm::Wiki.find(wiki_id))
    Skm::Book.by_wiki(wiki_id).select_all.each do |b|
      publish_job(Skm::Book.find(b.id))
    end
  end

  def sync_book_static(book_id)
    publish_job(Skm::Book.find(book_id))
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
    begin
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    rescue Exception => e
      nil
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


  def wiki_to_word(folder)
    rtf_file_path = "#{folder}/rtf.rtf"
    html_file_path = "#{folder}/html.html"
    html_rtf_log = "#{folder}/html_rtf_log.txt"
    html_rtf = "xvfb-run -a unoconv -f rtf --output=#{rtf_file_path} #{html_file_path} > #{html_rtf_log}"
    doc_file_path = "#{folder}/doc.doc"
    rtf_doc_log = "#{folder}/rtf_doc_log.txt"
    rtf_doc = "xvfb-run -a unoconv -f doc --output=#{doc_file_path} #{rtf_file_path} > #{rtf_doc_log}"

    unless system(html_rtf)
      raise(File.open(html_rtf_log, "rb").read)
    end

    unless system(rtf_doc)
      raise(File.open(rtf_doc_log, "rb").read)
    end
  end

  def wiki_to_docx(folder)
    rtf_file_path = "#{folder}/rtf.rtf"
    #html_file_path = "#{folder}/html.html"
    #html_rtf_log = "#{folder}/html_rtf_log.txt"
    #html_rtf = "xvfb-run -a unoconv -f rtf --output=#{rtf_file_path} #{html_file_path} > #{html_rtf_log}"
    docx_file_path = "#{folder}/docx.docx"
    rtf_docx_log = "#{folder}/rtf_docx_log.txt"
    rtf_docx = "xvfb-run -a unoconv -f docx --output=#{docx_file_path} #{rtf_file_path} > #{rtf_docx_log}"

    #unless system(html_rtf)
    #  raise(File.open(html_rtf_log, "rb").read)
    #end
    unless system(rtf_docx)
      raise(File.open(rtf_docx_log, "rb").read)
    end
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
    #if page
    if wiki_id.present?
      page.attachments = Irm::AttachmentVersion.select_all.where(:source_id => wiki_id, :source_type => Skm::Wiki.name)
    end
    page.mode = mode
    doc = Nokogiri::HTML::DocumentFragment.parse(page.formatted_data.force_encoding("utf-8"))
    if title.present?
      doc = check_h1(title, doc)
    end
    return doc
    #else
    #  return Nokogiri::HTML::DocumentFragment.parse("#{I18n.t(:label_skm_wiki_git_folder_page_missing)}:#{wiki_id}<br/>")
    #end
  end


  def check_folder(folder_parent, folder)
    FileUtils.rm_r Dir.glob("#{folder_parent}/*")
    tmp_folder = "#{folder_parent}/#{folder}"
    FileUtils.mkdir_p(tmp_folder, :mode => 0777)
    tmp_folder
  end

  def cached_static?(folder)
    File.exists?("#{folder}/html.html")&&File.exists?("#{folder}/pdf.pdf")&&File.exists?("#{folder}/doc.doc")&&File.exists?("#{folder}/docx.docx")
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

  def publish_job(model, event_type="UPDATE")
    bo_code = Irm::BusinessObject.class_name_to_code(model.class.name)
    #消除重复的事件
    return if Irm::Event.where(:bo_code => bo_code, :business_object_id => model.id, :event_code => "SKM_WIKI_EVENT", :event_type => event_type, :end_at => nil).count>0
    event = Irm::Event.create(:bo_code => bo_code, :business_object_id => model.id, :event_code => "SKM_WIKI_EVENT", :event_type => event_type)
    Delayed::Job.enqueue(Skm::Jobs::StaticWikiAndBookJob.new(event.id))
  end

end