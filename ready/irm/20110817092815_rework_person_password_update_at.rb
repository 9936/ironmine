class ReworkPersonPasswordUpdateAt < ActiveRecord::Migration
  def self.up
    Irm::Person.all.each  do |p|
      p.update_attribute(:password_updated_at,p.created_at)
    end
  end

  def self.down
  end
end
