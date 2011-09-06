# -*- coding: utf-8 -*-
class ReworkLaneData < ActiveRecord::Migration
  def self.up
    Irm::Lane.where("1=1").each do |t|
      t.destroy
    end

    irm_lane_1 = Irm::Lane.new(:lane_code => "IR_WAITING_MY_REPLY",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_1.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我回复',:description=>'等待我回复(客户)')
    irm_lane_1.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my reply',:description=>'Waiting my reply(Customer)')
    irm_lane_1.save

    irm_lane_2 = Irm::Lane.new(:lane_code => "IR_WAITING_MY_SOLUTION",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_2.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我解决',:description=>'等待我解决(服务台)')
    irm_lane_2.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my solution',:description=>'Waiting my solution(Help desk)')
    irm_lane_2.save

    irm_lane_3 = Irm::Lane.new(:lane_code => "IR_WAITING_HELPDESK_REPLY",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_3.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待服务台回复',:description=>'等待服务台回复(用户)')
    irm_lane_3.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting help desk reply',:description=>'Waiting help desk reply(Customer)')
    irm_lane_3.save

    irm_lane_4 = Irm::Lane.new(:lane_code => "IR_WAITING_CUSTOMER_REPLY",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_4.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待客户回复',:description=>'等待客户回复(服务台)')
    irm_lane_4.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting customer reply',:description=>'Waiting customer reply(Help desk)')
    irm_lane_4.save

    irm_lane_5 = Irm::Lane.new(:lane_code => "IR_MY_ALL",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_5.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我所有的事故单',:description=>'我所有的事故单')
    irm_lane_5.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my requests',:description=>'All my requests')
    irm_lane_5.save

    irm_lane_6 = Irm::Lane.new(:lane_code => "IR_MY_RELATION",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_6.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'与我相关的',:description=>'与我相关的')
    irm_lane_6.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my relations',:description=>'All my relations')
    irm_lane_6.save
  end

  def self.down
  end
end
