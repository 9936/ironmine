module Isp::CheckItemsHelper
  def available_connections(program_id)
    Isp::Connection.with_program(program_id).collect{|i|[i.name, i.id]}
  end
end
