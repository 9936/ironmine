#-*- coding: utf-8 -*-
Fwk::ApiParamsManager.map do |map|
  map.controller "skm/api_entry_headers", {
      :add => {
          :name => "创建知识接口",
          :description => "创建知识接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :required => "Y", :description => "知识文章唯一ID"},
              {:name => :title, :classify => [:input,:output], :type => "String", :example_value => "如何通过API调用创建知识", :default_value => "" ,:required => "Y", :description => "知识库标题"},
              {:name => :content,:classify => [:input,:output], :type => "String", :required => "Y", :description => "知识库内容"}
          ],
      },
      :show => {
          :name => "查看知识接口",
          :description => "查看知识接口",
          :params => [
              {:name => :id, :classify => [:input,:output], :type => "String", :required => "Y", :description => "知识文章唯一ID"}
          ]
      }
  }
end