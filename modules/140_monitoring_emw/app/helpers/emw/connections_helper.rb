module Emw::ConnectionsHelper
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

  def available_sql_conns
    Emw::Connection.sql_conns.collect{|i|[i[:name], i.id]}
  end

  def available_shell_conns
    Emw::Connection.shell_conns.collect{|i|[i[:name], i.id]}
  end
end
