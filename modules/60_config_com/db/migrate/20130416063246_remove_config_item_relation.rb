class RemoveConfigItemRelation < ActiveRecord::Migration
  def change
    Com::ConfigItemRelation.all.map(&:destroy)
  end
end
