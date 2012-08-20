class Irm::AttachmentsController < ApplicationController
  def destroy_attachment
    @attachment_version = Irm::AttachmentVersion.where(:id=>params[:id],:source_id=>params[:source_id]).first
    respond_to do |format|
      if @attachment_version.present?&&@attachment_version.destroy
          format.json  { render :json => @attachment_version }
      else
        format.json  { render :json => {:message=>"error"} }
      end
    end
  end

  def create_attachment
    attachment = Irm::AttachmentVersion.new({:source_id=>params[:source_id],:source_type=>params[:source_type]})
    file_name = request.env['HTTP_X_FILENAME']
    file_type = request.env['HTTP_X_FILETYPE']
    FileUtils.mkdir_p("#{Rails.root.to_s}/tmp/irm/attachment_versions", :mode => 0777)
    tmp_file_path = "#{Rails.root.to_s}/tmp/irm/attachment_versions/#{Fwk::IdGenerator.instance.generate(Irm::AttachmentVersion.table_name)}#{file_name}"

    File.open(tmp_file_path, "wb") do |f|
        f.write(request.env['rack.input'].read)
    end

    attachment.data = File.new(tmp_file_path)
    attachment.data.instance_write :file_name , file_name

    attachment.save
    respond_to do |format|
        format.json  {
          options = attachment.attributes
          options.merge!(:show_url => attachment.data.url)
          if params[:source_id].present?
            options.merge!(:delete_url=>url_for(:controller => "irm/attachments",:action => "destroy_attachment",:id=>attachment.id,:source_id=>params[:source_id],:_dom_id=>request.env['HTTP_X_DOMID']))
          end
          render :json => options.to_json
        }
    end
  end
end
