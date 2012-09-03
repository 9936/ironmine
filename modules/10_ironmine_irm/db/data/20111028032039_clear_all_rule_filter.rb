class ClearAllRuleFilter < ActiveRecord::Migration
  def up
    execute('UPDATE irm_rule_filter_criterions SET attribute_name = NULL,operator_code=NULL,filter_value=NULL')
  end

  def down
  end
end
