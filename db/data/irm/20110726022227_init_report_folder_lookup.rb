# -*- coding: utf-8 -*-
class InitReportFolderLookup < ActiveRecord::Migration
  def self.up
    irm_report_folder_access_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_access_type.id,:meaning=>'报表文件夹非私有报表访问类型',:description=>'报表文件夹非私有报表访问类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_access_type.id,:meaning=>'Report Folder Else report Access Type',:description=>'Report Folder Else report Access Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_type.save

    irm_report_folder_access_typeforbid= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:lookup_code=>'FORBID',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_typeforbid.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeforbid.id,:meaning=>'禁止访问',:description=>'禁止访问',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeforbid.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeforbid.id,:meaning=>'Forbid',:description=>'Forbid',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeforbid.save
    irm_report_folder_access_typeread= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:lookup_code=>'READ',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_typeread.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread.id,:meaning=>'只读',:description=>'只读',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread.id,:meaning=>'Read Only',:description=>'Read Only',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread.save
    irm_report_folder_access_typeread_write= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:lookup_code=>'READ_WRITE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_typeread_write.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread_write.id,:meaning=>'读写',:description=>'读写',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread_write.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread_write.id,:meaning=>'Read Write',:description=>'Read Write',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread_write.save


    irm_report_date_group_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_type.lookup_types_tls.build(:lookup_type_id=>irm_report_date_group_type.id,:meaning=>'报表日期列分组方式',:description=>'报表日期列分组方式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_type.lookup_types_tls.build(:lookup_type_id=>irm_report_date_group_type.id,:meaning=>'Report Column Date Group Type',:description=>'Report Column Date Group Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_type.save
    irm_report_group_column_sort=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_GROUP_COLUMN_SORT',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_group_column_sort.lookup_types_tls.build(:lookup_type_id=>irm_report_group_column_sort.id,:meaning=>'报表分组列排序方式',:description=>'报表分组列排序方式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sort.lookup_types_tls.build(:lookup_type_id=>irm_report_group_column_sort.id,:meaning=>'Report Group Column Sort Type',:description=>'Report Group Column Sort Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sort.save

    irm_report_date_group_typeday= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:lookup_code=>'DAY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_typeday.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeday.id,:meaning=>'日期',:description=>'日期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeday.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeday.id,:meaning=>'Day',:description=>'Day',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeday.save
    irm_report_date_group_typemonth= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:lookup_code=>'MONTH',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_typemonth.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typemonth.id,:meaning=>'月份',:description=>'月份',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typemonth.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typemonth.id,:meaning=>'Month',:description=>'Month',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typemonth.save
    irm_report_date_group_typeyear= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:lookup_code=>'YEAR',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_typeyear.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeyear.id,:meaning=>'年份',:description=>'年份',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeyear.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeyear.id,:meaning=>'Year',:description=>'Year',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeyear.save
    irm_report_group_column_sortasc= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_GROUP_COLUMN_SORT',:lookup_code=>'ASC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_group_column_sortasc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortasc.id,:meaning=>'正序',:description=>'正序',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortasc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortasc.id,:meaning=>'Asc',:description=>'Asc',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortasc.save
    irm_report_group_column_sortdesc= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_GROUP_COLUMN_SORT',:lookup_code=>'DESC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_group_column_sortdesc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortdesc.id,:meaning=>'倒序',:description=>'倒序',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortdesc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortdesc.id,:meaning=>'Desc',:description=>'Desc',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortdesc.save


    irm_report_folder_member_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_member_type.id,:meaning=>'报表文件夹可访问成员类型',:description=>'报表文件夹可访问成员类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_member_type.id,:meaning=>'Report Folder Member Type',:description=>'Report Folder Member Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_type.save

    irm_report_folder_member_typemember= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:lookup_code=>'MEMBER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_typemember.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typemember.id,:meaning=>'报表文件夹指定成员可见',:description=>'报表文件夹指定成员可见',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typemember.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typemember.id,:meaning=>'This folder is accessible by all users',:description=>'This folder is accessible by all users',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typemember.save
    irm_report_folder_member_typeprivate= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:lookup_code=>'PRIVATE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_typeprivate.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typeprivate.id,:meaning=>'仅创建人可见',:description=>'仅创建人可见',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typeprivate.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typeprivate.id,:meaning=>'This folder is hidden from all users',:description=>'This folder is hidden from all users',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typeprivate.save
    irm_report_folder_member_typepublic= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:lookup_code=>'PUBLIC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_typepublic.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typepublic.id,:meaning=>'公共报表文件夹',:description=>'公共报表文件夹',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typepublic.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typepublic.id,:meaning=>'This folder is accessible only by the following users',:description=>'This folder is accessible only by the following users',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typepublic.save
  end

  def self.down
  end
end
