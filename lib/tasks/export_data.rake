# -*- coding: utf-8 -*-
require "erb"
namespace :irm do
  desc "(For Ironmine)Export menu data config."

  #def handle_menu(menu_hash, menu)
  #  parent_hash ||= {}
  #  parent_hash[menu.code.to_sym] = {}
  #  menu.menus_tls.each do |language|
  #    parent_hash[menu.code.to_sym][language[:language].to_sym] = {:name => language[:name], :description => language[:description]}
  #  end
  #  if menu.menu_entries.any?
  #    parent_hash[menu.code.to_sym][:children] = {}
  #    menu.menu_entries.each do |entry|
  #      type = entry[:sub_function_group_id].present?? 'function' : 'menu'
  #      if entry[:sub_menu_id]
  #        #找出对应的sub_menu
  #        sub_menu = Irm::Menu.find(entry[:sub_menu_id])
  #        parent_hash[menu.code.to_sym][:children][sub_menu.code.to_sym] = {}
  #        parent_hash[menu.code.to_sym][:children][sub_menu.code.to_sym][:type] = type
  #        entry.menu_entries_tls.each do |language|
  #          parent_hash[menu.code.to_sym][:children][sub_menu.code.to_sym][language[:language].to_sym] = {:name => language[:name], :description => language[:description]}
  #        end
  #        parent_hash[menu.code.to_sym][:children][sub_menu.code.to_sym][:entry] = {:sequence => entry[:display_sequence]}
  #        entry.menu_entries_tls.each do |language|
  #          parent_hash[menu.code.to_sym][:children][sub_menu.code.to_sym][:entry][language[:language].to_sym] = {:name => language[:name], :description => language[:description]}
  #        end
  #        menu_hash.delete_if{|i,v| i.to_s.eql?(entry[:sub_menu_id])}
  #        if sub_menu.menu_entries.any?
  #          parent_hash[menu.code.to_sym][:children][sub_menu.code.to_sym][:children] = handle_menu(menu_hash, sub_menu)
  #        end
  #      end
  #    end
  #  end
  #  parent_hash
  #end

  task :exportdata => :environment do
    CLEAR   = "\e[0m"
    BOLD    = "\e[1m"
    RED     = "\e[31m"
    GREEN   = "\e[32m"
    YELLOW  = "\e[33m"
    BLUE    = "\e[34m"

    puts "start export function groups......"
    function_groups = Irm::FunctionGroup.all
    function_data = ERB.new(File.read("#{Rails.root}/lib/templates/function_and_menu/function_template.rb"), nil, '-')
    output_function = "#{function_data.result(binding)}"
    file_function = File.new("#{Rails.root}/lib/function_data.rb",  "w+")
    file_function.write(output_function)
    file_function.close
    puts "#{GREEN}export function groups successfully!#{CLEAR}"

    puts "start export menus......"
    menus = Irm::Menu.all
    menu_data = ERB.new(File.read("#{Rails.root}/lib/templates/function_and_menu/menu_template.rb"), nil, '-')
    output_menu = "#{menu_data.result(binding)}"
    file_menu = File.new("#{Rails.root}/lib/menu_data.rb",  "w+")
    file_menu.write(output_menu)
    file_menu.close
    puts "#{GREEN}export menus successfully!#{CLEAR}"
  end
end