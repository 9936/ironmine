#-*- coding: utf-8 -*-
Fwk::ApiParamsManager.map do |map|
  map.controller "icm/api_incident_requests", {
    #创建事故单
    :add => {
        :name => "创建事故单接口",
        :description => "创建事故单接口",
        :update_flag => 'Y',
        :params => [
            {:name => :id, :classify => [:output], :type => "String", :description => "事故单ID"},
            {:name => :requested_by, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "请求人ID"},
            {:name => :external_system_id, :classify => [:input, :output], :required => 'Y',  :type => "String", :description => "系统ID"},
            {:name => :incident_category_id, :classify => [:input, :output], :type => "String", :description => "分类ID"},
            {:name => :incident_sub_category_id, :classify => [:input, :output], :type => "String", :description => "子分类ID"},
            {:name => :estimated_date, :classify => [:input, :output], :type => "String", :description => "计划完成日期"},
            {:name => :title, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "主题"},
            {:name => :summary, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "内容"},
            {:name => :contact_id, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "联系人ID"},
            {:name => :urgence_id, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "紧急度ID"},
            {:name => :impact_range_id, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "影响度ID"},
            {:name => :report_source_code, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "来源类型编码"},
            {:name => :incident_status_id, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "事故单状态ID"},
            {:name => :request_type_code, :classify => [:input, :output], :required => 'Y', :type => "String", :description => "请求类型编码"},
        ]
     }
  }
end