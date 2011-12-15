module Chm::ChangePlansHelper
  def change_plan_body(plan)
    msg = plan[:plan_body]
    file_names = msg.scan(/!([a-zA-Z\d\-_]+\.[a-z]+)!/)
    file_names.each do |file_name_array|
      file_name = file_name_array[0]
      file = (plan.attachments||[]).detect{|f| f.data.original_filename.eql?(file_name)}
      if(file&&file.image?)
        msg = msg.gsub(/!#{file_name}!/,"<img  class='msgImage' title='#{file.data.original_filename}\n#{file.description}' src='#{file.data.url}'/>")
        next
      end

    end
    msg
  end

  def change_plan_file(plan)
    return unless plan.attachments.any?
    file_lists = ""
    plan.attachments.each do |f|
      file_lists << show_file(f)
    end
     content_tag(:div,file_lists.html_safe,{:class=>"fileList"})
  end

end
