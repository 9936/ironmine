module Irm::RatingsHelper
  def show_rating(rating_config_code,bo,dom_id="diggZone")
    result = []
    bo_hash = {}
    grades = Irm::RatingConfigGrade.by_config_code(rating_config_code).order("grade desc")
    if bo.is_a?(Hash)
      result = Irm::Rating.group_by_object_grade(bo[:class_name],bo[:id])
      bo_hash = bo
    else
      result = Irm::Rating.group_by_object_grade(bo.class.name,bo.id)
      bo_hash = {:class_name=>bo.class.name,:id=>bo.id}
    end


    grades =  grades.collect{|i| i if i.name.present?}.compact
    grades.each do |o|
      current_result = result.detect{|i| i[:grade].to_s.eql?(o.grade.to_s)}
      if current_result
        o.rating_num = current_result[:rating_num]
      else
        o.rating_num = 0
      end
    end

    render :partial=>"irm/ratings/show",:locals=>{:datas=>grades,:rating=>!Irm::Rating.exists?(:person_id=>Irm::Person.current.id,:bo_name=>bo_hash[:class_name],:rating_object_id=>bo[:id]),:bo_name=>bo_hash[:class_name],:code=>rating_config_code,:rating_object_id=>bo[:id],:dom_id=>dom_id}

  end


end
