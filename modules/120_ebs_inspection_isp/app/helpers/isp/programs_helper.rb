module Isp::ProgramsHelper

  def generate_params_input_html(program)
    html = ""
    program.params.each do

    end
  end

  def rowspan(check_items)
    count = check_items.count + 1
    check_items.each do |check_item|
      count += check_item.check_parameters.count
      count += 1
    end
    count
  end

end
