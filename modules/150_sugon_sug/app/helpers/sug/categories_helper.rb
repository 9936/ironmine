module Sug::CategoriesHelper
  def category_level_meaning(level)
    case level
      when 0
        return t(:label_sug_category_zero)
      when 1
        return t(:label_sug_category_one)
      when 2
        return t(:label_sug_category_two)
      when 3
        return t(:label_sug_category_three)
      else
        return t(:label_sug_category)
    end
  end

  #获取指定code三级类型
  def first_level_category(code)
    Sug::Category.query_by_code(code).collect{|i|[i.id, i.name]}
  end
end
