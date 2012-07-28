# -*- coding: utf-8 -*-
require 'nokogiri'

class Skm::Jobs::WikiDocJob<Struct.new(:options)
  def perform
    wiki = Skm::Wiki.find(options[:wiki_id])
    Irm::Person.current = Irm::Person.find(wiki.created_by)
    attachment = Irm::AttachmentVersion.find(options[:attachment_id])
    word_to_html(wiki, attachment)

    Irm::Person.current = nil
  end

  def word_to_html(wiki, attachment)
    miss = check_for_unoconv
    if check_for_unoconv.any?
      raise("Miss lib:#{miss}")
    end
    Dir.mkdir("#{Rails.root.to_s}/tmp/wiki_word", 0700) unless Dir.exists?("#{Rails.root.to_s}/tmp/wiki_word")
    Dir.mkdir("#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}", 0700) unless Dir.exists?("#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}")
    word_file_path = attachment.data.path
    html_file_path = "#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}/wiki_doc.html"
    log_file_path = "#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}/wiki_doc_log.txt"
    executable = "xvfb-run -a unoconv -f html --output=#{html_file_path} #{word_file_path} > #{log_file_path}"
    unless system(executable)
      raise(File.open(log_file_path, "rb").read)
    end
    doc = Nokogiri::HTML(process_html(File.open(html_file_path,"r").read))
    mark, files = generate_markdown(doc)
    mark.gsub!(/(\s*[\n\r]){2,}/,"  \n\n")

    File.open(log_file_path, 'a') do |f1|
      f1.puts("="*50+"before")
      f1.puts(mark)
    end

    wiki.content = mark
    wiki.description = "Generate content from #{attachment[:data_file_name]}"
    wiki.save

    File.open(log_file_path, 'a') do |f1|
      f1.puts("="*50+"after")
      f1.puts(wiki.content)
    end

    files.each do |f|
      atch = Irm::AttachmentVersion.new({:source_id => wiki.id, :source_type => wiki.class.name})
      atch.data = File.new("#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}/#{f[:origin_name]}")
      atch.data.instance_write :file_name, f[:name]
      atch.save

      File.open(log_file_path, 'a') do |f1|
        f1.puts(atch.errors)
        f1.puts(atch.data.path)
      end if atch.errors.any?

    end
    [mark, files]
  end

  def process_html(html_str)
    html_str = html_str.force_encoding("utf-8").gsub("</FONT>","").gsub(/<FONT.*>/,"")
    html_str
  end

  def generate_markdown(doc)
    mark_str = ""
    files = []
    doc.css("body").each do |b|
      block_str, block_files = process_block(b)
      mark_str << block_str
      files = files + block_files
    end

    [mark_str, files]

  end


  def process_block(node)
    #puts node.name
    files = []
    mark_code = ""
    node.children.each_with_index do |e, i|
      if 'div'.eql?(e.name.downcase)
        if e["id"]&&e["id"].include?("Table of Contents")
          next
        else
          node_mark, node_files = process_block(e)
          mark_code << node_mark
          files = files + node_files
          next
        end
      end

      img_nodes = e.css("img")

      h_nodes = e.css("h1,h2,h3,h4,h5,h6")
      if "h1,h2,h3,h4,h5,h6".split(",").include?(e.name.downcase)
        h_nodes = [e]
      end

      uol_nodes = e.css("ul,ol")
      if "ul,ol".split(",").include?(e.name.downcase)
        uol_nodes = [e]
      end

      table_nodes = e.css("table")
      if "table".split(",").include?(e.name.downcase)
        table_nodes = [e]
      end


      if img_nodes.any?
        img_nodes.each do |img|
          mark_code << process_line("[[#{img['name']}.#{img['src'].split('.').last}|alt=#{img['name']}|align=center]]")
          files << {:origin_name => img['src'], :name => "#{img['name']}.#{img['src'].split('.').last}"}
        end
      end

      if h_nodes.any?
        h_nodes.each do |h|
          text = h.text
          text = text.gsub(/^[\s\d\.]*(.*)\s*$/) do
            $1
          end
          if text.gsub("\n", "").gsub("\r", "").length == 0
            text = "empty"
          end
          mark_code << process_line("#{'#'*h.name.gsub("h", "").to_i} #{text}")
        end
      end

      if uol_nodes.any?
        uol_nodes.each do |u|
          if ("ul".eql?(u.name.downcase))
            u.css("li").each do |l|
              mark_code << process_line("* #{l.text}")
            end
          end
          if ("ol".eql?(u.name.downcase))
            u.css("li").each do |l|
              mark_code << process_line("* #{l.text}")
            end
          end
        end
      end

      if table_nodes.any?
        table_nodes.each do |t|
          next if t.text.gsub("\s", "").gsub("\n", "").gsub("\r", "").length==0
          mark_code << "<table>\n"
          t.css("tr").each do |tr|
            mark_code << "  <tr>\n"
            tr.css("td").each do |td|
              mark_code << "    <td>\n"
              mark_code << "      "+process_line(td.text)
              mark_code << "    </td>\n"
            end
            tr.css("th").each do |th|
              mark_code << "    <th style='width:#{th['width']};'>\n"
              mark_code << "      "+process_line(th.text.gsub("\n", "  ").gsub("\r", "  "))
              mark_code << "    </th>\n"
            end
            mark_code << "  </tr>\n"
          end
          mark_code << "</table>\n"
        end
      end


      if !"Table of Contents1".eql?(e['id'])&&!img_nodes.any?&&!h_nodes.any?&&!uol_nodes.any?&&e.text.gsub("\s", "").gsub("\n", "").gsub("\r", "").length>0
        mark_code << process_line("#{e.text}")
      end
    end
    [mark_code, files]
  end

  def process_line(text)
    text = text.gsub(/^\s*(\S.*)$/) do
      $1
    end
    text << "\n" unless ["\n", "\r"].include?(text[-1])

    text
  end

  def check_for_unoconv()
    miss = []
    miss << check("soffice", "-h", "python-uno (and unoconv)", 0)
    miss << check("xvfb-run", "-h", "xvfb", 0)
    miss << check("unoconv", "-h", "python-uno (and unoconv)", 1)
    miss.compact
  end

  def check(name, args, deb_package, expected = 0)
    system("#{name} #{args}")
    if $?.exitstatus != expected
      [name, deb_package]
    else
      nil
    end
  end
end

