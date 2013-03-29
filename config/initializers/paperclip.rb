if Rails.env=="macdev"
  Paperclip.options[:command_path] = '/opt/local/bin'
else
  Paperclip.options[:command_path] = '/usr/local/bin'
end
