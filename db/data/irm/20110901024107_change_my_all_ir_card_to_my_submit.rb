# -*- coding: utf-8 -*-
class ChangeMyAllIrCardToMySubmit < ActiveRecord::Migration
  def self.up
    Irm::Lane.where("lane_code=?", "IR_MY_ALL").each  do |t|
      t.lanes_tls.each do |l|
        l.update_attributes(:name => "我提交的", :description => "我提交的") if l.language == "zh"
        l.update_attributes(:name => "All my submit", :description => "All my submit") if l.language == "en"
      end

      t.update_attribute(:lane_code, "IR_MY_SUBMIT")
    end

    Irm::Card.where("card_code=?", "IR_MY_ALL").each  do |t|
      t.cards_tls.each do |l|
        l.update_attributes(:name => "我提交的", :description => "我提交的") if l.language == "zh"
        l.update_attributes(:name => "All my submit", :description => "All my submit") if l.language == "en"
      end

      t.update_attribute(:card_code, "IR_MY_SUBMIT")
    end
  end

  def self.down
  end
end
