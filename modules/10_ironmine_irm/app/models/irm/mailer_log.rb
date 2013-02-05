class Irm::MailerLog < ActiveRecord::Base
  set_table_name :irm_mailer_logs

  query_extend

  scope :order_by_created_at, order("#{table_name}.created_at DESC")


end