# -*- coding: utf-8 -*-
class AddSystemCardData < ActiveRecord::Migration
  def self.up
    irm_card_1 = Irm::Card.new(:card_code => "IR_CUSTOMER_REPLIED",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "ir_updated_at",
                               :status_code => Irm::Constant::ENABLED)
    irm_card_1.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'客户回复后的事故单',:description=>'客户回复后的事故单')
    irm_card_1.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Customer Replied',:description=>'Customer Replied')
    irm_card_1.save

    irm_card_2 = Irm::Card.new(:card_code => "IR_ARR_WAITING_FOR_REPLY",
                               :background_color => "#b3eae4",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED)
    irm_card_2.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新到达的事故单',:description=>'新到达的事故单')
    irm_card_2.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'New IR',:description=>'New IR')
    irm_card_2.save
  end

  def self.down
  end
end
