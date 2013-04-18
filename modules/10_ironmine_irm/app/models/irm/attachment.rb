class Irm::Attachment < ActiveRecord::Base
  set_table_name :irm_attachments

  attr_accessor :data

  has_many :attachment_versions, :dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }
  #Irm::Attachment.accessible('000100012i8IyyjJaqMaJ6')
  scope :accessible, lambda { |person_id|
    select("#{table_name}.*, p.full_name, av.id version_id, av.data_file_name data_file_name, av.download_count download_count, av.data_content_type data_content_type, av.data_file_size/1024 data_file_size, av.data_updated_at data_updated_at").
        joins("LEFT JOIN #{Irm::AttachmentMember.table_name} iam ON #{table_name}.id=iam.attachment_id").
        joins("LEFT JOIN #{Irm::Person.table_name} p ON #{table_name}.created_by = p.id").
        joins("LEFT JOIN #{Irm::AttachmentVersion.table_name} av ON(av.attachment_id=#{table_name}.id AND av.id = #{table_name}.latest_version_id)").
        where("(#{table_name}.access_type='PUBLIC') OR (#{table_name}.access_type='PRIVATE' AND #{table_name}.created_by='#{person_id}' ) OR (#{table_name}.access_type='MEMBERS' AND (EXISTS(SELECT 1 FROM irm_person_relations_v iprv WHERE iprv.source_id=iam.member_id AND iprv.source_type=iam.member_type AND iprv.person_id = '#{person_id}' ) ) ) ")
  }

  scope :list_all, lambda{
    select("#{table_name}.*, p.full_name, av.id version_id, av.category_id category_id, av.data_file_name data_file_name, av.download_count download_count, av.data_content_type data_content_type, av.data_file_size/1024 data_file_size, av.data_updated_at data_updated_at, fvt.meaning category_name").
        select("av.source_type source_type, av.source_id source_id").
        joins(", #{Irm::AttachmentVersion.table_name} av").
        joins(", #{Irm::LookupValue.table_name} fv").
        joins(", #{Irm::LookupValuesTl.table_name} fvt").
        joins(", #{Irm::Person.table_name} p").
        where("fv.id = av.category_id").
        where("fv.id = fvt.lookup_value_id").
        where("#{table_name}.updated_by = p.id").
        where("fvt.language = ?", I18n.locale).
        where("#{table_name}.latest_version_id = av.id")
  }

  scope :query_by_source, lambda { |source_type, source_id|
    where("av.id = #{table_name}.latest_version_id").
        where("av.source_type = ?", source_type).
        where("av.source_id = ?", source_id)
  }


  def last_version_entity
    self.attachment_versions.where("id = ?", self.latest_version_id).first
  end

  #创建 更新 文件夹成员
  def create_member_from_str(member_str)
    if (!self.access_type.eql?("MEMBERS"))
      member_str = ""
    end
    return unless member_str
    str_values = member_str.split(",").delete_if { |i| !i.present? }
    exists_values = Irm::AttachmentMember.where(:attachment_id => self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.member_type}##{value.member_id}")
        str_values.delete("#{value.member_type}##{value.member_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      Irm::AttachmentMember.create(:member_type => value[0], :member_id => value[1], :attachment_id => self.id)
    end
  end


  def get_member_str
    return @get_member_str if @get_member_str
    @get_member_str||= Irm::AttachmentMember.where(:attachment_id => self.id).collect { |value| "#{value.member_type}##{value.member_id}" }.join(",")
  end

end