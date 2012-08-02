module Chm::ChangeJournalsHelper
  def change_message_body(msg,journal_id)
    file_names = msg.scan(/!([a-zA-Z\d\-_]+\.[a-z]+)!/)
    file_names.each do |file_name_array|
      file_name = file_name_array[0]
      file = (@request_files[journal_id]||[]).detect{|f| f.data.original_filename.eql?(file_name)}
      if(file&&file.image?)
        msg = msg.gsub(/!#{file_name}!/,"<img  class='msgImage' title='#{file.data.original_filename}\n#{file.description}' src='#{file.data.url}'/>")
        next
      end

      @request_files.values.each do |files|
        file = files.detect{|f| f.data.original_filename.eql?(file_name)}
        if(file&&file.image?)
          msg = msg.gsub(/!#{file_name}!/,"<img  class='msgImage' title='#{file.data.original_filename}\n#{file.description}' src='#{file.data.url}'/>")
          break
        end
      end
    end
    msg
  end


  def change_files(journal_id)
    return unless @request_files[journal_id].present?&&@request_files[journal_id].size>0
    file_lists = ""
    @request_files[journal_id].each do |f|
      file_lists << show_file(f)
    end
     content_tag(:div,file_lists.html_safe,{:class=>"fileList"})
  end


end
