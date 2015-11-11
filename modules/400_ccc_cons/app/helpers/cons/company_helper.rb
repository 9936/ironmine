module Cons::CompanyHelper
  def available_industry
    Cons::Industry.where("status = ? ","ENABLED").collect{|i|[i[:name],i.id]}
  end

  def available_connect
    Cons::Connect.where("status = ? ","ENABLED").collect{|i|[i[:name],i.id]}
  end

end
