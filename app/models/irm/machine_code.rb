require "macaddr"
class Irm::MachineCode < ActiveRecord::Base
  set_table_name :irm_machine_codes
  query_extend
  validates_presence_of :machine_addr
  validates_presence_of :machine_code ,:if=>Proc.new{|i| !i.new_record?}
  validates_uniqueness_of :machine_addr,:if=>Proc.new{|i| i.machine_addr.present?}
  validates_uniqueness_of :machine_code,:if=>Proc.new{|i| i.machine_code.present?}

  after_create :generate_code

  def generate_code
    unless self.machine_code.present?
      self.machine_code = Irm::IdGenerator.instance.rjust_decimal_to_62(self.id,4)
      self.save
    end
  end

  def self.code(mac_addr)
    instance = self.where(:machine_addr=>mac_addr).first
    if(instance)
      return instance.machine_code
    else
      self.create(:machine_addr=>mac_addr)
      return self.code(mac_addr)
    end
  end

  def self.current
    @current ||= self.code(Mac.addr)
  end
end
