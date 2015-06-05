# -*- coding: utf-8 -*-
class IcmRating < ActiveRecord::Migration
  def change
    Irm::Person.current = Irm::Person.where(:login_name => "ironmine").first
    rating_config = Irm::RatingConfig.new(:code => "ICM_RATING", :name => "事故单评价", :description => "事故单评价")
    (1..3).each do |index|
      rating_config.rating_config_grades.build(:grade => index)
    end
    rating_config.rating_config_grades.build(:grade => 4, :name => "改善", :description => "改善")
    rating_config.rating_config_grades.build(:grade => 5, :name => "普通", :description => "普通")
    rating_config.rating_config_grades.build(:grade => 6, :name => "满足", :description => "满足")
    rating_config.rating_config_grades.build(:grade => 7, :name => "非常", :description => "非常")
    (8..10).each do |index|
      rating_config.rating_config_grades.build(:grade => index)
    end
    rating_config.save
  end
end
