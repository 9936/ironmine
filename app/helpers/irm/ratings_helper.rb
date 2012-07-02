module Irm::RatingsHelper
  def show_rating(bo,options=[])
    return unless options.any?
    result = []
    if bo.is_a?(Hash)
      result = Irm::Rating.group_by_object_grade(bo[:class_name],bo[:id])
    else
      result = Irm::Rating.group_by_object_grade(bo.class.name,bo.id)
    end

    options.each do |o|
      current_result = result.detect{|i| i[:grade].eql?(o[:grade])}
      if current_result
        o[:rating_num] = current_result[:rating_num]
      else
        o[:rating_num] = 0
      end
    end

    render :partial=>"irm/ratings/show",:locals=>{:bo=>bo,:datas=>options,:rating=>!Irm::Rating.exists?(:person_id=>Irm::Person.current.id,:bo_name=>bo.class.name,:rating_object_id=>bo.id)}

  end


end
