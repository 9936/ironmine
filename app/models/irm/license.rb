class Irm::License < ActiveRecord::Base
  set_table_name :irm_licenses


  #多语言关系
  attr_accessor :name,:description
  has_many :licenses_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :license_functions ,:dependent => :destroy
  has_many :functions,:through => :license_functions

  query_extend

  def function_ids
    return @function_ids if @function_ids
    @function_ids = self.license_functions.collect{|i| i.function_id}
  end


  def create_from_function_ids(function_ids)
    return unless function_ids.is_a?(Array)&&function_ids.any?
    exists_functions = Irm::LicenseFunction.where(:license_id=>self.id)
    exists_functions.each do |function|
      if function_ids.include?(function.function_id)
        function_ids.delete(function.function_id)
      else
        function.destroy
      end
    end

    function_ids.each do |fid|
      next unless fid
      self.license_functions.build({:function_id=>fid})
    end if function_ids.any?
  end
end
