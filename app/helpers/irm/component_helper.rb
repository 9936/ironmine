module Irm::ComponentHelper
  def page_block( &block)
    output = ActiveSupport::SafeBuffer.new
    content = capture( &block)
    output << content
    render :partial=>"components/page_block",:locals=>{:content=>output}
  end

  def page_block_header(title,&block)
    output = ActiveSupport::SafeBuffer.new
    content = capture( &block)
    output << content
    render :partial=>"components/page_block_header",:locals=>{:title=>title,:content=>output}
  end

  def page_block_footer(&block)
    output = ActiveSupport::SafeBuffer.new
    content = capture( &block)
    output << content
    render :partial=>"components/page_block_footer",:locals=>{:content=>output}
  end

  def sub_page_block(title,&block)
    output = ActiveSupport::SafeBuffer.new
    content = capture( &block)
    output << content
    render :partial=>"components/sub_page_block",:locals=>{:title=>title,:content=>output}
  end

  def first_sub_page_block(title,&block)
    output = ActiveSupport::SafeBuffer.new
    content = capture( &block)
    output << content
    render :partial=>"components/first_sub_page_block",:locals=>{:title=>title,:content=>output}
  end
end