# -*- coding: utf-8 -*-

namespace :irm do
  desc "(For Ironmine)Add Peron to all hotline systems."
  task :add_person => :environment do
    Irm::Person.current = Irm::Person.find_by_login_name("ironmine")

    person = Irm::Person.find_by_login_name("7577")
    #person = Irm::Person.find_by_login_name("1927")

    if person.present?
      Irm::ExternalSystem.where(:hotline_flag => 'Y').each do |system|
        #检查用户是否在这个系统里面
        exists_people = Irm::ExternalSystemPerson.where("external_system_id =? AND person_id = ?", system.id, person.id)
        unless exists_people.any?
          system_person = Irm::ExternalSystemPerson.new(:external_system_id => system.id,
                                                      :system_profile_id => "001z00040CSnl4HOpiw3w8",
                                                      :person_id => person.id)
          system_person.save
        end
      end
      puts "===================Successfully!"
    else
      puts "===================No person found."
    end
  end

  #Import Users from excel
  desc "(For Ironmine)mport Users from excel"
  task :import_user => :environment do
    require 'roo'
    puts "==========Start import......"
    Irm::Person.current = Irm::Person.find_by_login_name("ironmine")
    org_name_id_hash = {"管理部"=>"001q000A1oketH349LVVY0", "管理部経理グループ"=>"001q000A1oketH348qD7hI", "管理部人事総務グループ"=>"001q000A1oketH348b4d7I"}
    group_name_id_hash = {"管理部"=>"0014000A1oketH34BwOvNA", "管理部経理グループ"=>"0014000A1oketH34BhW0WG", "管理部人事総務グループ"=>"0014000A1oketH34BTq0A4"}
    sys_name_id_hash = {"Y-Manager" => "000q000A1ojaxE74GqND0q", "就業管理" => "000q000A1pIgqkSqV00Trs", "Time Pro" => "000q000A1ojaxE74Gl5bCS"}
    profile_name_id_hash = {"End User" => "001z00091noAOhtd8cVK0u", "Support Manager" => "001z00091noAOhtd7MtMPI", "Supporter" => "001z00091noAOhtdBVgg7s", "Front" => "001z00091noAOhtdCRpPvc"}
    sys_profile_name_id_hash = {"End User" => "001z00040QPlt8MvdoONwe", "Support Manager" => "001z00040CSnl4HOpiw3w8", "Supporter" => "001z00040CSnl4HOpHUGf2", "Front" => "001z00040CSnl4HOodQjE8"}
    #导入组织
    org_excel_file_path = "/home/zhangyi/orgs.xlsx"
    spreadsheet = Roo::Excelx.new(org_excel_file_path)
    (3..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      org_name = row[1]
      if org_name.present?
        unless org_name_id_hash[org_name]
          org = Irm::Organization.new(:name => org_name,
                                      :short_name =>  "ORG_#{row[0].to_i}",
                                      :description => org_name)
          org.save
          org_name_id_hash["#{org_name}"] = org.id
        end
      end
    end
    #导入用户
    user_excel_file_path = "/home/zhangyi/users.xlsx"
    spreadsheet = Roo::Excelx.new(user_excel_file_path)
    (3..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      login_name = row[1]
      names = row[2]
      if names
        name_arr = names.split("　")
        first_name = name_arr[1] || name_arr[0]
        last_name = name_arr[0]
      else
        first_name = names
        last_name = names
      end
      mail_address = row[3]
      org_id = org_name_id_hash[row[4]]
      group_id = group_name_id_hash[row[4]]
      profile_id = profile_name_id_hash[row[5]]
      system_profile_id = sys_profile_name_id_hash[row[5]]
      bussiness_phone = "-"
      if login_name.present? && first_name.present? && mail_address.present? && org_id.present? && profile_id
        #puts "============================#{i}:#{first_name}"
        person = Irm::Person.new(:login_name => login_name,
                                 :email_address => mail_address,
                                 :profile_id => profile_id,
                                 :language_code => 'ja',
                                 :notification_lang => 'ja',
                                 :time_zone => 'Osaka',
                                 :organization_id => org_id,
                                 :first_name => first_name,
                                 :last_name => last_name,
                                 :bussiness_phone => bussiness_phone,
                                 :password => "handhand123",
                                 :password_confirmation => "handhand123")
        if person.save
          #添加到系统中
          ["000q000A1ojaxE74GqND0q", "000q000A1pIgqkSqV00Trs", "000q000A1ojaxE74Gl5bCS"].each do |system_id|
            system_person = Irm::ExternalSystemPerson.new(:external_system_id => system_id,
                                                          :system_profile_id => system_profile_id,
                                                          :person_id => person.id)
            system_person.save
          end
          #将人员添加到组
          if group_id.present?
            group_member = Irm::GroupMember.new(:group_id => group_id,
                                                :person_id => person.id)
            group_member.save
          end
        else
          puts "==============================#{person.errors.to_json}"
          puts "========================Error:====#{i}:#{first_name}"
        end
      end
    end
  end

end