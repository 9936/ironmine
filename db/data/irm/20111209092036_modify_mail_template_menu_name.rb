# -*- coding: utf-8 -*-
class ModifyMailTemplateMenuName < ActiveRecord::Migration
  def up
    execute("UPDATE irm_function_groups_tl ift SET ift.name = '通知模板', ift.description = '创建或编辑电子邮件通知模板' WHERE ift.function_group_id IN (SELECT ifg.id FROM irm_function_groups ifg WHERE ifg.code = 'MAIL_TEMPLATE') AND ift.language = 'zh'")
    execute("UPDATE irm_function_groups_tl ift SET ift.name = 'Email Template', ift.description = 'Email Template' WHERE ift.function_group_id IN (SELECT ifg.id FROM irm_function_groups ifg WHERE ifg.code = 'MAIL_TEMPLATE') AND ift.language = 'en'")
    execute("UPDATE irm_menu_entries_tl imt SET imt.name = '通知模板', imt.description = '创建或编辑电子邮件通知模板' WHERE imt.menu_entry_id IN (SELECT ime.id FROM irm_menu_entries ime, irm_function_groups ifg WHERE ime.sub_function_group_id = ifg.id AND ifg.code = 'MAIL_TEMPLATE') AND  imt.language = 'zh'")
    execute("UPDATE irm_menu_entries_tl imt SET imt.name = 'Email Template', imt.description = 'Email Template' WHERE imt.menu_entry_id IN (SELECT ime.id FROM irm_menu_entries ime, irm_function_groups ifg WHERE ime.sub_function_group_id = ifg.id AND ifg.code = 'MAIL_TEMPLATE') AND  imt.language = 'en'")
  end

  def down
  end
end
