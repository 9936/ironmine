class ProgramMailer < ActionMailer::Base
  default :from => Irm::MailManager.default_email_from

  def program_email(program_id, program_schedule, mail_options)
    send_options = mail_options

    program = Isp::Program.multilingual.find(program_id)
    program.attributes = eval(program_schedule[:isp_program])
    execute_context = {}
    program.connections.each do |c|
      execute_context.merge!({c.object_symbol=>{:username=>c.username,:password=>c.password,:host=>c.host}})
    end
    program.check_parameters.each do |p|
      execute_context.merge!({p.object_symbol=>p.value})
    end
    results = program.execute(execute_context)


    @doc = program.generate_report(results)
    if @doc.blank?
      @doc = "There is no data."
    end

    #检查警告条件
    @doc_alerts = program.check_alert(results)


    subject = "#{program[:name]}-#{program_schedule.run_at.strftime('%Y-%m-%d %H:%M:%S')}"

    send_options.merge!(:subject=>subject,:logger => {:reference_target => "PROGRAM_ID:#{program_id}"})

    mail(send_options) do |format|
      format.html
    end
  end
end