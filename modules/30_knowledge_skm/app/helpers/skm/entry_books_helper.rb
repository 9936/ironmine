module Skm::EntryBooksHelper
  def available_targets
    [[t(:label_skm_entry_header), "ENTRYHEADER"], [t(:label_skm_entry_book), "ENTRYBOOK"]]
  end

  def type_meaning(code)
    meaning = ''
    if code.eql?("ENTRYHEADER")
      meaning = t(:label_skm_entry_header)
    elsif code.eql?("ENTRYBOOK")
      meaning = t(:label_skm_entry_book)
    end
    meaning
  end

  def generate_entry_book(entry_book_id, h_num=1, h_num_str="")
    if h_num > 6
      h_num = 6
    end

    entry_book = Skm::EntryBook.find(entry_book_id)
    entry_book_relations = Skm::EntryBookRelation.order_by_sequence.targets(entry_book_id).index_by(&:target_id)
    relation_headers = entry_book.entry_headers
    relation_books = Skm::EntryBook.multilingual.query_books_by_relations(entry_book_id)

    if entry_book_relations.any?
      relation_headers.each do |header|
        if entry_book_relations[header.id.to_s].present?
          entry_book_relations[header.id.to_s] = header
        end
      end

      relation_books.each do |book|
        if entry_book_relations[book.entry_book_id.to_s].present?
          entry_book_relations[book.entry_book_id.to_s] = book
        end
      end
    end
    html = ""

    num_out = 0
    entry_book_relations.each do |target_id, target|
      num_out += 1

      if h_num == 2
        html += "<p class='h2-title'></p>"
      end
      if target[:relation_type].eql?("ENTRYBOOK")
        html += "<h#{h_num}>#{h_num_str}#{num_out}. #{target[:name]}</h#{h_num}>"
        #下一个章节编号应该是: 1.1.
        html += generate_entry_book(target.entry_book_id, h_num + 1 , "#{h_num_str}#{num_out}.")
      else
        html += "<h#{h_num}>#{h_num_str}#{num_out}. #{target.entry_title}</h#{h_num}>"
        #知识文章中的层级目录
        num_in = 0
        target.entry_details.each do |e|
          num_in += 1
          if h_num == 1
            html += "<p class='h2-title'></p>"
          end
          html += "<h#{h_num + 1}>#{h_num_str}#{num_out}.#{num_in}. #{raw(e.element_name)}</h#{h_num + 1}>"
          html += "<p>#{raw e.entry_content.gsub(/\r\n/, '<br/>')}</p>"
        end
        #检查是否有附件存在
        if target.attachments && target.attachments.any?
          num_in += 1
          if h_num == 1
            html += "<p class='h2-title'></p>"
          end
          html += "<h#{h_num + 1}>#{h_num_str}#{num_out}.#{num_in}. #{t(:label_irm_attachment)}</h#{h_num + 1}>"
          html += "<ul>"
          target.attachments.each do |a|
            version = a.last_version_entity
            html += "<li>"
            html += raw("<a target='_blank' href='#{request.protocol}#{request.host_with_port}#{version.data.url}' >#{version.data.original_filename}</a>")
            html += "</li>"
          end
          html += "</ul>"
        end
      end
    end
    html.html_safe
  end


  def watermark
    "#{request.protocol}#{request.host_with_port}/images/logos/hand-china.jpg"
  end
end
