module Cons::ProductHelper
  def available_projectType
    Cons::ProjectType.where("status = ? ","ENABLED").collect{|i|[i[:name],i.id]}
  end

  def available_price
    Cons::Price.where("status = ? ","ENABLED").collect{|i|[i[:name],i.id]}
  end

  # def available_group
  #   Cons::Group.where("status = ? ","ENABLED").collect{|i|[i[:name],i.id]}
  # end

end
