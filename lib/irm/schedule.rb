require 'rubygems'
require 'daemons'
require 'optparse'
require 'rufus/scheduler'

module Irm
  class Schedule

    def initialize(args)
      @files_to_reopen = []
      @options = {
        :quiet => true,
        :pid_dir => "#{Rails.root}/tmp/pids"
      }


      opts = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] start|stop|restart|run"

        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit 1
        end
        opts.on('-e', '--environment=NAME', 'Specifies the environment to run this delayed jobs under (test/development/production).') do |e|
          STDERR.puts "The -e/--environment option has been deprecated and has no effect. Use RAILS_ENV and see http://github.com/collectiveidea/delayed_job/issues/#issue/7"
        end
        opts.on('--pid-dir=DIR', 'Specifies an alternate directory in which to store the process ids.') do |dir|
          @options[:pid_dir] = dir
        end
        opts.on('-m', '--monitor', 'Start monitor process.') do
          @monitor = true
        end
        opts.on('-p', '--prefix NAME', "String to be prefixed to worker process names") do |prefix|
          @options[:prefix] = prefix
        end
      end
      @args = opts.parse!(args)
    end

    def daemonize
      ObjectSpace.each_object(File) do |file|
        @files_to_reopen << file unless file.closed?
      end

      dir = @options[:pid_dir]
      Dir.mkdir(dir) unless File.exists?(dir)
      run_process("ironmine_scheudle", dir)
    end

    def run_process(process_name, dir)
      Daemons.run_proc(process_name, :dir => dir, :dir_mode => :normal, :monitor => @monitor, :ARGV => @args) do |*args|
        $0 = File.join(@options[:prefix], process_name) if @options[:prefix]
        run process_name
      end
    end

    def run(worker_name = nil)
      Dir.chdir(Rails.root)

      # Re-open file handles
      @files_to_reopen.each do |file|
        begin
          file.reopen file.path, "a+"
          file.sync = true
        rescue ::Exception
        end
      end

      logger = Logger.new(File.join(Rails.root, 'log', 'ironmine_scheudle.log'))
      scheduler = Rufus::Scheduler.start_new
      # receive email
      scheduler.every Irm::MailManager.receive_interval do
        logger.debug "schedule receive mail job"
        Irm::MailManager.receive_mail
      end
      # sync report schedule
      scheduler.cron '0 0 0 * * *' do
        Irm::ReportTrigger.all.each{|i| i.sync_schedule}
      end

      scheduler.join

    rescue => e
      Rails.logger.fatal e
      STDERR.puts e.message
      exit 1
    end

  end
end
