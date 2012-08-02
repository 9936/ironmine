# -*- coding: utf-8 -*-
require 'nokogiri'

class Skm::Jobs::WikiDocJob<Struct.new(:options)
  def perform
    wiki = Skm::Wiki.find(options[:wiki_id])
    Irm::Person.current = Irm::Person.find(wiki.created_by)
    attachment = Irm::AttachmentVersion.find(options[:attachment_id])
    word_to_html(wiki, attachment)

    Irm::Person.current = nil
  end

  def word_to_html(wiki, attachment)
    miss = check_for_unoconv
    if check_for_unoconv.any?
      raise("Miss lib:#{miss}")
    end
    Dir.mkdir("#{Rails.root.to_s}/tmp/wiki_word", 0700) unless Dir.exists?("#{Rails.root.to_s}/tmp/wiki_word")
    Dir.mkdir("#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}", 0700) unless Dir.exists?("#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}")
    word_file_path = attachment.data.path
    html_file_path = "#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}/wiki_doc.html"
    log_file_path = "#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}/wiki_doc_log.txt"
    executable = "xvfb-run -a unoconv -f html --output=#{html_file_path} #{word_file_path} > #{log_file_path}"
    unless system(executable)
      raise(File.open(log_file_path, "rb").read)
    end

    # 将html转化为
    mark, files = Skm::Gollum::HtmlToMark.generate_markdown(File.open(html_file_path, "r").read)

    wiki.content = mark
    wiki.description = "Generate content from #{attachment[:data_file_name]}"
    #sync with ui
    wiki.sync_flag = Irm::Constant::SYS_YES
    wiki.save

    File.open(log_file_path, 'a') do |f1|
      f1.puts("="*50+"after")
      f1.puts(wiki.content)
    end

    files.each do |f|
      atch = Irm::AttachmentVersion.new({:source_id => wiki.id, :source_type => wiki.class.name})
      atch.data = File.new("#{Rails.root.to_s}/tmp/wiki_word/#{attachment.id}/#{f[:origin_name]}")
      atch.data.instance_write :file_name, f[:name]
      atch.save

      File.open(log_file_path, 'a') do |f1|
        f1.puts(atch.errors)
        f1.puts(atch.data.path)
      end if atch.errors.any?

    end
    [mark, files]
  end

  def check_for_unoconv()
    miss = []
    miss << check("soffice", "-h", "python-uno (and unoconv)", 0)
    miss << check("xvfb-run", "-h", "xvfb", 0)
    miss << check("unoconv", "-h", "python-uno (and unoconv)", 1)
    miss.compact
  end

  def check(name, args, deb_package, expected = 0)
    system("#{name} #{args}")
    if $?.exitstatus != expected
      [name, deb_package]
    else
      nil
    end
  end
end

