#Sunspot::Rails::Configuration.class_eval do
#  def solr_home
#    File.expand_path(File.join(Rails.root, "solr","solr"))
#  end
#end

#Sunspot::Server.class_eval do
# def run
#    command = ['java']
#    command << "-Xms#{min_memory}" if min_memory
#    command << "-Xmx#{max_memory}" if max_memory
#    command << "-Djetty.port=#{port}" if port
#    command << "-Dsolr.data.dir=#{solr_data_dir}" if solr_data_dir
#    command << "-Dsolr.solr.home=#{solr_home}" if solr_home
#    command << "-Djava.util.logging.config.file=#{logging_config_path}" if logging_config_path
#    command << '-jar' << File.basename(solr_jar)
#    FileUtils.cd("#{Rails.root}/solr/") do
#      exec(Escape.shell_command(command))
#    end
#  end
#end