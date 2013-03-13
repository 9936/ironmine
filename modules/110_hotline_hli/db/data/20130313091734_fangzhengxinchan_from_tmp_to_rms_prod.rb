# -*- coding: utf-8 -*-
class FangzhengxinchanFromTmpToRmsProd < ActiveRecord::Migration
  def up
    #admin_numbers = "'1518', '1467', '009', '4107', '1927', '123', '447', '270'" #0510
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    #organization_3 = Irm::Organization.where("short_name = ?", 'HAND_SUPPORT_CUSTOMER').first
    #先把所有组织挂到客户组织下
    #execute("UPDATE tmp_irm_organizations io SET io.parent_org_id = '#{organization_3.id}' WHERE io.id <> '#{organization_3.id}'")

    #organization_1 = Irm::Organization.where("short_name = ?", 'HAND_SUPPORT').first
    #organization_2 = Irm::Organization.where("short_name = ?", 'HAND_EBS_SUPPORT').first

    #icm
    execute("INSERT INTO icm_incident_requests SELECT * FROM tmp_icm_incident_requests")
    #execute("INSERT INTO icm_incident_workloads SELECT * FROM tmp_icm_incident_workloads")

    execute("INSERT INTO icm_incident_categories SELECT * FROM tmp_icm_incident_categories")
    execute("INSERT INTO icm_incident_categories_tl SELECT * FROM tmp_icm_incident_categories_tl")
    execute("INSERT INTO icm_incident_category_systems SELECT * FROM tmp_icm_incident_category_systems")

    execute("INSERT INTO icm_incident_journals SELECT * FROM tmp_icm_incident_journals")
    execute("INSERT INTO icm_incident_journal_elapses SELECT * FROM tmp_icm_incident_journal_elapses")
    execute("INSERT INTO icm_incident_histories SELECT * FROM tmp_icm_incident_histories")
    execute("INSERT INTO icm_incident_request_relations SELECT * FROM tmp_icm_incident_request_relations")
    execute("INSERT INTO irm_watchers SELECT * FROM tmp_irm_watchers")

    #organization
    #execute("INSERT INTO irm_organizations SELECT * FROM tmp_irm_organizations")
    #execute("INSERT INTO irm_organizations_tl SELECT * FROM tmp_irm_organizations_tl")

    #external system
    execute("INSERT INTO irm_external_systems SELECT * FROM tmp_irm_external_systems")
    execute("INSERT INTO irm_external_systems_tl SELECT * FROM tmp_irm_external_systems_tl")

    #运维组
    group_1 = Irm::Group.where(:code=>'EBS_HELP_DESK').first
    #把所有项目组挂到运维组下
    execute("UPDATE tmp_irm_groups ig SET ig.parent_group_id = '#{group_1.id}' WHERE ig.id <> '#{group_1.id}'")
    #用户组
    #group_2 = Irm::Group.where(:code=>'USER').first
    #
    #execute("UPDATE irm_people ip SET ip.organization_id = '#{organization_2.id}' WHERE ip.email_address LIKE '%@hand-china.com'")
    #cux_p = execute(%Q(SELECT
    #    ip.id '0', now() '1', ig.id '2', ies.id '3'
    #FROM
    #    irm_people ip,
    #    mantis_project_user_list_table mpl,
    #    tmp_irm_groups ig,
    #    tmp_irm_external_systems ies
    #WHERE
    #    mpl.user_id = ip.identity_id AND ig.code = mpl.project_id AND ip.email_address LIKE '%@hand-china.com' AND ip.identity_id NOT IN (#{admin_numbers}) AND ies.external_system_code = mpl.project_id)) #0510
    #cux_p.each do |cp|
    #  execute("INSERT INTO irm_group_members (id, group_id, person_id, opu_id, status_code, created_by, updated_by, created_at, updated_at)
    #                            VALUES ('#{Irm::IdGenerator.instance.generate("irm_group_members")}', '#{cp[2]}', '#{cp[0]}', '#{opu}',
    #                            'ENABLED', '-1', '-1', '#{cp[1]}', '#{cp[1]}')")
    #  execute("INSERT INTO irm_external_system_people (id, opu_id, external_system_id, person_id, status_code, created_by, updated_by, created_at, updated_at)
    #                            VALUES ('#{Irm::IdGenerator.instance.generate("irm_external_systems_people")}', '#{opu}', '#{cp[3]}', '#{cp[0]}',
    #                            'ENABLED', '-1', '-1', '#{cp[1]}', '#{cp[1]}')")
    #end
    #
    #cux = execute(%Q(SELECT ip.id '0', pu.project_id '1', io.id '2', ie.id '3', now() '4'
    #                            FROM irm_people ip, mantis_project_user_list_table pu, tmp_irm_organizations io, tmp_irm_external_systems ie
    #                            WHERE ip.email_address NOT LIKE '%@hand-china.com' AND pu.user_id = ip.identity_id
    #                            AND io.short_name = pu.project_id AND ie.external_system_code = pu.project_id
    #                            AND (SELECT count(1) FROM  mantis_project_user_list_table pul WHERE pul.user_id = ip.identity_id) = 1))
    #cux.each do |c|
    #  execute("UPDATE irm_people ip SET ip.organization_id = '#{c[2]}' WHERE ip.id = '#{c[0]}'")
    #  execute("INSERT INTO irm_group_members (id, group_id, person_id, opu_id, status_code, created_by, updated_by, created_at, updated_at)
    #                            VALUES ('#{Irm::IdGenerator.instance.generate("irm_group_members")}', '#{group_2.id}', '#{c[0]}', '#{opu}',
    #                            'ENABLED', '-1', '-1', '#{c[4]}', '#{c[4]}')")
    #  execute("INSERT INTO irm_external_system_people (id, opu_id, external_system_id, person_id, status_code, created_by, updated_by, created_at, updated_at)
    #                            VALUES ('#{Irm::IdGenerator.instance.generate("irm_external_systems_people")}', '#{opu}', '#{c[3]}', '#{c[0]}',
    #                            'ENABLED', '-1', '-1', '#{c[4]}', '#{c[4]}')")
    #end

    #administrator
    #admin_numbers = "'1518'"
    ebs_group = Irm::Group.where("code = ?", 'EBS_HELP_DESK')
    #all_systems = execute(%Q(SELECT
    #        ies.id '0'
    #    FROM
    #        tmp_irm_external_systems ies))
    #admins = execute(%Q(SELECT
    #        ip.id '0', now() '1'
    #    FROM
    #        irm_people ip
    #    WHERE
    #        ip.login_name IN (#{admin_numbers})))
    ##将所有应用系统添加给管理员
    #all_systems.each do |s|
    #  admins.each do |ad|
    #    execute("INSERT INTO irm_external_system_people (id, opu_id, external_system_id, person_id, status_code, created_by, updated_by, created_at, updated_at)
    #                              VALUES ('#{Irm::IdGenerator.instance.generate("irm_external_systems_people")}', '#{opu}', '#{s[0]}', '#{ad[0]}',
    #                              'ENABLED', '-1', '-1', '#{ad[1]}', '#{ad[1]}')")
    #  end
    #end
    #admins.each do |ad|
    #  execute("INSERT INTO irm_group_members (id, group_id, person_id, opu_id, status_code, created_by, updated_by, created_at, updated_at)
    #                            VALUES ('#{Irm::IdGenerator.instance.generate("irm_group_members")}', '#{ebs_group.first.id}', '#{ad[0]}', '#{opu}',
    #                            'ENABLED', '-1', '-1', '#{ad[1]}', '#{ad[1]}')")
    #end

    #group
    execute("INSERT INTO irm_groups SELECT * FROM tmp_irm_groups")
    execute("INSERT INTO irm_groups_tl SELECT * FROM tmp_irm_groups_tl")
    execute("INSERT INTO icm_support_groups SELECT * FROM tmp_icm_support_groups")
    #people
    #execute("INSERT INTO irm_people SELECT * FROM tmp_irm_people")
  end

  def down
  end
end
