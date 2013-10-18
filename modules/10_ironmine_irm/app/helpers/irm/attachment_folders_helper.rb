module Irm::AttachmentFoldersHelper
  def available_attachment_parent_folder(id,del_p)
    @collects=[]
    folders=Irm::AttachmentFolder.all
    folders.each do |f|
      @collects<<{name: f[:name], id: f[:id]}
    end
    parent_folder(id) if del_p
    rets=@collects.collect { |c| [c[:name], c[:id]] }
    return rets
  end

  def parent_folder(id)
    folders=Irm::AttachmentFolder.where('parent_id=?', id)
    folders.each do |folder|
      parent_folder(folder[:id])
    end
    me= Irm::AttachmentFolder.find(id)
    @collects.delete_if { |d| d[:id]==me[:id] and d[:name]==me[:name] }
  end

end
