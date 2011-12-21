module Irm
  module PageComponentHelper
    extend ActiveSupport::Concern

    def page(name="", options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      unless name.present?
        name = "#{params[:controller].gsub(/.*\//,"")}_#{params[:action]}"
      end
      output = ActiveSupport::SafeBuffer.new
      builder = page_builder(name, options, &block)
      output.safe_concat "<div id= '#{name}' class='page'>"
      output.safe_concat capture(builder, &block)
      output.safe_concat('</div>')
      output
    end


    def page_header(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new
      # begin
      output.safe_concat("<div id= '#{name}Header' class='pHeader'>")

      # title
      output.safe_concat("<div id= '#{name}HeaderTitle' class='pHeaderTitle'>")
      output.safe_concat(common_title(options[:title_options]||{}))
      output.safe_concat("</div>")
      # body
      output << capture( &block) if block_given?

      #end
      output.safe_concat('</div>')
    end

    def page_body(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat("<div id= '#{name}Body' class='pBody'>")
      content = nil
      content = capture( &block)  if block_given?
      output << content
      output.safe_concat('</div>')
    end

    def page_footer(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat("<div id= '#{name}Body' class='pFooter'>")
      content = nil
      content = capture( &block)  if block_given?
      output << content
      output.safe_concat('</div>')
    end


    def page_block(name, options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      output = ActiveSupport::SafeBuffer.new
      builder = page_builder(name, options, &block)

      # 查看页面区域
      if options.delete(:show)
        output.safe_concat "<div id= '#{name}Block' class='detail-block pageBlock page-block'>"
      else
        output.safe_concat "<div id= '#{name}Block' class='edit-block pageBlock page-block'>"
      end

      output.safe_concat capture(builder, &block)
      output.safe_concat('</div>')
      output
    end

    def page_block_header(name,options={}, &block)
      title = options[:title]||""

      output = ActiveSupport::SafeBuffer.new
      # begin
      output.safe_concat("<div id= '#{name}BlockHeader' class='pbHeader'>")

      # body
      content = nil
      content = capture( &block)  if block_given?

      # header table
      table_html = <<-TABLE_HTML
        <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
            <tr>
              <td class="pbTitle"><h2 class="mainTitle">#{title}</h2></td>
              #{content}
            </tr>
          </tbody>
        </table>
      TABLE_HTML

      output.safe_concat(table_html)

      output.safe_concat('</div>')
    end

    def page_block_body(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat("<div id= '#{name}BlockBody' class='pbBody'>")
      content = nil
      content = capture( &block)  if block_given?
      output << content
      output.safe_concat('</div>')
    end

    def page_block_footer(name,options={}, &block)

      output = ActiveSupport::SafeBuffer.new
      # begin
      output.safe_concat("<div id= '#{name}BlockFooter' class='pbBottomButtons pbFooter'>")

      # body
      content = nil
      content = capture( &block)  if block_given?

      # header table
      table_html = <<-TABLE_HTML
        <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
            <tr>
              <td class="pbTitle"><h2 class="mainTitle"></h2></td>
              #{content}
            </tr>
          </tbody>
        </table>
      TABLE_HTML

      output.safe_concat(table_html)

      output.safe_concat('</div>')
    end


    def sub_page_block(name, options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      output = ActiveSupport::SafeBuffer.new
      builder = page_builder(name, options, &block)

      output.safe_concat "<div id= '#{name}SubPageBlock' class='subPageBlock'>"
      output.safe_concat capture(builder, &block)
      output.safe_concat('</div>')
      output
    end


    def sub_page_block_header(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new

      title = options[:title]||""

      # 查看页面区域
      if options.delete(:first)
        output.safe_concat "<div id= '#{name}SubPageBlockHeader' class='spbHeader pbSubheader first tertiaryPalette'>"
        require_text = <<-REQUIRE_TEXT
          <span class="pbSubExtra">
            <span class="requiredLegend">
              <span class="requiredExampleOuter">
                <span class="requiredExample">&nbsp;</span>
              </span><span class="requiredMark">*</span>
              <span class="requiredText"> = #{t(:label_is_required)}</span>
            </span>
          </span>
        REQUIRE_TEXT



        output.safe_concat(require_text)
      else
        output.safe_concat "<div id= '#{name}SubPageBlockHeader' class='spbHeader pbSubheader first tertiaryPalette'>"
      end

      output.safe_concat("<h3>#{title}</h3>")

      content = nil
      content = capture( &block)  if block_given?
      output << content

      output.safe_concat('</div>')
    end

    def sub_page_block_body(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat("<div id= '#{name}SubPageBlockBody' class='spbBody pbSubsection'>")
      content = nil
      content = capture( &block)  if block_given?
      output << content
      output.safe_concat('</div>')
    end

    def sub_page_block_footer(name,options={}, &block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat("<div id= '#{name}SubPageBlockFooter' class='spbFooter pbSubsection'>")
      content = nil
      content = capture( &block)  if block_given?
      output << content
      output.safe_concat('</div>')
    end

    private

    def page_builder(name, options, &block)
      CommonPageBuilder.new(name, self, options, block)
    end
  end

  class CommonPageBuilder
    class_attribute :page_helpers

    self.page_helpers = PageComponentHelper.instance_method_names

    def initialize(page_name,template, options, proc)
      @nested_child_index = {}
      @page_name ,@template, @options, @proc = page_name, template, options, proc
      @default_options = @options ? @options.slice(:index) : {}
    end

    page_helpers.each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(options = {},&proc)    # def text_field(options = {},&proc)
          @template.send(                      #   @template.send(
            #{selector.inspect},               #     "page_header",
            @page_name,                        #     @page_name,
            options,&proc)                     #     options,&proc)
        end                                    # end
      RUBY_EVAL
    end

  end

end

