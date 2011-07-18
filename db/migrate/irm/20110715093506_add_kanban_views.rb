class AddKanbanViews < ActiveRecord::Migration
  def self.up
    add_index "irm_kanbans", "kanban_code",:unique=>true, :name => "IRM_KANBAN_TYPE_U1"
    add_index "irm_kanbans_tl", ["kanban_id", "language"],:unique=>true, :name => "IRM_KANBANS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_kanbans_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_kanbans  t,irm_kanbans_tl tl
                                           WHERE t.id = tl.kanban_id')


    add_index "irm_lanes", "lane_code",:unique=>true, :name => "IRM_LANE_TYPE_U1"
    add_index "irm_lanes_tl", ["lane_id", "language"],:unique=>true, :name => "IRM_LANES_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_lanes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_lanes  t,irm_lanes_tl tl
                                           WHERE t.id = tl.lane_id')


    add_index "irm_cards", "card_code",:unique=>true, :name => "IRM_CARD_TYPE_U1"
    add_index "irm_cards_tl", ["card_id", "language"],:unique=>true, :name => "IRM_CARDS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_cards_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_cards  t,irm_cards_tl tl
                                           WHERE t.id = tl.card_id')
  end

  def self.down
    execute('DROP VIEW irm_kanbans_vl')
    execute('DROP VIEW irm_lanes_vl')
    execute('DROP VIEW irm_cards_vl')
  end
end
