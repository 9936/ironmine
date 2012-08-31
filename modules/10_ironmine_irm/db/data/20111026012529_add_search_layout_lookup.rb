# -*- coding: utf-8 -*-
class AddSearchLayoutLookup < ActiveRecord::Migration
  def up
    irm_bo_search_layout=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layout.lookup_types_tls.build(:lookup_type_id=>irm_bo_search_layout.id,:meaning=>'业务对像搜索页面布局',:description=>'业务对像搜索页面布局',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layout.lookup_types_tls.build(:lookup_type_id=>irm_bo_search_layout.id,:meaning=>'Business Object Search Layout',:description=>'Business Object Search Layout',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layout.save

    irm_bo_search_layoutsearch= Irm::LookupValue.new(:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:lookup_code=>'SEARCH',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layoutsearch.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutsearch.id,:meaning=>'搜索结果',:description=>'搜索结果',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutsearch.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutsearch.id,:meaning=>'Search Results',:description=>'Search Results',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutsearch.save
    irm_bo_search_layoutlookup= Irm::LookupValue.new(:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:lookup_code=>'LOOKUP',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layoutlookup.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutlookup.id,:meaning=>'查找对话框',:description=>'查找对话框',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutlookup.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutlookup.id,:meaning=>'Lookup Dialogs',:description=>'Lookup Dialogs',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutlookup.save
    irm_bo_search_layoutlookup_mobile= Irm::LookupValue.new(:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:lookup_code=>'LOOKUP_MOBILE',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layoutlookup_mobile.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutlookup_mobile.id,:meaning=>'移动设备查找对话框',:description=>'移动设备查找对话框',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutlookup_mobile.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutlookup_mobile.id,:meaning=>'Lookup Phone Dialogs',:description=>'Lookup Phone Dialogs',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutlookup_mobile.save
    irm_bo_search_layouttab= Irm::LookupValue.new(:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:lookup_code=>'TAB',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layouttab.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layouttab.id,:meaning=>'选项卡列表视图',:description=>'选项卡列表视图',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layouttab.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layouttab.id,:meaning=>'Tab List',:description=>'Tab List',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layouttab.save
    irm_bo_search_layoutlist= Irm::LookupValue.new(:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:lookup_code=>'LIST',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layoutlist.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutlist.id,:meaning=>'列表视图',:description=>'列表视图',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutlist.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutlist.id,:meaning=>'List View',:description=>'List View',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutlist.save
    irm_bo_search_layoutsearch_filter= Irm::LookupValue.new(:lookup_type=>'IRM_BO_SEARCH_LAYOUT',:lookup_code=>'SEARCH_FILTER',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bo_search_layoutsearch_filter.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutsearch_filter.id,:meaning=>'搜索筛选器字段',:description=>'搜索筛选器字段',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutsearch_filter.lookup_values_tls.build(:lookup_value_id=>irm_bo_search_layoutsearch_filter.id,:meaning=>'Search Filter Fields',:description=>'Search Filter Fields',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bo_search_layoutsearch_filter.save
  end

  def down
  end
end
