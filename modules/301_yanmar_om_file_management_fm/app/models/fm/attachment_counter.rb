class Fm::AttachmentCounter < ActiveRecord::Base
  set_table_name :fm_attachment_counters

  validates_presence_of :version_id, :download_by

  after_create :update_download_count

  scope :download_people, lambda {|version_id|
    joins("JOIN #{Irm::Person.table_name} p ON p.id=#{table_name}.download_by").
        where("#{table_name}.version_id=?", version_id).
        select("#{table_name}.*, p.full_name")
  }

  def update_download_count
    version_instance = Fm::AttachmentVersion.find(self.version_id)
    version_instance.download_count += 1
    version_instance.save
  end

end
