module Irm::RatingConfigsHelper
  def display_rating_config_grade(rating_config)
    rating_config.rating_config_grades.collect{|i| i.name if i.name.present?}.compact.join(",")
  end
end
