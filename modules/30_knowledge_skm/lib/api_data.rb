#-*- coding: utf-8 -*-
Fwk::ApiParamsManager.map do |map|
  map.controller "skm/api_entry_headers", {
      #获取知识列表
      :get_data => {
          :name => "知识列表接口",
          :description => "知识列表接口",
          :params => [
              {:name => :full_search, :classify => [:input], :type => "String", :description => "全文检索，指明此参数，可检索出于关键字相关的知识文章"},
              {:name => :doc_number, :classify => [:input], :type => "String", :description => "知识文章编码"},
              {:name => :entry_title, :classify => [:input], :type => "String", :description => "知识文章标题"},
              {:name => :start, :classify => [:input], :type => "Number", :required => "Y", :default_value => 0, :description => "用于分页，从第几条记录开始"},
              {:name => :limit, :classify => [:input], :type => "Number", :required => "Y", :default_value => 10, :description => "每页显示记录数"},
              {:name => :total_rows, :classify => [:output], :type => "Number", :default_value => 0, :description => "记录总数"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "知识记录列表,其中每条记录中包含(id: 知识文章ID,is_favorite：是否被当前用户收藏,entry_status_code: 知识状态,full_title: 完整的文章标题，即[文章编码]+文章标题,entry_title: 文章标题,keyword_tags: 关键字,doc_number: 文章编码,version_number: 版本号,published_date: 发布日期,type_code: 类型编码)"}
          ]
      },

      #获取知识类别接口
      :get_channels => {
          :name => "知识频道接口",
          :description => "知识频道接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :description => "知识类别ID"},
              {:name => :name, :classify => [:output], :type => "String", :description => "知识类别名称"},
              {:name => :description, :classify => [:output], :type => "String", :description => "知识类别描述"},
              {:name => :code, :classify => [:output], :type => "String", :description => "知识类别编码"},
              {:name => :children, :classify => [:output], :type => "Object", :description => "知识类别下的子类别"}
          ]
      },

      #获取知识模板列表
      :get_template_data => {
          :name => "知识模板接口",
          :description => "知识模板接口",
          :params => [
              {:name => :start, :classify => [:input], :type => "Number", :required => "Y", :default_value => 0, :description => "用于分页，从第几条记录开始"},
              {:name => :limit, :classify => [:input], :type => "Number", :required => "Y", :default_value => 10, :description => "每页显示记录数"},
              {:name => :total_rows, :classify => [:output], :type => "Number", :default_value => 0, :description => "记录总数"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "模板列表，包括(id: 模板ID,entry_template_code: 模板编码,name: 模板名称,description: 模板说明"}
          ]
      },

      :add => {
          :name => "创建知识接口",
          :description => "创建知识接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :description => "知识文章唯一ID"},
              {:name => :entry_template_id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章模板ID"},
              {:name => :entry_title, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章标题"},
              {:name => :keyword_tags, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章关键字"},
              {:name => :channel_id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章频道"},
              {:name => :content,:classify => [:input,:output], :type => "Object",:example_value => '{"contents:"[{"element_id_1:" "Please write content1 here" }, {"element_id_2:" "Please write content2 here" }, ... , {"element_N:", "Please write contentN here"}]', :required => "Y", :description => "知识库内容"}
          ],
      },
      :show => {
          :name => "查看知识接口",
          :description => "查看知识接口",
          :params => [
              {:name => :id, :classify => [:input,:output], :type => "String", :required => "Y", :description => "知识文章唯一ID"},
              {:name => :entry_title, :classify => [:output], :type => "String", :description => "知识文章标题"},
              {:name => :keyword_tags, :classify => [:output], :type => "String", :description => "知识文章关键字"},
              {:name => :doc_number, :classify => [:output], :type => "String", :description => "知识文章文档号"},
              {:name => :history_flag, :classify => [:output], :type => "String", :description => "知识文章历史标记('Y'表示历史版本，'N'表示最新版本)"},
              {:name => :entry_status_code, :classify => [:output], :type => "String", :description => "知识文章当前状态('PUBLISHED'表示已发布,'WAIT_APPROVE'表示等待审批)"},
              {:name => :version_number, :classify => [:output], :type => "String", :description => "知识文章版本号"},
              {:name => :published_date, :classify => [:output], :type => "Datetime", :description => "知识文章发布日期"},
              {:name => :type_code, :classify => [:output], :type => "String", :description => "知识文章类型（‘ARTICLE’,表示文本知识,'VIDEO'表示视频知识）"},
              {:name => :created_at, :classify => [:output], :type => "Datetime", :description => "知识文章创建日期"},
              {:name => :created_by, :classify => [:output], :type => "String", :description => "知识文章创建人ID"},
              {:name => :updated_at, :classify => [:output], :type => "Datetime", :description => "知识文章更新日期"},
              {:name => :updated_by, :classify => [:output], :type => "String", :description => "知识文章更新人ID"},
              {:name => :author_id, :classify => [:output], :type => "String", :description => "知识文章作者ID"},
              {:name => :channel_id, :classify => [:output], :type => "String", :description => "知识文章频道ID"},
              {:name => :entry_template_id, :classify => [:output], :type => "String", :description => "知识文章模板ID"},
              {:name => :details, :classify => [:output], :type => "Object", :description => "知识文章内容，包括{:element_id => 段落ID, :element_name => 段落标题, :entry_content => 段落内容}"},
          ]
      }
  }
end