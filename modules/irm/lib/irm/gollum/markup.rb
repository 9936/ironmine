module Irm::Gollum::Markup
  def self.included(base)
    base.class_eval do
      def process_headers(doc)
        temp_doc = Nokogiri::XML::Document.new
        toc = nil
        doc.css('h1,h2,h3,h4,h5,h6').each do |h|
          id = CGI::escape(h.content.gsub(' ', '-'))
          level = h.name.gsub(/[hH]/, '').to_i

          # Add anchors
          anchor = Nokogiri::XML::Node.new('a', doc)
          anchor['class'] = 'anchor'
          anchor['id'] = id
          anchor['href'] = '#' + id
          h.add_child(anchor)

          # Build TOC
          toc ||= Nokogiri::XML::DocumentFragment.parse("<div class='toc'><div class='toc-title'>#{h.content}</div></div>")
          tail ||= toc.child
          tail_level ||= 0

          while tail_level < level
            node = Nokogiri::XML::Node.new('ul', temp_doc)
            tail = tail.add_child(node)
            tail_level += 1
          end
          while tail_level > level
            tail = tail.parent
            tail_level -= 1
          end
          node = Nokogiri::XML::Node.new('li', temp_doc)
          node.add_child("<a href='##{id}'>#{h.content}</a>")
          tail.add_child(node)

        end
        if toc != nil
          toc = toc.to_xhtml
        end
        [doc, toc]
      end
    end
  end
end