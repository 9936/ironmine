# -*- coding:utf-8 -*-
class MovePeopleFromTmpToProd < ActiveRecord::Migration
  def up
    result = execute(%Q(SELECT cpt.organization '0', cpt.name '1', cpt.tel '2', cpt.mobile '3', cpt.mail '4',
                            cpt.group '5', cpt.login_name '6', cpt.id '7'
                            FROM cpi_people_tmp cpt WHERE cpt.status IS NULL))
    opu_id = Irm::OperationUnit.where("1=1").first.id
    group_id = ''
    organization_id = ''
    profile_id = ''
    system_profile_id = ''
    result.each do |rs|
      case rs[0].to_s
        when "中心组"
          organization_id = '001q000A41zcd8mhPr1wye'
          profile_id = '001z00012i8IyyjJaqK4AK'
          external_system_id = ''
          system_profile_id = '001z00040CSnl4HOpHUGf2'
        when "蒙东能源"
          organization_id = '001q000A41zcd8nNp7ejZ2'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNr9TIxs'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "黄河公司"
          organization_id = '001q000A41zcd8nNpHZhQ0'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNrJF91c'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "河南公司"
          organization_id = '001q000A41zcd8nNpSJIP2'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNrTsNTE'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "重庆分公司"
          organization_id = '001q000A41zcd8nNpamkIC'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNrcs4rg'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "河北公司"
          organization_id = '001q000A41zcd8nNptJMQq'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNrwiH20'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "江西公司"
          organization_id = '001q000A41zcd8nNpjUsxk'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNrnF57Y'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "上海电力"
          organization_id = '001q000A41zcd8nNq8KTuC'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNs6i5wG'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        when "五凌电力"
          organization_id = '001q000A41zcd8nNqOQO0G'
          profile_id = '001z00024DLIQpNqWEiUOO'
          external_system_id = '000q000A41zcd8nNsgxy8e'
          system_profile_id = '001z00040CSnl4HOodQjE8'
        else
          execute(%Q(UPDATE cpi_people_tmp SET status = 'ORG_ERROR', updated_at = NOW() WHERE id = '#{rs[7]}'))
          next
      end
      case rs[5].to_s
        when "综合组"
          group_id = '0014000A41zcd8nO90ARM0'
        when "技术组"
          group_id = '0014000A41zcd8nO8lOqrA'
        else
          group_id = ''
      end
      notification_flag = 'N'
      assignment_availability_flag = 'Y'
      if rs[4].present?
        email_address = rs[4]
      else
        email_address = 'hismstempaddress@cpiinfo.com'
      end
      puts("++++++++++++++++++++++++++++++++++++++++++++++++ RS:" + rs.to_json)
      t = nil
      begin
        t = Irm::Person.create(:opu_id => opu_id,
                               :organization_id => organization_id,
                               :first_name => rs[1],
                               :hashed_password => '3d4f2bf07dc1be38b20cd6e46949a1071f9d0e3d',
                               :bussiness_phone => rs[3],
                               :profile_id => profile_id,
                               :notification_flag => notification_flag,
                               :assignment_availability_flag => assignment_availability_flag,
                               :email_address => email_address,
                               :login_name => rs[6],
                               :identity_id => Time.now.strftime('%Y-%m-%d').to_s)
        puts("++++++++++++++++++++++++++++++++++++++++++++++++" + t.to_json)
      rescue
        puts("++++++++++++++++++++++++++++++++++++++++++++++++ saving rescue: " + t.errors.to_json)
        execute(%Q(UPDATE cpi_people_tmp SET status = '#{t.errors.to_json.to_s}', updated_at = NOW() WHERE id = '#{rs[7]}'))
        next
      end
      if t.errors.any?
        puts("++++++++++++++++++++++++++++++++++++++++++++++++ saving rescue: " + t.errors.to_json)
        execute(%Q(UPDATE cpi_people_tmp SET status = '#{t.errors.to_json.to_s}', updated_at = NOW() WHERE id = '#{rs[7]}'))
        next
      end
      puts("-----------------------------------------------------" + t.to_json)
      puts("-----------------------------------------------------" + group_id)
      if group_id.present?
        Irm::GroupMember.create(:opu_id => opu_id,:person_id => t.id, :group_id => group_id)
        puts("----------------------------------------------------- after insert into group" )
      end
      if external_system_id.present?
        Irm::ExternalSystemPerson.create(:opu_id => opu_id,
                                         :external_system_id => external_system_id,
                                         :person_id => t.id,
                                         :system_profile_id => system_profile_id )
        puts("----------------------------------------------------- after insert into system" )
      else
        Irm::ExternalSystem.where("1=1").each do |ie|
          Irm::ExternalSystemPerson.create(:opu_id => opu_id,
                                           :external_system_id => ie.id,
                                           :person_id => t.id,
                                           :system_profile_id => system_profile_id )
          puts("----------------------------------------------------- after insert into system" )
        end
      end
    end
  end

  def down

  end
end
