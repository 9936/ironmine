# -*- coding: utf-8 -*-
class AddSkmTypeLookupData < ActiveRecord::Migration
  def up
    skm_entry_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SKM_ENTRY_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_type.lookup_types_tls.build(:lookup_type_id=>skm_entry_type.id,:meaning=>'知识类型',:description=>'知识类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_type.lookup_types_tls.build(:lookup_type_id=>skm_entry_type.id,:meaning=>'Knowledge Type',:description=>'Knowledge Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_type.save

    skm_entry_typearticle= Irm::LookupValue.new(:lookup_type=>'SKM_ENTRY_TYPE',:lookup_code=>'ARTICLE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_typearticle.lookup_values_tls.build(:lookup_value_id=>skm_entry_typearticle.id,:meaning=>'知识文章',:description=>'以特定模板结构呈现的知识文章，包括文字和图片方式。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_typearticle.lookup_values_tls.build(:lookup_value_id=>skm_entry_typearticle.id,:meaning=>'Knowledge Article',:description=>'Article presented in given format.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_typearticle.save
    skm_entry_typevideo= Irm::LookupValue.new(:lookup_type=>'SKM_ENTRY_TYPE',:lookup_code=>'VIDEO',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_typevideo.lookup_values_tls.build(:lookup_value_id=>skm_entry_typevideo.id,:meaning=>'视频',:description=>'使用视频方式展现的知识内容，需要上传视频文件。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_typevideo.lookup_values_tls.build(:lookup_value_id=>skm_entry_typevideo.id,:meaning=>'Knowledge Video',:description=>'Upload a video file as knowledge.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_typevideo.save
  end

  def down
  end
end
