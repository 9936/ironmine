# -*- coding: utf-8 -*-
class ReworkCardData < ActiveRecord::Migration
  def self.up
    Irm::Card.where("1=1").each do |t|
      t.destroy
    end

    irm_card_1 = Irm::Card.new(:card_code => "IR_WAITING_MY_REPLY",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_1.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我回复',:description=>'等待我回复(客户)')
    irm_card_1.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my reply',:description=>'Waiting my reply(Customer)')
    irm_card_1.save

    irm_card_2 = Irm::Card.new(:card_code => "IR_WAITING_MY_SOLUTION",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_2.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我解决',:description=>'等待我解决(服务台)')
    irm_card_2.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my solution',:description=>'Waiting my solution(Help desk)')
    irm_card_2.save

    irm_card_3 = Irm::Card.new(:card_code => "IR_WAITING_HELPDESK_REPLY",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_3.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待服务台回复',:description=>'等待服务台回复(用户)')
    irm_card_3.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting help desk reply',:description=>'Waiting help desk reply(Customer)')
    irm_card_3.save

    irm_card_4 = Irm::Card.new(:card_code => "IR_WAITING_CUSTOMER_REPLY",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_4.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待客户回复',:description=>'等待客户回复(服务台)')
    irm_card_4.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting customer reply',:description=>'Waiting customer reply(Help desk)')
    irm_card_4.save

    irm_card_5 = Irm::Card.new(:card_code => "IR_MY_ALL",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_5.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我所有的事故单',:description=>'我所有的事故单')
    irm_card_5.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my requests',:description=>'All my requests')
    irm_card_5.save

    irm_card_6 = Irm::Card.new(:card_code => "IR_MY_RELATION",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_6.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'与我相关的',:description=>'与我相关的')
    irm_card_6.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my relations',:description=>'All my relations')
    irm_card_6.save
  end

  def self.down
  end
end
