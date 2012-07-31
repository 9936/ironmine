module Irm::FormHelper
  extend ActiveSupport::Concern

  def array_form_for(record_array, *args, &proc)
        raise ArgumentError, "Missing block" unless block_given?
        raise ArgumentError, "Not array" unless record_array.is_a?(Array)

        options = args.extract_options!

        output = ""

        record_array.each_index do |index|
          object = record_array[index]
          object_name = (options[:as] || ActiveModel::Naming.singular(object))+("[#{index}]")
          apply_form_for_options!(object, options)
          args.unshift object
          output << fields_for(object_name, *(args << options), &proc)
        end

        (options[:html] ||= {})[:remote] = true if options.delete(:remote)

        form_content = form_tag(options.delete(:url) || {}, options.delete(:html) || {})
        form_content.safe_concat(output)
        form_content.safe_concat('</form>')
  end

  def named_fields_for(name,real_object, *args, &block)
    object = real_object
    @template.fields_for(name, *args, &block)
  end

  def form_for(record, options = {}, &proc)
    raise ArgumentError, "Missing block" unless block_given?

    options[:html] ||= {}

    case record
    when String, Symbol
      object_name = record
      object      = nil
    else
      object      = record.is_a?(Array) ? record.last : record
      object_name = options[:as] || ActiveModel::Naming.param_key(object)
      apply_form_for_options!(record, options)
    end

    options[:html][:remote] = options.delete(:remote) if options.has_key?(:remote)
    options[:html][:method] = options.delete(:method) if options.has_key?(:method)
    options[:html][:authenticity_token] = options.delete(:authenticity_token)

    builder = options[:parent_builder] = instantiate_builder(object_name, object, options, &proc)
    fields_for = fields_for(object_name, object, options, &proc)
    default_options = builder.multipart? ? { :multipart => true } : {}
    output = form_tag(options.delete(:url) || {}, default_options.merge!(options.delete(:html)))
    # 添加back_url 参数
    if params[:back_url].present?
      back_url = params[:back_url]
      back_url = CGI.unescape(back_url.to_s)
      output.safe_concat(hidden_field_tag('back_url', CGI.escape(back_url)))
    end
    output << fields_for
    output.safe_concat('</form>')
  end

  def form_tag_in_block(html_options, &block)
    content = capture(&block)
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat(form_tag_html(html_options))

    back_option = html_options.delete('back')
    if back_option
      if back_option.is_a?(Hash)
        output.safe_concat(hidden_field_tag('back_url', CGI.escape(url_for(back_option))))
      else
        output.safe_concat(hidden_field_tag('back_url', CGI.escape(params[:back_url]||url_for({}))))
      end
    end


    output << content
    output.safe_concat("</form>")
  end
end