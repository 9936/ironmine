class Emw::Interface < ActiveRecord::Base
  set_table_name :emw_interfaces

  belongs_to :ebs_module, :foreign_key => :ebs_module_id
  has_many :interface_tables, :foreign_key => :interface_id, :dependent => :destroy

  validates_presence_of :ebs_module_id, :name

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_module, lambda{
    select("#{table_name}.*, em.name module_name, em.module_code").
        joins("JOIN #{Emw::EbsModule.table_name} em ON em.id=#{table_name}.ebs_module_id")
  }

  def self.lov(lov_scope, params)
    #排除掉已经在对象列表中的
    if "monitor_target".eql?(params[:lov_params][:lktkn])&& params[:lov_params][:monitor_program_id].present?
      lov_scope = lov_scope.where("NOT EXISTS(SELECT 1 FROM #{Emw::MonitorTarget.table_name} et WHERE (#{table_name}.id=et.target_id AND et.monitor_program_id=?) )", params[:lov_params][:monitor_program_id])
    end
    lov_scope
  end

end
