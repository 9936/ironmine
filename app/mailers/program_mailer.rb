class ProgramMailer < ActionMailer::Base
  default :from => Irm::MailManager.default_email_from

  def program_email(program_id, program_schedule, mail_options)
    send_options = mail_options

    program = Isp::Program.multilingual.find(program_id)

    program_check_item_hash = eval(program_schedule[:isp_program])
    program.attributes = program_check_item_hash[:isp_program]
    execute_context = {}
    program.connections.each do |c|
      #设置巡检项中的参数
      c.check_items.each do |check_item|
        check_item.check_parameters.each do |p|
          p.value = program_check_item_hash[:isp_check_item][c.id][check_item.id][p.id][:value]
        end
      end

      execute_context.merge!({c.object_symbol=>{:username=>c.username,:password=>c.password,:host=>c.host}})
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