class Irm::AttachScreenshotController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @container=Irm::Attachment.create()
    version = Irm::AttachmentVersion.new(:data => params[:attachments],
                                            :attachment_id=>@container.id,
                                            :source_type=> 0,
                                            :source_id => 0,
                                            :category_id => 0,
                                            :description => "")
    flag, now = version.over_limit?(Irm::SystemParametersManager.upload_file_limit)
    version.save if flag
    Irm::AttachmentVersion.update_attachment_by_version(@container,version)
    respond_to do |format|
      if flag && version && version.url.present?
        format.html{ render :text => version.url}
      else
        format.html{ render :text => now.to_s}
      end
    end
  end

  private

  def make_tmpname(date, name = "screenshot.png")
    sprintf('%d_%d%s', Irm::Person.current.id, date, name)
  end
end