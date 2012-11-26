class Irm::AttachmentVersion < ActiveRecord::Base
  before_create :save_source_file_name
  set_table_name :irm_attachment_versions

  belongs_to :attachment

  acts_as_searchable

  has_attached_file :data,:whiny => false, :styles => {:thumb=> "60x60>",:small => "100x100>" }, :url=>Irm::Constant::ATTACHMENT_URL
  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => Irm::SystemParametersManager.upload_file_limit.kilobytes

  before_data_post_process :allow_only_images

  before_validation(:on=>:create) do
    setup_attachment_id
  end
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_all,lambda{
    select("#{table_name}.*")
  }

  scope :query_by_incident_request,lambda{|request_id|
    joins("JOIN #{Icm::IncidentJournal.table_name} ON #{table_name}.source_type= '#{Icm::IncidentJournal.name}' AND #{table_name}.source_id = #{Icm::IncidentJournal.table_name}.id AND #{Icm::IncidentJournal.table_name}.status_code = 'ENABLED'").
    where("#{Icm::IncidentJournal.table_name}.incident_request_id = ?", request_id)
  }

  scope :query_incident_request_file,lambda{|request_id|
    where("#{table_name}.source_type = ? AND #{table_name}.source_id = ? AND #{table_name}.status_code = 'ENABLED'",Icm::IncidentRequest.name, request_id)
  }

  scope :query_by_change_request,lambda{|request_id|
    joins("JOIN #{Chm::ChangeJournal.table_name} ON #{table_name}.source_type= '#{Chm::ChangeJournal.name}' AND #{table_name}.source_id = #{Chm::ChangeJournal.table_name}.id").
    where("#{Chm::ChangeJournal.table_name}.change_request_id = ?", request_id)
  }

  scope :query_change_request_file,lambda{|request_id|
    where("#{table_name}.source_type = ? AND #{table_name}.source_id = ?",Chm::ChangeRequest.name, request_id)
  }


  def image?
    self.image_flag.eql?(Irm::Constant::SYS_YES)
  end

  def self.dataurl(attributes,style_name="original")
    attributes.merge!({:class_name=>self.name,:name=>"data"})
    Fwk::PaperclipHelper.gurl(attributes,style_name)
  end

  def self.datapath(attributes,style_name="original")
    attributes.merge!({:class_name=>self.name,:name=>"data"})
    Fwk::PaperclipHelper.gpath(attributes,style_name)
  end

  def self.file_type_icon(file_name)
    extension = File.extname(file_name).gsub(/^\.+/, "")
    if ['doc','docx','rar','sql','txt','xls','xlsx','zip'].include?(extension)
      return "filetypes/#{extension}.png"
    else
      return "filetypes/default.png"
    end
  end

  searchable do
    string :source_id
    string :source_type
    string :external_system_id do
      get_external_system_id
    end
    string :attachment_id
    text :data_file_name,:stored => true
    attachment :data_path
    time :updated_at
  end

  def get_external_system_id
    if source_type.eql?('Icm::IncidentRequest')
      incident_request_id = source_id
    elsif source_type.eql?('Icm::IncidentJournal') and Icm::IncidentJournal(source_id).present?
      incident_request_id = Icm::IncidentJournal(source_id).incident_request_id
    else
      incident_request_id = ''
    end
    if incident_request_id.present? and Icm::IncidentRequest(incident_request_id).present?
      Icm::IncidentRequest(incident_request_id).incident_request.external_system_id
    else
      ''
    end
  end


  #返回附件url
  def url(*args)
    data.url(*args)
  end

  def path
    url_arr = data.url.split("/")
    url_arr.delete(url_arr.last)
    url_arr.join("/") + "/"
  end

  #返回附件名称
  def name
    data_file_name
  end

  def source_name
    source_file_name
  end

  #返回附件类型
  def content_type
    data_content_type
  end

  #返回附件大小
  def file_size
    data_file_size
  end

  #以KB单位返回文件大小
  def file_size_kb
    (format("%.2f", data_file_size.to_f/1024)).to_s
  end

  def file_description
    self.attachment.description
  end

  def self.query_attachment_count(source_type,source_id)
     AttachmentVersion.count(:conditions=>" #{AttachmentVersion.table_name}.source_type='#{source_type}' AND #{AttachmentVersion.table_name}.source_id=#{source_id} ")
  end

  def after_destroy
    Dir.rmdir diskfile if !data_file_name.blank? && File.directory?(diskfile)
  end

  def diskfile
    "#{@@storage_path}/#{self.id}"
  end
  
  #根据post中的附件数组，创建附件,
  def self.attach_files(attachments,source_type,source_id)
    attached = []
    unsaved = []
    #判断是否有附件上传
    if attachments && attachments.is_a?(Hash)
      #对每个附件进行处理
      attachments.each_value do |attachment|
        #获取文件
        file = attachment['file']
        next unless file && file.size > 0
        #创建附件，此处的:data不是数据库列,而是在Attachment中用语句
        #has_attached_file :data, :styles => {:thumb=> "60x60#",:small => "150x150>" }
        #生成的由Paperclip插件处理
        version = Irm::AttachmentVersion.create(:data => file,
                                                :source_type=>source_type,
                                                :source_id =>source_id,
                                                :file_category => attachment['file_category'],
                                                :description => attachment['description'].to_s.strip)
        if version.new_record?
           unsaved << version
        else
           attached << version
        end
      end
      if unsaved.any?
        return false
      end
    end
    attached
  end

  #根据post中的附件数组，创建附件,在新建附件时创建附件容器
  def self.create_verison_files(attachments, source_type, source_id)
    attached = []
    unsaved = []
    #判断是否有附件上传
    if attachments && attachments.is_a?(Hash)
      #对每个附件进行处理
      attachments.each_value do |attachment|
        #获取文件
        file = attachment['file']
        next unless file && file.size > 0
        #创建附件容器
        @container=Irm::Attachment.create()
        #创建附件，此处的:data不是数据库列,而是在Attachment中用语句
        #has_attached_file :data, :styles => {:thumb=> "60x60#",:small => "150x150>" }
        #生成的由Paperclip插件处理
        attachment['file_category'] = Irm::FlexValue.where("flex_value = ?", "OTHERS").first().id if attachment['file_category'].blank?
        version = Irm::AttachmentVersion.create(:data => file,
                                              :attachment_id=>@container.id,
                                              :source_type=>source_type,
                                              :source_id =>source_id,
                                              :category_id => attachment['file_category'],
                                              :description => attachment['description'].to_s.strip)
        if version.new_record?
           unsaved << version
           @container.destroy
        else
           attached << version
          update_attachment_by_version(@container,version)
        end
      end
      if unsaved.any?
        return false
      end
    end
    attached
  end

  #根据post中的附件，创建单个附件，并在新建附件时创建附件容器
  def self.create_single_version_file(file, description, category_id, source_type, source_id)
    #创建容器
    container = Irm::Attachment.create()
    file_category = category_id.nil? ? Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "OTHER") : category_id
    version = Irm::AttachmentVersion.create(:data => file,
                                            :attachment_id => container.id,
                                            :source_type => source_type,
                                            :source_id => source_id,
                                            :category_id => file_category,
                                            :description => description)
    if version.new_record?
      container.destroy
    else
      update_attachment_by_version(container, version)
    end
    return version
  end

  #更新容器中的最近更新版本的附件信息
  def self.update_attachment_by_version(attachment,version)
    attachment.update_attributes(:latest_version_id=>version.id,
                                :file_name=>version.data_file_name,
                                :file_type=> version.data_content_type,
                                :file_category=>version.category_id,
                                :file_size=>version.data_file_size,
                                :description=>version.description,
                                :private_flag=>version.private_flag,
                                :source_file_name => version.source_file_name)
  end

  #根据post中的附件数组，创建附件的新版本
  def self.update_version_files(container,attachments,source_type,source_id)
    attached = []
    unsaved = []
    #判断是否有附件上传
    if attachments && attachments.is_a?(Hash)
      #对每个附件进行处理
      attachments.each_value do |attachment|
        #获取文件
        file = attachment['file']
        next unless file && file.size > 0
        #创建附件，此处的:data不是数据库列,而是在Attachment中用语句
        #has_attached_file :data, :styles => {:thumb=> "60x60#",:small => "150x150>" }
        #生成的由Paperclip插件处理
        version = Irm::AttachmentVersion.create(:data => file,
                                                :attachment_id=>container.id,
                                                :source_type=>source_type,
                                                :source_id =>source_id,
                                                :category_id => attachment['file_category'],
                                                :description => attachment['description'].to_s.strip)
        if version.new_record?
           unsaved << version
        else
           attached << version
          update_attachment_by_version(container,version)
        end
      end
      if unsaved.any?
        return false
      end
    end
    attached
  end

  #根据post中的附件数组，创建附件,在新建附件时创建附件容器
  def self.create_import_files(attachment,source_type,source_id,options = {})
    #判断是否有附件上传
    if attachment && attachment.is_a?(Hash)
        #获取文件
        file = attachment['file']
        if file && file.size > 0
            @attachment = Irm::AttachmentVersion.create(:data => file,
                                                  :attachment_id=>nil,
                                                  :source_type=>source_type,
                                                  :source_id =>source_id,
                                                  :file_category => attachment['file_category'],
                                                  :description => attachment['description'].to_s.strip)
        end
    end
    @attachment
  end  


  def self.validates?(file, size_limit = Irm::SystemParametersManager.upload_file_limit)
    return true, 0 if file.nil?
    f = Irm::AttachmentVersion.new({:source_id=> -1,
                                     :source_type=> "",
                                     :data=>file,
                                     :description=>""})
    flag, now = f.over_limit?(size_limit)
    return false, now unless flag
    return true, 0
  end

  def self.validates_repeat?(files_array)
    a = files_array.values.delete_if{|p| p["file"].nil?}
    values = a.collect{|p| [p["file"].original_filename, p["file"].size]}
    if values.uniq.size != values.size
      return false, I18n.t(:error_file_upload_repeat)
    end
    return true, nil
  end

  def over_limit?(size_limit)
    return false, self.file_size_kb if self.file_size_kb.to_f > size_limit.to_f
    return true, 0
  end

  private
  def setup_attachment_id
    self.attachment_id  = 0 unless self.attachment_id 
  end

  def allow_only_images
    if !(data.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      self.image_flag="N"
      return false
    end
  end

  #如果是视频文件，则将中文文件名转换为随机编码保存，以便于video js播放(仅适用于知识库附件)
  #source file name中保存原始文件名
  def save_source_file_name
    self.source_file_name = data_file_name
    if self.source_type == Skm::EntryHeader.name && self.category_id == Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "VIDEO")
      ext = File.extname(data_file_name).downcase
      self.data.instance_write(:file_name, "#{UUID.generate(:compact)[0,21]}#{ext}")
    end
  end

  private
    def data_path
      #只对指定格式的附件内容进行索引
      ext_arr = ['.doc','.docx','.txt','.pdf','.xls','.ppt','.pptx','.html','.xls','.xlsx']
      ext =  self.data.path.scan(/\.[^\.]+$/)[0]
      if ext_arr.include?(ext)
        self.data.path
      else
        nil
      end

    end
end