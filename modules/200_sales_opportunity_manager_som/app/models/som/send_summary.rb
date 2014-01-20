class Som::SendSummary < ActiveRecord::Base
  set_table_name 'som_send_summaries'
  acts_as_timetrigger
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  def perform
    bo=Irm::BusinessObject.find("000d00092ZWQzx5wuGm78q")
    recipient_ids = "000100012i8IyyjJaqMaJ6"

    #生成汇总报表附件
    xls=Som::SalesOpportunity.send_summary_data
    tmp_folder = "#{Rails.root.to_s}/tmp/som/xls"
    file_name="/#{Time.now.strftime('%Y%m%d%H%M%S')}.xls"
    binding.pry
    FileUtils.mkdir_p(tmp_folder, :mode => 0777) unless File.exist?(tmp_folder)
    save_path = tmp_folder+file_name
    File.open(save_path, 'wb') do |file|
      file << xls
    end

    # template params
    params = {:object_params=>Irm::BusinessObject.liquid_attributes(bo,true)}
    # mail options
    mail_options = {}
    mail_options.merge!(:message_id=>Irm::BusinessObject.mail_message_id(bo,"mailalert"),:attachment=>file_name)
    params.merge!(:mail_options=>mail_options)
     # header options
    sales=Som::SalesOpportunity.find("005g00092YW2jv8jAIn6eW")
    header_options = {}
    mail_message_id = Irm::BusinessObject.mail_message_id(sales)
    header_options.merge!({"References"=>mail_message_id })
    params.merge!(:header_options=>header_options)


    # template 　
    mail_template = Irm::MailTemplate.query_by_template_code('SALES_SETTING').first

    #记录到邮件发送日志表
    #logger_options = {
    #    :reference_target => "BUSINESS_OBJECT:#{params}",
    #    :template_code => self.mail_template_code
    #}


   # params[:attachments]={"summary.xls"=>Som::SalesOpportunity.send_summary_data}
    mail_template.deliver_to(params.merge(:to_person_ids =>recipient_ids))
    #recipient_ids.each do |pid|
    #  mail_template.deliver_to(params.merge(:to_person_ids => [pid], :logger_options => logger_options))
    #end
    puts "===========start SendSummary=============="
    #Delayed::Worker.logger.debug("---------------------SendSummary-#{Time.now}--------------------")
    #puts "===========end SendSummary=============="
  end

end
