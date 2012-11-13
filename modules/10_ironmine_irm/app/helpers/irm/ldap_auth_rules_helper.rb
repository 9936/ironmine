module Irm::LdapAuthRulesHelper
  def filter_operators
    operators = Irm::LookupValue.query_by_lookup_type("RULE_FILTER_OPERATOR").with_eql_or_not.multilingual.order_id
    operators.collect{|o| [o[:meaning],o[:lookup_code]]}.compact
  end
end
