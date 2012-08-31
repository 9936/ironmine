# -*- coding: utf-8 -*-
class AddChangeApproveFunction < ActiveRecord::Migration
  def up
    chm_advisory_board= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'ADVISORY_BOARD',:controller=>'chm/advisory_boards',:action=>'index',:not_auto_mult=>true)
    chm_advisory_board.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更委员会',:description=>'查看,添加,编辑变更委员会')
    chm_advisory_board.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Approve Board',:description=>'Mangage Change Approve Board')
    chm_advisory_board.save

    chm_advisory_board= Irm::Function.new(:function_group_code=>'ADVISORY_BOARD',:code=>'ADVISORY_BOARD',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_advisory_board.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更委员会',:description=>'管理变更委员会,变理委员会成员')
    chm_advisory_board.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Advisory Board',:description=>'Manage Advisory Board')
    chm_advisory_board.save
    chm_change_approve= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'CHANGE_APPROVE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_approve.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更审批',:description=>'查看变更的审批记录')
    chm_change_approve.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Approve History',:description=>'Change Approve History')
    chm_change_approve.save
    chm_approve_change= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'APPROVE_CHANGE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_approve_change.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批变更请求',:description=>'审批提交上来的变更请求')
    chm_approve_change.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approve Change Request',:description=>'Approve Change Request')
    chm_approve_change.save
    chm_perform_change_task= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'PERFORM_CHANGE_TASK',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_perform_change_task.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'更新变理任务',:description=>'更新分配到个人的变更任务')
    chm_perform_change_task.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Perform Change Task',:description=>'Perform Change Task')
    chm_perform_change_task.save

    menu_entiry_113= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ADVISORY_BOARD',:display_sequence=>80)
    menu_entiry_113.save

    change_approve_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'CHANGE_APPROVE_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_approve_status.lookup_types_tls.build(:lookup_type_id=>change_approve_status.id,:meaning=>'变更审批状态',:description=>'变更审批状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_status.lookup_types_tls.build(:lookup_type_id=>change_approve_status.id,:meaning=>'Change Approve Status',:description=>'Change Approve Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_status.save

    change_approve_statusassigned= Irm::LookupValue.new(:lookup_type=>'CHANGE_APPROVE_STATUS',:lookup_code=>'ASSIGNED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_approve_statusassigned.lookup_values_tls.build(:lookup_value_id=>change_approve_statusassigned.id,:meaning=>'已分配',:description=>'已分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusassigned.lookup_values_tls.build(:lookup_value_id=>change_approve_statusassigned.id,:meaning=>'Assigned',:description=>'Assigned',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusassigned.save
    change_approve_statusapproving= Irm::LookupValue.new(:lookup_type=>'CHANGE_APPROVE_STATUS',:lookup_code=>'APPROVING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_approve_statusapproving.lookup_values_tls.build(:lookup_value_id=>change_approve_statusapproving.id,:meaning=>'审批中',:description=>'审批中',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusapproving.lookup_values_tls.build(:lookup_value_id=>change_approve_statusapproving.id,:meaning=>'Approving',:description=>'Approving',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusapproving.save
    change_approve_statusapproved= Irm::LookupValue.new(:lookup_type=>'CHANGE_APPROVE_STATUS',:lookup_code=>'APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_approve_statusapproved.lookup_values_tls.build(:lookup_value_id=>change_approve_statusapproved.id,:meaning=>'审批通过',:description=>'审批通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusapproved.lookup_values_tls.build(:lookup_value_id=>change_approve_statusapproved.id,:meaning=>'Approved',:description=>'Approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusapproved.save
    change_approve_statusreject= Irm::LookupValue.new(:lookup_type=>'CHANGE_APPROVE_STATUS',:lookup_code=>'REJECT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_approve_statusreject.lookup_values_tls.build(:lookup_value_id=>change_approve_statusreject.id,:meaning=>'审批拒绝',:description=>'审批拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusreject.lookup_values_tls.build(:lookup_value_id=>change_approve_statusreject.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_approve_statusreject.save
  end

  def down
  end
end
