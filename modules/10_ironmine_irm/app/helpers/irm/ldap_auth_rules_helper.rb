module Irm::LdapAuthRulesHelper
  def filter_operators
    [[t(:label_equal), 'E'], [t(:label_unequal), 'N'],[t(:label_include), 'I']]
  end

  def get_operator_meaning(operator)
    case operator
      when 'E'
        t(:label_equal)
      when 'N'
        t(:label_unequal)
      when 'I'
        t(:label_include)
    end
  end

end
