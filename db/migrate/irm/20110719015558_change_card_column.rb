class ChangeCardColumn < ActiveRecord::Migration
  def self.up
    execute("DROP VIEW irm_cards_vl")
    remove_column :irm_cards, :title_attribute_id
    remove_column :irm_cards, :description_attribute_id
    remove_column :irm_cards, :date_attribute_id

    add_column :irm_cards, :date_attribute_name, :string, :limit => 30, :after => :card_url
    add_column :irm_cards, :description_attribute_name, :string, :limit => 30, :after => :card_url
    add_column :irm_cards, :title_attribute_name, :string, :limit => 30, :after => :card_url

    execute('CREATE OR REPLACE VIEW irm_cards_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_cards  t,irm_cards_tl tl
                                           WHERE t.id = tl.card_id')
  end

  def self.down
    execute("DROP VIEW irm_cards_vl")
    remove_column :irm_cards, :title_attribute_name
    remove_column :irm_cards, :description_attribute_name
    remove_column :irm_cards, :date_attribute_name

    add_column :irm_cards, :date_attribute_id, :integer, :after => :card_url
    add_column :irm_cards, :description_attribute_id, :integer, :after => :card_url
    add_column :irm_cards, :title_attribute_id, :integer, :after => :card_url
    execute('CREATE OR REPLACE VIEW irm_cards_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_cards  t,irm_cards_tl tl
                                           WHERE t.id = tl.card_id')
  end
end
