class Irm::AttachmentCounter < ActiveRecord::Base
  set_table_name :irm_attachment_counters

  validates_presence_of :version_id, :download_by

  after_create :update_download_count

  def update_download_count
    version_instance = Irm::AttachmentVersion.find(self.version_id)
    version_instance.download_count += 1
    version_instance.save
  end

end
