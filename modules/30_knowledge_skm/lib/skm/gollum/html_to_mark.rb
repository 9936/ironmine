class Skm::Gollum::HtmlToMark
  class << self
    def generate_markdown(html_str)
      html_str = process_html(html_str)
      doc = Nokogiri::HTML(process_html(html_str))
      mark_str = ""
      files = []
      @h_start = 0
      1.upto(6) do |i|
        if doc.css("h#{i}").length>0
          @h_start = i-1
          break
        end
      end

      doc.css("body").each do |b|
        block_str, block_files = process_block(b)
        mark_str << block_str
        files = files + block_files
      end

      mark_str = mark_str.gsub(/(\s*[\n\r]){2,}/, "  \n\n")

      [mark_str, files]

    end

    private

    def process_html(html_str)
      html_str = html_str.force_encoding("UTF-8").gsub("\u0004","").gsub("\u0005","")
      html_str
    end


    def process_block(node)
      #puts node.name
      files = []
      mark_code = ""
      node.children.each_with_index do |e, i|
        max = i
        if 'div'.eql?(e.name.downcase)
          unless e["id"]&&e["id"].include?("Table of Contents")
            node_mark, node_files = process_block(e)
            mark_code << node_mark
            files = files + node_files
          end
          next
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

        if h_nodes.any?
          h_nodes.each do |h|
            text = h.text
            text = text.gsub(/^[\s\d\.]*(.*)\s*$/) do
              $1
            end
            if text.gsub("\n", "").gsub("\r", "").length == 0
              text = "empty"
            end
            text = text.gsub("\n"," ").gsub("\r"," ").gsub(/\s{2,}/," ")
            mark_code << "#{'#'*(h.name.gsub("h", "").to_i-@h_start)} "+process_line("#{text}")
          end
        end


        if img_nodes.any?
          img_nodes.each do |img|
            mark_code << process_line("[[#{img['name']}.#{img['src'].split('.').last}|alt=#{img['name']}|align=center]]","img")
            files << {:origin_name => img['src'], :name => "#{img['name']}.#{img['src'].split('.').last}"}
          end
        end



        if !h_nodes.any?&&uol_nodes.any?
          uol_nodes.each do |u|
            if ("ul".eql?(u.name.downcase))
              u.css("li").each do |l|

                mark_code << process_line("* #{l.text.gsub("\n","").gsub("\r","")}") if l.text.gsub(/[\t\n\r\s]/,"").length>0
              end
            end
            if ("ol".eql?(u.name.downcase))
              u.css("li").each_with_index do |l,i|
                mark_code << process_line("#{i+1}. #{l.text.gsub("\n","").gsub("\r","")}") if l.text.gsub(/[\t\n\r\s]/,"").length>0
              end
            end
          end
        end

        if table_nodes.any?
          table_nodes.each do |t|
            next unless t.text.gsub("\s", "").gsub("\n", "").gsub("\r", "").length>0
            mark_code << "<table>\n"
            add_blank_row = true
            t.css("tr").each do |tr|
              next unless tr.css("th").length>0||add_blank_row||tr.text.gsub(/[\s\n\t\r]/, "").length>0
              mark_code << "  <tr>\n"
              tr.css("td").each do |td|
                mark_code << "    <td>\n"
                mark_code << "      "+process_line(td.text,"td")
                mark_code << "    </td>\n"
                add_blank_row = false
              end
              tr.css("th").each do |th|
                mark_code << "    <th style='width:#{th['width']};'>\n"
                mark_code << "      "+process_line(th.text.gsub("\n", "  ").gsub("\r", "  "),"td")
                mark_code << "    </th>\n"
              end
              mark_code << "  </tr>\n"

            end
            mark_code << "</table>\n"
          end


        end

         if !table_nodes.any?&&!img_nodes.any?&&!h_nodes.any?&&!uol_nodes.any?&&e.text.gsub("\s", "").gsub("\n", "").gsub("\r", "").length>0
           mark_code << process_line("#{e.text.gsub("\n"," ").gsub("\r"," ").gsub(/\s{2,}/," ")}")
         end
      end

      [mark_code, files]
    end

    def process_line(text,node_name=nil)
      text = text.gsub(/\t+/,"\t")
      text = text.gsub(/^\t*\s*(\S.*)\s*\t*$/) do
        $1
      end
      if !["img"].include?(node_name)
        text = text.gsub("<","\\<").gsub(">","\\>").gsub("#","\\#").gsub("[","\\[").gsub("]","\\]")
      end
      if "td".eql?(node_name)
        text << "\n" unless ["\n","\r"].include?(text[-1])
      else
        text << "\n\n"
      end

      text
    end
  end
end