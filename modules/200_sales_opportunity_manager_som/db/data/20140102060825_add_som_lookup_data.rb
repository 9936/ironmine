# -*- coding: utf-8 -*-
class AddSomLookupData < ActiveRecord::Migration
  def up
    #----------------------------BEGIN REGION---------------------------------------------------------
    som_region_info=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SOM_REGION_INFO ',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_region_info.lookup_types_tls.build(:lookup_type_id=>som_region_info.id,:meaning=>'区域信息',:description=>'区域信息',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_info.lookup_types_tls.build(:lookup_type_id=>som_region_info.id,:meaning=>'Region Info',:description=>'Region Info',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_info.save

    som_region_infoeast= Irm::LookupValue.new(:lookup_type=>'SOM_REGION_INFO',:lookup_code=>'EAST',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_region_infoeast.lookup_values_tls.build(:lookup_value_id=>som_region_infoeast.id,:meaning=>'华东',:description=>'华东',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infoeast.lookup_values_tls.build(:lookup_value_id=>som_region_infoeast.id,:meaning=>'East China',:description=>'East China',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infoeast.save

    som_region_infosouth= Irm::LookupValue.new(:lookup_type=>'SOM_REGION_INFO',:lookup_code=>'SOUTH',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_region_infosouth.lookup_values_tls.build(:lookup_value_id=>som_region_infosouth.id,:meaning=>'华南',:description=>'华南',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infosouth.lookup_values_tls.build(:lookup_value_id=>som_region_infosouth.id,:meaning=>'South China',:description=>'South China',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infosouth.save

    som_region_infonorth= Irm::LookupValue.new(:lookup_type=>'SOM_REGION_INFO',:lookup_code=>'NORTH',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_region_infonorth.lookup_values_tls.build(:lookup_value_id=>som_region_infonorth.id,:meaning=>'华北',:description=>'华北',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infonorth.lookup_values_tls.build(:lookup_value_id=>som_region_infonorth.id,:meaning=>'North China',:description=>'North China',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infonorth.save

    som_region_infopro= Irm::LookupValue.new(:lookup_type=>'SOM_REGION_INFO',:lookup_code=>'PRODUCTION',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_region_infopro.lookup_values_tls.build(:lookup_value_id=>som_region_infopro.id,:meaning=>'产品',:description=>'产品',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infopro.lookup_values_tls.build(:lookup_value_id=>som_region_infopro.id,:meaning=>'Production',:description=>'Production',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infopro.save

    som_region_infohisms= Irm::LookupValue.new(:lookup_type=>'SOM_REGION_INFO',:lookup_code=>'HISMS',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_region_infohisms.lookup_values_tls.build(:lookup_value_id=>som_region_infohisms.id,:meaning=>'HISMS',:description=>'HISMS',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infohisms.lookup_values_tls.build(:lookup_value_id=>som_region_infohisms.id,:meaning=>'HISMS',:description=>'HISMS',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_region_infohisms.save

    #--------------------------------BEGIN PRODUCTION-----------------------------------------------------
    som_production_info=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SOM_PRODUCTION_INFO ',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_info.lookup_types_tls.build(:lookup_type_id=>som_production_info.id,:meaning=>'涉及产品信息',:description=>'涉及产品信息',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_info.lookup_types_tls.build(:lookup_type_id=>som_production_info.id,:meaning=>'Involved Production Info',:description=>'Involved Production Info',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_info.save

    som_production_infooperation= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'OPERATION',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infooperation.lookup_values_tls.build(:lookup_value_id=>som_production_infooperation.id,:meaning=>'运维体系',:description=>'运维体系',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infooperation.lookup_values_tls.build(:lookup_value_id=>som_production_infooperation.id,:meaning=>'Operation And Maintenance System ',:description=>'Operation And Maintenance System',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infooperation.save

    som_production_infohisms= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'HISMS',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infohisms.lookup_values_tls.build(:lookup_value_id=>som_production_infohisms.id,:meaning=>'HISMS',:description=>'HISMS',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohisms.lookup_values_tls.build(:lookup_value_id=>som_production_infohisms.id,:meaning=>'HISMS',:description=>'HISMS',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohisms.save

    som_production_infoebs= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'EBS',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infoebs.lookup_values_tls.build(:lookup_value_id=>som_production_infoebs.id,:meaning=>'EBS',:description=>'EBS',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infoebs.lookup_values_tls.build(:lookup_value_id=>som_production_infoebs.id,:meaning=>'EBS',:description=>'EBS',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infoebs.save

    som_production_infosiebel= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'Siebel',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infosiebel.lookup_values_tls.build(:lookup_value_id=>som_production_infosiebel.id,:meaning=>'Siebel',:description=>'Siebel',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infosiebel.lookup_values_tls.build(:lookup_value_id=>som_production_infosiebel.id,:meaning=>'Siebel',:description=>'Siebel',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infosiebel.save

    som_production_infohr= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'HR/Peoplesoft',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infohr.lookup_values_tls.build(:lookup_value_id=>som_production_infohr.id,:meaning=>'HR/Peoplesoft',:description=>'HR/Peoplesoft',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohr.lookup_values_tls.build(:lookup_value_id=>som_production_infohr.id,:meaning=>'HR/Peoplesoft',:description=>'HR/Peoplesoft',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohr.save

    som_production_infohyperion= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'Hyperion',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infohyperion.lookup_values_tls.build(:lookup_value_id=>som_production_infohyperion.id,:meaning=>'Hyperion',:description=>'Hyperion',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohyperion.lookup_values_tls.build(:lookup_value_id=>som_production_infohyperion.id,:meaning=>'Hyperion',:description=>'Hyperion',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohyperion.save

    som_production_infohyms= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'MS',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infohyms.lookup_values_tls.build(:lookup_value_id=>som_production_infohyms.id,:meaning=>'MS',:description=>'MS',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohyms.lookup_values_tls.build(:lookup_value_id=>som_production_infohyms.id,:meaning=>'MS',:description=>'MS',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohyms.save

    som_production_infohyjava= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_INFO',:lookup_code=>'JAVA',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_infohyjava.lookup_values_tls.build(:lookup_value_id=>som_production_infohyjava.id,:meaning=>'JAVA',:description=>'JAVA',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohyjava.lookup_values_tls.build(:lookup_value_id=>som_production_infohyjava.id,:meaning=>'JAVA',:description=>'JAVA',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_infohyjava.save


    #--------------------------------BEGIN SALES_STATUS-----------------------------------------------------
    som_production_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SOM_PRODUCTION_STATUS ',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_status.lookup_types_tls.build(:lookup_type_id=>som_production_status.id,:meaning=>'预销售项目状态',:description=>'预销售项目状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_status.lookup_types_tls.build(:lookup_type_id=>som_production_status.id,:meaning=>'sales status',:description=>'sales status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_status.save

    som_production_statusquote= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_STATUS',:lookup_code=>'QUOTE',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_statusquote.lookup_values_tls.build(:lookup_value_id=>som_production_statusquote.id,:meaning=>'报价',:description=>'报价',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusquote.lookup_values_tls.build(:lookup_value_id=>som_production_statusquote.id,:meaning=>'Quote',:description=>'Quote',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusquote.save

    som_production_statusproject= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_STATUS',:lookup_code=>'PROJECT',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_statusproject.lookup_values_tls.build(:lookup_value_id=>som_production_statusproject.id,:meaning=>'方案',:description=>'方案',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusproject.lookup_values_tls.build(:lookup_value_id=>som_production_statusproject.id,:meaning=>'Project',:description=>'Project',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusproject.save

    som_production_statusbid= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_STATUS',:lookup_code=>'BID',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_statusbid.lookup_values_tls.build(:lookup_value_id=>som_production_statusbid.id,:meaning=>'投标',:description=>'投标',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusbid.lookup_values_tls.build(:lookup_value_id=>som_production_statusbid.id,:meaning=>'Bid',:description=>'Bid',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusbid.save

    som_production_statusbusiness= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_STATUS',:lookup_code=>'BUSINESS',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_statusbusiness.lookup_values_tls.build(:lookup_value_id=>som_production_statusbusiness.id,:meaning=>'商务',:description=>'商务',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusbusiness.lookup_values_tls.build(:lookup_value_id=>som_production_statusbusiness.id,:meaning=>'Business',:description=>'Business',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statusbusiness.save

    som_production_statuscancel= Irm::LookupValue.new(:lookup_type=>'SOM_PRODUCTION_STATUS',:lookup_code=>'CANCEL',:start_date_active=>'2014-01-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    som_production_statuscancel.lookup_values_tls.build(:lookup_value_id=>som_production_statuscancel.id,:meaning=>'取消',:description=>'取消',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statuscancel.lookup_values_tls.build(:lookup_value_id=>som_production_statuscancel.id,:meaning=>'Cancel',:description=>'Cancel',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    som_production_statuscancel.save
  end
end
