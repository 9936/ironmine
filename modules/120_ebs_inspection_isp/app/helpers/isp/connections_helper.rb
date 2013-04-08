module Isp::ConnectionsHelper
  def available_connection_types
    [["Shell", "SHELL"],["SQL", "SQL"]]
  end

  def connection_type_meaning(type)
    case type
      when "SHELL"
        return "Shell"
      when "SQL"
        return "SQL"
      else
        ""
    end
  end
end
