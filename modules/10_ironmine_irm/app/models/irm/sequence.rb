class Irm::Sequence < ActiveRecord::Base
  set_table_name :irm_sequences
  query_extend

  validates_uniqueness_of :object_name, :scope => :opu_id
  validates_presence_of :object_name, :seq_max, :seq_next
  def parse_val
    seq_length = self.seq_length
    max_id = self.seq_next.to_s
    max_id_length = max_id.length
    #不满长度补0
    while seq_length > max_id_length do
      max_id = '0' + max_id
      max_id_length = max_id.length
    end
    if self.rules.present? && self.rules.include?("###sequence###")
      max_id = rules.gsub("###sequence###", max_id)
    end
    max_id
  end

  def self.nextval(in_object_name, opu_id = Irm::Person.current.opu_id)
    return -1 unless in_object_name
    seq = Irm::Sequence.where(:object_name => in_object_name)
    return -1 unless seq.any?
    seq = seq.first
    increment_counter(:seq_next,seq.id)
    seq.reload
    seq.parse_val
  end
end
