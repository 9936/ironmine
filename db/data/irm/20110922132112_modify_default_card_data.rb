# -*- coding: utf-8 -*-
class ModifyDefaultCardData < ActiveRecord::Migration
  def up
    card = Irm::Card.where(:card_code => "IR_MY_ALL")
    card.each do |c|
      cv = Irm::CardsTl.where(:card_id => c.id)
      cv.each do |v|
        if v.language == "zh"
          v.update_attribute(:name, "我提交的")
          v.update_attribute(:description, "我提交的")
        else
          v.update_attribute(:name, "My Submitted")
          v.update_attribute(:description, "My Submitted")
        end
      end
      c.update_attribute(:card_code, "IR_MY_SUBMIT")
    end

    lane = Irm::Lane.where(:lane_code => "IR_MY_ALL")
    lane.each do |c|
      cv = Irm::LanesTl.where(:lane_id => c.id)
      cv.each do |v|
        if v.language == "zh"
          v.update_attribute(:name, "我提交的")
          v.update_attribute(:description, "我提交的")
        else
          v.update_attribute(:name, "My Submitted")
          v.update_attribute(:description, "My Submitted")
        end
      end
      c.update_attribute(:lane_code, "IR_MY_SUBMIT")
    end
  end

  def down
  end
end
