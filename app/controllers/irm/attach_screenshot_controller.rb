class Irm::AttachScreenshotController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    @container=Irm::Attachment.create()
    version = Irm::AttachmentVersion.create(:data => params[:attachments],
                                            :attachment_id=>@container.id,
                                            :source_type=> 0,
                                            :source_id => 0,
                                            :category_id => 0,
                                            :description => "")
    Irm::AttachmentVersion.update_attachment_by_version(@container,version)
    respond_to do |format|
      if version && version.url.present?
        #format.html{ render :text => "<img src=#{version.url}>"}
        format.html{ render :text => params.to_json}
      else
        format.html{ render :text => "NA"}
      end

    end
  end

  private

  def make_tmpname(date, name = "screenshot.png")
    sprintf('%d_%d%s', Irm::Person.current.id, date, name)
  end
end