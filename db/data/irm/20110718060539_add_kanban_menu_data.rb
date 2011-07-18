# -*- coding: utf-8 -*-
class AddKanbanMenuData < ActiveRecord::Migration
  def self.up
    irm_kanban_management= Irm::Menu.new(:menu_code=>'KANBAN_MANAGEMENT',:leaf_flag=>'N',:not_auto_mult=>true)
    irm_kanban_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板管理',:description=>'看板管理菜单')
    irm_kanban_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Kanban Management',:description=>'Kanban Management')
    irm_kanban_management.save
    irm_kanban= Irm::Menu.new(:menu_code=>'KANBAN',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_kanban.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板',:description=>'看板')
    irm_kanban.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Kanban',:description=>'Kanban')
    irm_kanban.save
    irm_lane= Irm::Menu.new(:menu_code=>'LANE',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_lane.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'泳道',:description=>'泳道')
    irm_lane.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Lane',:description=>'Lane')
    irm_lane.save
    irm_card= Irm::Menu.new(:menu_code=>'CARD',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_card.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'卡片',:description=>'卡片')
    irm_card.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Card',:description=>'Card')
    irm_card.save

    irm_menu_entiry_139= Irm::MenuEntry.new(:menu_code=>'ADMIN_SETUP',:sub_menu_code=>'KANBAN_MANAGEMENT',:page_controller=>nil,:display_sequence=>120,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_139.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板设置',:description=>'看板设置 ')
    irm_menu_entiry_139.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Kanban Management',:description=>'Kanban Management')
    irm_menu_entiry_139.save
    irm_menu_entiry_140= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>'KANBAN',:page_controller=>nil,:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_140.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板',:description=>'看板')
    irm_menu_entiry_140.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Kanban',:description=>'kanban')
    irm_menu_entiry_140.save
    irm_menu_entiry_141= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>'LANE',:page_controller=>nil,:display_sequence=>20,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_141.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'泳道',:description=>'泳道')
    irm_menu_entiry_141.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Lane',:description=>'Lane')
    irm_menu_entiry_141.save
    irm_menu_entiry_142= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>'CARD',:page_controller=>nil,:display_sequence=>30,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_142.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'卡片',:description=>'卡片')
    irm_menu_entiry_142.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Card',:description=>'Card')
    irm_menu_entiry_142.save
    irm_menu_entiry_143= Irm::MenuEntry.new(:menu_code=>'KANBAN',:sub_menu_code=>nil,:page_controller=>'irm/kanbans',:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_143.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板',:description=>'看板')
    irm_menu_entiry_143.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Kanban',:description=>'kanban')
    irm_menu_entiry_143.save
    irm_menu_entiry_144= Irm::MenuEntry.new(:menu_code=>'LANE',:sub_menu_code=>nil,:page_controller=>'irm/lanes',:display_sequence=>20,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_144.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'泳道',:description=>'泳道')
    irm_menu_entiry_144.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Lane',:description=>'Lane')
    irm_menu_entiry_144.save
    irm_menu_entiry_145= Irm::MenuEntry.new(:menu_code=>'CARD',:sub_menu_code=>nil,:page_controller=>'irm/cards',:display_sequence=>30,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_145.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'卡片',:description=>'卡片')
    irm_menu_entiry_145.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Card',:description=>'Card')
    irm_menu_entiry_145.save
  end

  def self.down
  end
end
