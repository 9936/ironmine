module Fwk

  module MysqlSchemaDumper #:nodoc:
    def self.included(base)
      base.class_eval do
        def tables(stream)
          table_and_views = @connection.execute("SHOW FULL TABLES")
          table_and_views.sort { |a, b| "#{a[1]}#{a[0]}"<=>"#{b[1]}#{b[0]}" }.each do |tbl|
            next if ['schema_migrations', ignore_tables].flatten.any? do |ignored|
              case ignored
                when String;
                  tbl[0] == ignored
                when Regexp;
                  tbl[0] =~ ignored
                else
                  raise StandardError, 'ActiveRecord::SchemaDumper.ignore_tables accepts an array of String and / or Regexp values.'
              end
            end
            if tbl[0].length>30
              puts "to long for oracle #{tbl[0]}"
            end
            if tbl[1].include?("VIEW")
              view(tbl[0], stream)
            else
              table(tbl[0], stream)
            end
          end
        end

        def view(view, stream)
          begin
            script = @connection.execute("show create view #{view}").first[1]
            script = script.gsub("`", "").gsub(/create.*view(.*)as\sselect/i, 'CREATE OR REPLACE VIEW \1 AS SELECT ').gsub(/([^\s]+\.)([^\s]+)\sas\s([^\s,]+)(,?)/i) do
              if $2==$3
                "#{$1}#{$2}#{$4}"
              else
                "#{$1}#{$2} as #{$3} #{$4}"
              end
            end
            script = script.gsub(/from\s\(([^\s]*\st\sjoin\s[^\s]*\stl)\)\swhere\s\((t\.id\s=\stl\.[^\s\)]*)\)/) do
              "from #{$1} on #{$2}"
            end
            script = %Q{  execute("#{script}")}
            stream.print script
            stream.puts
          rescue => e
            stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
            stream.puts "#   #{e.message}"
            stream.puts
          end

          stream
        end


        def table(table, stream)
          columns = @connection.columns(table)
          begin
            tbl = StringIO.new

            # first dump primary key column
            if @connection.respond_to?(:pk_and_sequence_for)
              pk, _ = @connection.pk_and_sequence_for(table)
            elsif @connection.respond_to?(:primary_key)
              pk = @connection.primary_key(table)
            end

            tbl.print "  create_table #{table.inspect}"
            if columns.detect { |c| c.name == pk }
              if pk != 'id'
                tbl.print %Q(, :primary_key => "#{pk}")
              end
            else
              tbl.print ", :id => false"
            end
            tbl.print ", :force => true"
            tbl.puts " do |t|"

            # then dump all non-primary key columns
            column_specs = columns.map do |column|
              raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" if @types[column.type].nil?
              next if column.name == pk
              spec = {}
              spec[:name] = column.name.inspect
              if column.name.length>30
                puts %Q(rename_column "#{table}", #{column.name.inspect}, #{column.name.length}#{column.name.inspect})
              end

              # AR has an optimisation which handles zero-scale decimals as integers.  This
              # code ensures that the dumper still dumps the column as a decimal.
              spec[:type] = if column.type == :integer && [/^numeric/, /^decimal/].any? { |e| e.match(column.sql_type) }
                              'decimal'
                            else
                              column.type.to_s
                            end
              spec[:limit] = column.limit.inspect if column.limit != @types[column.type][:limit] && spec[:type] != 'decimal'
              spec[:precision] = column.precision.inspect if column.precision
              spec[:scale] = column.scale.inspect if column.scale
              spec[:null] = 'false' unless column.null
              spec[:default] = default_string(column.default) if column.has_default?
              real_name = spec[:name].gsub("\"", "")
              if (real_name.end_with?("_id")||real_name.end_with?("_by")||real_name=="id")&&spec[:limit].present?&&spec[:limit].to_i==22
                spec[:collate] = %Q{"utf8_bin"}
              end

              (spec.keys - [:name, :type]).each { |k| spec[k].insert(0, "#{k.inspect} => ") }
              spec
            end.compact

            # find all migration keys used in this table
            keys = [:name, :limit, :precision, :scale, :default, :null, :collate] & column_specs.map { |k| k.keys }.flatten

            # figure out the lengths for each column based on above keys
            lengths = keys.map { |key| column_specs.map { |spec| spec[key] ? spec[key].length + 2 : 0 }.max }

            # the string we're going to sprintf our values against, with standardized column widths
            format_string = lengths.map { |len| "%-#{len}s" }

            # find the max length for the 'type' column, which is special
            type_length = column_specs.map { |column| column[:type].length }.max

            # add column type definition to our format string
            format_string.unshift "    t.%-#{type_length}s "

            format_string *= ''

            column_specs.each do |colspec|
              values = keys.zip(lengths).map { |key, len| colspec.key?(key) ? colspec[key] + ", " : " " * len }
              values.unshift colspec[:type]
              tbl.print((format_string % values).gsub(/,\s*$/, ''))
              tbl.puts
            end

            tbl.puts "  end"
            tbl.puts

            if columns.detect { |c| c.name == pk }&&!["irm_machine_codes", "irm_object_codes"].include?(table)
              tbl.puts %Q(  change_column :#{table}, "#{pk}", :string,:limit=>22, :collate=>"utf8_bin")
            end

            indexes(table, tbl)
            tbl.puts
            tbl.rewind
            stream.print tbl.read
          rescue => e
            stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
            stream.puts "#   #{e.message}"
            stream.puts
          end

          stream
        end

        def indexes(table, stream)
          if (indexes = @connection.indexes(table)).any?
            add_index_statements = indexes.map do |index|
              statement_parts = [
                  ('add_index ' + index.table.inspect),
                  index.columns.inspect,
                  (':name => ' + index.name.inspect),
              ]

              if index.name.length>30
                puts %Q(rename_index "#{table}", #{index.name.inspect}, #{index.name.inspect.length-2}#{index.name.inspect})
              end

              statement_parts << ':unique => true' if index.unique

              index_lengths = (index.lengths || []).compact
              statement_parts << (':length => ' + Hash[index.columns.zip(index.lengths)].inspect) unless index_lengths.empty?

              '  ' + statement_parts.join(', ')
            end

            stream.puts add_index_statements.sort.join("\n")
            stream.puts
          end
        end

      end
    end
  end
end






