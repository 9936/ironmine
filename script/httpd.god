God.watch do |w|

  w.pid_file = "/var/run/httpd/httpd.pid"
  w.name = "httpd"
  w.group = "httpd"
  w.interval = 120.seconds
  w.start = "/etc/init.d/httpd start"
  w.stop = "/etc/init.d/httpd stop"
  w.restart = "/etc/init.d/httpd restart"


  w.behavior(:clean_pid_file)

  w.start_if do |start|
     start.condition(:process_running) do |c|
       c.interval = 60.seconds
       c.running = false
     end
  end

  # restart http server
  w.restart_if do |restart|

    restart.condition(:http_response_code) do |c|
      c.host = 'localhost'
      c.path = '/login'
      c.timeout = 90.seconds
      c.times = [4, 5]
      c.code_is_not = 200
    end

  end
  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 10.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end