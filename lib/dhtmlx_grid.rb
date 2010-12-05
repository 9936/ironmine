module DhtmlxgridJson
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers
   def to_dhtmlxgrid_json(attributes,total)
    json = ""
    if total > 0
      json << %Q({rows:[)
      each do |elem|
        elem.id ||= index(elem)
        json << %Q({id:"#{elem.id}",data:[)
        couples = elem.attributes.symbolize_keys
        puts("------------------" + attributes.to_json)
        attributes.each do |atr|
          puts("++++++++++++" + atr.to_json)
          if atr.is_a? Array
            value = get_atr_value(elem, atr[0], couples)
            value = escape_javascript(value) if value and value.is_a? String
            if atr[0].to_s=='M'
              value='/images/multilingual.png'
            end
            json << %Q("#{value}^#{atr[1]}^#{atr[2]}^test",)
          else
            value = get_atr_value(elem, atr, couples)
            value = escape_javascript(value) if value and value.is_a? String
            if atr.to_s=='M'
              value='/images/multilingual.png'
            end
            json << %Q("#{value}",)
          end
        end
        json.chop! << "]},"
      end
      json.chop! << "]}"
    else
      json << "}"
    end
    json
  end

  private

  def get_atr_value(elem, atr, couples)
    if atr.to_s.include?('.')
      value = get_nested_atr_value(elem, atr.to_s.split('.').reverse)
    else
      value = couples[atr]
      value = elem.send(atr.to_sym) if value.blank? && elem.respond_to?(atr) # Required for virtual attributes
    end
    value
  end

  def get_nested_atr_value(elem, hierarchy)
    return nil if hierarchy.size == 0
    atr = hierarchy.pop
    raise ArgumentError, "#{atr} doesn't exist on #{elem.inspect}" unless elem.respond_to?(atr)
    nested_elem = elem.send(atr)
    return "" if nested_elem.nil?
    value = get_nested_atr_value(nested_elem, hierarchy)
    value.nil? ? nested_elem : value
  end
end