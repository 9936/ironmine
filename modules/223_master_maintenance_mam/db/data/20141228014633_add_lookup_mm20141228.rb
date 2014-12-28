class AddLookupMm20141228 < ActiveRecord::Migration
  def up
    lt =Irm::LookupType.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_level=>'GLOBAL',:lookup_type=>'MAM_UR_RESPONSIBILITY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type_id=> lt.id,:meaning=>'MAM_UR_RESPONSIBILITY',:description=>'MAM_UR_RESPONSIBILITY',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type_id=> lt.id,:meaning=>'MAM_UR_RESPONSIBILITY',:description=>'MAM_UR_RESPONSIBILITY',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_ISTORE_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: iStore Management',:description=>'XC: iStore Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: iStore Management',:description=>'XC: iStore Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_SUPPLIER_SCHEDULING_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Supplier Scheduling Management',:description=>'XC: Supplier Scheduling Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Supplier Scheduling Management',:description=>'XC: Supplier Scheduling Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_ISUPPLIER_PORTAL_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: iSupplier Portal Management',:description=>'XC: iSupplier Portal Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: iSupplier Portal Management',:description=>'XC: iSupplier Portal Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_CONFIGURATOR_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Configurator Management',:description=>'XC: Configurator Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Configurator Management',:description=>'XC: Configurator Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_CAPACITY_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Capacity Management',:description=>'XC: Capacity Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Capacity Management',:description=>'XC: Capacity Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_INSTALL_BASE_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Install Base Management',:description=>'XC: Install Base Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Install Base Management',:description=>'XC: Install Base Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_FILE_UPLOAD',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: File Upload',:description=>'XC: File Upload',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: File Upload',:description=>'XC: File Upload',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_HRMS_UPDATE_US',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC_HRMS_Update_US',:description=>'XC_HRMS_Update_US',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC_HRMS_Update_US',:description=>'XC_HRMS_Update_US',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_SOURCING_MGMT_',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Sourcing Management ',:description=>'XC: Sourcing Management ',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Sourcing Management ',:description=>'XC: Sourcing Management ',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_OM_MASTER_MGMT_RELASE_HOLD',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: OM Master Management Relase Hold',:description=>'XC: OM Master Management Relase Hold',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: OM Master Management Relase Hold',:description=>'XC: OM Master Management Relase Hold',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_ORDER_INFORMATION_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Information Viewer',:description=>'XC: Order Information Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Information Viewer',:description=>'XC: Order Information Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_WAREHOUSE_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Warehouse Management',:description=>'XC: Warehouse Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Warehouse Management',:description=>'XC: Warehouse Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_INSPECTION_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inspection Management',:description=>'XC: Inspection Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inspection Management',:description=>'XC: Inspection Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_SHIPPING_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Shipping Management',:description=>'XC: Shipping Management',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Shipping Management',:description=>'XC: Shipping Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_ORDER_MGMT_FOR_CREDIT_MGMT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Management for Credit Mgmt',:description=>'XC: Order Management for Credit Mgmt',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Management for Credit Mgmt',:description=>'XC: Order Management for Credit Mgmt',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_REQUISITION_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Requisition User',:description=>'XC: Requisition User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Requisition User',:description=>'XC: Requisition User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_PO_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing User',:description=>'XC: Purchasing User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing User',:description=>'XC: Purchasing User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_PO_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing Viewer',:description=>'XC: Purchasing Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing Viewer',:description=>'XC: Purchasing Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_PO_SUPERUSER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing Superuser',:description=>'XC: Purchasing Superuser',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing Superuser',:description=>'XC: Purchasing Superuser',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_PO_APPROVAL_SETUP',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing Approval Setup',:description=>'XC: Purchasing Approval Setup',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Purchasing Approval Setup',:description=>'XC: Purchasing Approval Setup',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_PLANNING_FORECAST_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Planning Forecast User',:description=>'XC: Planning Forecast User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Planning Forecast User',:description=>'XC: Planning Forecast User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_PLANNING_SUPERUSER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Planning Superuser',:description=>'XC: Planning Superuser',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Planning Superuser',:description=>'XC: Planning Superuser',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_OM_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Management User',:description=>'XC: Order Management User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Management User',:description=>'XC: Order Management User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_OM_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Management Viewer',:description=>'XC: Order Management Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Order Management Viewer',:description=>'XC: Order Management Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_INV_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inventory User',:description=>'XC: Inventory User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inventory User',:description=>'XC: Inventory User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_INV_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inventory Viewer',:description=>'XC: Inventory Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inventory Viewer',:description=>'XC: Inventory Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_INV_SUPERUSER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inventory Superuser',:description=>'XC: Inventory Superuser',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Inventory Superuser',:description=>'XC: Inventory Superuser',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_QUALITY_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Quality User',:description=>'XC: Quality User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Quality User',:description=>'XC: Quality User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_WIP_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Work in Process User',:description=>'XC: Work in Process User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Work in Process User',:description=>'XC: Work in Process User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_WIP_SUPERUSER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Work in Process Superuser',:description=>'XC: Work in Process Superuser',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Work in Process Superuser',:description=>'XC: Work in Process Superuser',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_BOM_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Bill of Material Viewer',:description=>'XC: Bill of Material Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Bill of Material Viewer',:description=>'XC: Bill of Material Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_BOM_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Bill of Material User',:description=>'XC: Bill of Material User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Bill of Material User',:description=>'XC: Bill of Material User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_AP_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Payables User',:description=>'XC: Payables User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Payables User',:description=>'XC: Payables User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_AP_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Payables Viewer',:description=>'XC: Payables Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Payables Viewer',:description=>'XC: Payables Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_AP_MASTER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Payables Master',:description=>'XC: Payables Master',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Payables Master',:description=>'XC: Payables Master',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_AR_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Receivables User',:description=>'XC: Receivables User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Receivables User',:description=>'XC: Receivables User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_AR_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Receivables Viewer',:description=>'XC: Receivables Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Receivables Viewer',:description=>'XC: Receivables Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_AR_MASTER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Receivables Master',:description=>'XC: Receivables Master',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Receivables Master',:description=>'XC: Receivables Master',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_CASH_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Cash User',:description=>'XC: Cash User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Cash User',:description=>'XC: Cash User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_GL_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: General Ledger User',:description=>'XC: General Ledger User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: General Ledger User',:description=>'XC: General Ledger User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_GL_SUPERUSER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: General Ledger Superuser',:description=>'XC: General Ledger Superuser',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: General Ledger Superuser',:description=>'XC: General Ledger Superuser',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_GL_USER_(DIVA)',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: General Ledger User (DIVA)',:description=>'XC: General Ledger User (DIVA)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: General Ledger User (DIVA)',:description=>'XC: General Ledger User (DIVA)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_FA_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Fixed Asset User',:description=>'XC: Fixed Asset User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Fixed Asset User',:description=>'XC: Fixed Asset User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_COST_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Cost User',:description=>'XC: Cost User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Cost User',:description=>'XC: Cost User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_COST_VIEWER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Cost Viewer',:description=>'XC: Cost Viewer',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Cost Viewer',:description=>'XC: Cost Viewer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_ARGR_ISTORE_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Argriculture iStore User',:description=>'XC: Argriculture iStore User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Argriculture iStore User',:description=>'XC: Argriculture iStore User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_IND_ISTORE_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Industrial iStore User',:description=>'XC: Industrial iStore User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Industrial iStore User',:description=>'XC: Industrial iStore User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_ENERGY_SYSTEM_ISTORE_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Energy System iStore User',:description=>'XC: Energy System iStore User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Energy System iStore User',:description=>'XC: Energy System iStore User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_MARI_ISTORE_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Marine iStore User',:description=>'XC: Marine iStore User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Marine iStore User',:description=>'XC: Marine iStore User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_type=>'MAM_UR_RESPONSIBILITY',:lookup_code=>'XC_CONS_ISTORE_USER',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Construction iStore User',:description=>'XC: Construction iStore User',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:opu_id => '001n00012i8IyyjJakd6Om', :lookup_value_id=> lv.id,:meaning=>'XC: Construction iStore User',:description=>'XC: Construction iStore User',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

  end

  def down
  end
end
