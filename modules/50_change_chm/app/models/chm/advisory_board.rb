class Chm::AdvisoryBoard < ActiveRecord::Base
  set_table_name :chm_advisory_boards

  validates_presence_of :code,:name
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?},:message=>:code

  query_extend

end
