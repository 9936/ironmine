require 'yajl'
class Dmt::DataTransform
  include Singleton

  def download(source,file_path=nil)
    need_download = source.dup
    downloaded = {}
    data = []
    while need_download.length>0
      return_values = entity(need_download[0][:type],need_download[0][:condition],downloaded)
      if(return_values)
        puts "get data.........."
        return_values[0].each do |key,value|
          if downloaded[key]
            downloaded[key] << value unless downloaded[key].include?(value)
          else
            downloaded[key] = [value]
          end
        end
        data << return_values[1]
        need_download += return_values[2]
      else
        puts "not get data.........."
      end
      need_download.delete_at(0)
    end
    return data
  end

  def upload(file_path)
    json_file = File.new(file_path, 'r')
    parser = Yajl::Parser.new
    datas = parser.parse(json_file)

  end

  private
  def entity(type,condition,downloaded)
    puts "downloading........#{type}.....#{condition}....."
    # 取得当前下载的数据
    data = type.constantize.unscoped.where(condition).first
    return nil unless data

    # 是否已经下载过这个数据
    if(downloaded[type]&&downloaded[type].include?(data.id))
      puts "already get data before"
      return nil
    end

    # 数据定义
    entity = Irm::DataStructDefine.entities[type]

    # 导出的数据hash
    data_hash = {:origin_type=>type}

    # 需要关联下载的下载项
    need_download = []
    if entity
      # 对数据列进行处理
      entity[:columns].values.each do |column|
        value = nil
        # 取得当前列的值
        if data.respond_to?(column[:name].to_sym)
          value = data.send(column[:name].to_sym)
          if(value.is_a? Time||value.is_a?(DateTime))
            value = value.strftime('%Y-%m-%d %H:%M:%S')
          elsif value.is_a? Date
            value = value.to_formatted_s(:db)
          end
          data_hash.merge!(column[:name].to_sym=>value)
        end

        # 如果当前列是关联列，将关联的数据加入下载列表中
        if value.present?&&entity[:reference_columns].include?(column[:name])
          if column[:ref_condition]&&column[:ref_condition].is_a?(Hash)
            ref_condition = column[:ref_condition].dup
            ref_condition.each do |key,sym_value|
              if sym_value.eql?(:value)
                ref_condition[key]=value
              end
            end
            need_download << {:type=>column[:ref_entity],:condition=>ref_condition}
          else
            need_download << {:type=>column[:ref_entity],:condition=>{:id=>value}}
          end
        end
      end

      # 下载依赖的数据
      dependents = Irm::DataStructDefine.dependents[type]
      if dependents.present?&&dependents.any?
        dependents.each do |dep_entity_name|
          # 取得依赖的实体
          dep_entity = Irm::DataStructDefine.entities[dep_entity_name]
          if dep_entity
            # 取得关联列数据列
            dependent_columns = dep_entity[:columns].values.collect{|c| c if type.eql?(c[:ref_entity]) }.compact
            next unless dependent_columns.any?
            # 对每个关联列数据单独下载
            dependent_columns.each do |dependent_column|
              ref_field = :id
              if dependent_column[:ref_condition]
                dependent_column[:ref_condition].each do |key,value|
                  if value.eql?(:value)
                    ref_field = key
                    break
                  end
                end
              end

              dependent_download_data = dep_entity_name.constantize.where(dependent_column[:name].to_sym => data.send(ref_field))

              dependent_download_data.each do |data|
                need_download << {:type=>dep_entity_name,:condition=>{:id=>data.id}}
              end
            end
          end
        end
      end

      return [{type=>data_hash[:id]},data_hash,need_download]
    else
      puts "Waring no Entity : #{type} "
      return nil
    end

  end
end