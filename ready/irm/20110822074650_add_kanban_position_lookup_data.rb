# -*- coding: utf-8 -*-
class AddKanbanPositionLookupData < ActiveRecord::Migration
  def self.up
    irm_kanban_position=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_KANBAN_POSITION',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_kanban_position.lookup_types_tls.build(:lookup_type_id=>irm_kanban_position.id,:meaning=>'看板位置',:description=>'看板位置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_position.lookup_types_tls.build(:lookup_type_id=>irm_kanban_position.id,:meaning=>'Kanban Position',:description=>'Kanban Position',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_position.save

    irm_kanban_positionhome_page= Irm::LookupValue.new(:lookup_type=>'IRM_KANBAN_POSITION',:lookup_code=>'HOME_PAGE',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_kanban_positionhome_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionhome_page.id,:meaning=>'首页',:description=>'首页',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionhome_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionhome_page.id,:meaning=>'Home Page',:description=>'Home Page',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionhome_page.save

    irm_kanban_positionincident_request_page= Irm::LookupValue.new(:lookup_type=>'IRM_KANBAN_POSITION',:lookup_code=>'INCIDENT_REQUEST_PAGE',:start_date_active=>'1900-01-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_kanban_positionincident_request_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionincident_request_page.id,:meaning=>'事故单首页',:description=>'事故单首页',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionincident_request_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionincident_request_page.id,:meaning=>'Incident Request Home',:description=>'Incident Request Home',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionincident_request_page.save
  end

  def self.down
  end
end
