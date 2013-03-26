class Irm::MonitorProcessController < ApplicationController
  def index

  end


  def process_data
    #获取当前delayed_job的启动个数
    pid_dir = "#{Rails.root}/tmp/pids"
    log_name_reg = /delayed_job\.(\d\.)?pid/

    scheduler_reg = /ironmine_scheduler\.(\d\.)?pid/

    delayed_job_num = 0
    scheduler_job_num = 0

    Dir.entries(pid_dir).each do |entry|
      if entry.match(log_name_reg)
        #判断当前的pid是否有效
        if running?("#{pid_dir}/#{entry}")
          delayed_job_num += 1
        end
      elsif entry.match(scheduler_reg) && running?("#{pid_dir}/#{entry}")
        scheduler_job_num += 1
      end
    end
    @processes = []
    @processes << {:id => "delayed_job", :name => "Delayed Job",  :num => delayed_job_num}
    @processes << {:id => "scheduler", :name => "Scheduler",  :num => scheduler_job_num}

    solr_num = 0
    solr_pid_file = "#{Rails.root}/solr/pids/#{Rails.env}/sunspot-solr-#{Rails.env}.pid"
    if running?(solr_pid_file)
      solr_num = 1
    end


    @processes << {:id => "solr", :name => "Solr", :num => solr_num}
  end

  def start_process
    if params[:id].eql?("delayed_job")
      cmd = "cd #{Rails.root} && RAILS_ENV=#{Rails.env} && script/delayed_job start"
      if params[:process_num] && params[:process_num].to_i > 1
        cmd += " -n #{params[:process_num].to_i}"
      end
    elsif params[:id].eql?("scheduler")
      cmd = "cd #{Rails.root} && RAILS_ENV=#{Rails.env} && script/scheduler start"
    elsif params[:id].eql?("solr")
      cmd = "cd #{Rails.root} && RAILS_ENV=#{Rails.env} && rake sunspot:solr:start"
    else
      cmd = ""
    end
    Dir.chdir("#{Rails.root}"){
      %x[#{cmd}]
    }
  end


  def stop_process
    if params[:id].eql?("delayed_job")
      cmd = "cd #{Rails.root} && RAILS_ENV=#{Rails.env} && script/delayed_job stop"
    elsif params[:id].eql?("scheduler")
      cmd = "cd #{Rails.root} && RAILS_ENV=#{Rails.env} && script/scheduler stop"
    elsif params[:id].eql?("solr")
      cmd = "cd #{Rails.root} && RAILS_ENV=#{Rails.env} && rake sunspot:solr:stop"
    else
      cmd = ""
    end
    Dir.chdir("#{Rails.root}"){
      %x[#{cmd}]
    }
  end



  private
    def running?(pid_file)
      begin
        pid = IO.read(pid_file).to_i
        pid > 0 && Process.getpgid(pid) && true
      rescue
        false
      end
    end
end
