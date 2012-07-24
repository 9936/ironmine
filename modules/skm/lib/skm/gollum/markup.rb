module Skm::Gollum::Markup
  def self.included(base)
    base.class_eval do
      #　加入附件
      def initialize(page)
        @wiki = page.wiki
        @name = page.filename
        @data = page.text_data
        @version = page.version.id if page.version
        @format = page.format
        @sub_page = page.sub_page
        @parent_page = page.parent_page
        @attachments = page.attachments||[]
        @mode = page.mode||:normal
        @dir = ::File.dirname(page.path)
        @tagmap = {}
        @codemap = {}
        @texmap = {}
        @wsdmap = {}
        @premap = {}
        @toc = nil
      end

      def render(no_follow = false, encoding = nil)
        sanitize = no_follow ?
            @wiki.history_sanitizer :
            @wiki.sanitizer

        data = @data.dup
        data = preprocess(data)
        #data = extract_code(data)
        data = extract_tex(data)
        data = extract_wsd(data)
        data = extract_tags(data)
        begin
          data = GitHub::Markup.render(@name, data)
          if data.nil?
            raise "There was an error converting #{@name} to HTML."
          end
        rescue Object => e
          data = %{<p class="gollum-error">#{e.message}</p>}
        end
        data = process_tags(data)
        data = process_code(data, encoding)

        doc = Nokogiri::HTML::DocumentFragment.parse(data)
        doc = sanitize.clean_node!(doc) if sanitize
        doc, toc = process_headers(doc)
        @toc = @sub_page ? (@parent_page ? @parent_page.toc_data : "[[_TOC_]]") : toc
        yield doc if block_given?
        data = doc.to_html

        data = process_toc_tags(data)
        data = process_tex(data)
        data = process_wsd(data)
        data.gsub!(/<p><\/p>/, '')
        data
      end

      def preprocess(data)
        data = data.gsub(/(```)\s+/m) do
          "#{$1}\n"
        end

        data = extract_code(data)

        data = data.gsub(/!\[(.+?)\]\(([^\(]+)\)/m) do
          "[[#{$2}|alt=#{$1}]]"
        end
        data = data.gsub(/\[([^\[]+)\]\[internal-ref\]/m) do
          "[[#{$1}]]"
        end
        data = data.gsub(/(\S)(\s*[\n\r]+)/) do
          "#{$1}  #{$2}  #{$2}"
        end
      end


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

      def process_image_tag(tag)
        parts = tag.split('|')
        return if parts.size.zero?

        name = parts[0].strip
        path = if file = find_file(name)
                 file.path
               elsif name =~ /^https?:\/\/.+(jpg|png|gif|svg|bmp)$/i
                 name
               end

        if path
          opts = parse_image_tag_options(tag)

          containered = false

          classes = [] # applied to whatever the outermost container is
          attrs = [] # applied to the image

          align = opts['align']
          if opts['float']
            containered = true
            align ||= 'left'
            if %w{left right}.include?(align)
              classes << "float-#{align}"
            end
          elsif %w{top texttop middle absmiddle bottom absbottom baseline}.include?(align)
            attrs << %{align="#{align}"}
          elsif align
            if %w{left center right}.include?(align)
              containered = true
              classes << "align-#{align}"
            end
          end

          if width = opts['width']
            if width =~ /^\d+(\.\d+)?(em|px)$/
              attrs << %{width="#{width}"}
            end
          end

          if height = opts['height']
            if height =~ /^\d+(\.\d+)?(em|px)$/
              attrs << %{height="#{height}"}
            end
          end

          if alt = opts['alt']
            attrs << %{alt="#{alt}"}
          end

          attr_string = attrs.size > 0 ? attrs.join(' ') + ' ' : ''

          if opts['frame'] || containered
            classes << 'frame' if opts['frame']
            %{<span class="#{classes.join(' ')}">} +
                %{<span>} +
                %{<img src="#{path}" #{attr_string}/>} +
                %{</span>} +
                %{</span>}
          else
            %{<img src="#{path}" #{attr_string}/>}
          end
        end
      end

      # 查找附件
      def find_file(name)
        file = nil
        if name =~ /^\//
          file = @wiki.file(name[1..-1], @version)
        else
          path = @dir == '.' ? name : ::File.join(@dir, name)
          file =@wiki.file(path, @version)
        end
        unless file
          file = @attachments.detect { |i| name.eql?(i[:data_file_name]) }
          if file
            if @mode.eql?(:pdf)
              file = Skm::Gollum::File.new(file.data.path)
            else
              file = Skm::Gollum::File.new(file.data.url)
            end
          end

        end
        file
      end

      def process_page_link_tag(tag)
        parts = tag.split('|')
        parts.reverse! if @format == :mediawiki

        name, page_name = *parts.compact.map(&:strip)
        cname = @wiki.page_class.cname(page_name || name)

        if name =~ %r{^https?://} && page_name.nil?
          %{<a href="#{name}">#{name}</a>}
        else
          presence = "absent"
          link_name = cname
          page = find_page_from_name(cname)
          link="#"
          if page
            presence = "present"
            if @mode.eql?(:pdf)
              link = page.show_url(true)
            else
              link = page.show_url
            end
          end

          %{<a class="internal #{presence}" href="#{link}">#{name}</a>}
        end
      end

      def find_page_from_name(cname)
        Skm::Wiki.where(:name => cname).first
      end
    end
  end
end