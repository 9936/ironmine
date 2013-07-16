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
              {:name => :project_id, :classify => [:input], :type => "String", :description => "知识所属项目ID"},
              {:name => :project_name, :classify => [:input], :type => "String", :description => "项目名称，可进行模糊查询"},
              {:name => :author_id, :classify => [:input], :type => "String", :description => "作者ID"},
              {:name => :author_login_name, :classify => [:input], :type => "String", :description => "作者登录名"},
              {:name => :column_id, :classify => [:input], :type => "String", :description => "知识分类ID"},
              {:name => :entry_title, :classify => [:input], :type => "String", :description => "知识文章标题"},
              {:name => :start, :classify => [:input], :type => "Number", :required => "Y", :default_value => 0, :description => "用于分页，从第几条记录开始"},
              {:name => :limit, :classify => [:input], :type => "Number", :required => "Y", :default_value => 10, :description => "每页显示记录数"},
              {:name => :total_rows, :classify => [:output], :type => "Number", :default_value => 0, :description => "记录总数"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "知识记录列表,其中每条记录中包含(id: 知识文章ID,is_favorite：是否被当前用户收藏,entry_status_code: 知识状态,full_title: 完整的文章标题，即[文章编码]+文章标题,entry_title: 文章标题,keyword_tags: 关键字,doc_number: 文章编码,version_number: 版本号,published_date: 发布日期,type_code: 类型编码,author_name: 作者名)"}
          ]
      },

      #获取知识类别接口
      :get_columns => {
          :name => "知识类别接口",
          :description => "知识类别接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :description => "知识类别ID"},
              {:name => :name, :classify => [:output], :type => "String", :description => "知识类别名称"},
              {:name => :description, :classify => [:output], :type => "String", :description => "知识类别描述"},
              {:name => :code, :classify => [:output], :type => "String", :description => "知识类别编码"},
              {:name => :children, :classify => [:output], :type => "Object", :description => "知识类别下的子类别"}
          ]
      },

      #获取知识频道接口
      :get_channels => {
          :name => "知识频道接口",
          :description => "知识频道接口",
          :params => [
              {:name => :start, :classify => [:input], :type => "Number", :required => "Y", :default_value => 0, :description => "用于分页，从第几条记录开始"},
              {:name => :limit, :classify => [:input], :type => "Number", :required => "Y", :default_value => 10, :description => "每页显示记录数"},
              {:name => :total_rows, :classify => [:output], :type => "Number", :default_value => 0, :description => "记录总数"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "频道列表，包括(id: 频道ID,code: 频道编码, name: 频道名称, description: 频道说明"}
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

      #获取知识模板下对应的元素信息
      :get_elements => {
          :name => "模板元素接口",
          :description => "模板元素接口",
          :params => [
              {:name => :template_id, :classify => [:input], :type => "String", :required => "Y", :description => "知识模板ID"},
              {:name => :id, :classify => [:output], :type => "String", :description => "模板元素ID"},
              {:name => :name, :classify => [:output], :type => "String", :description => "模板元素名称"},
              {:name => :description, :classify => [:output], :type => "String", :description => "模板元素描述"},
              {:name => :required, :classify => [:output], :type => "String", :description => "是否必填"},
              {:name => :rows_num, :classify => [:output], :type => "Number", :description => "默认显示行数"},
          ]
      },

      #添加知识文章
      :add => {
          :name => "创建知识接口",
          :description => "创建知识接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :description => "知识文章唯一ID"},
              {:name => :project_id, :classify => [:input, :output], :type => "String", :description => "知识所属项目ID"},
              {:name => :project_name, :classify => [:input, :output], :type => "String", :description => "知识所属项目名称"},
              {:name => :entry_template_id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章模板ID"},
              {:name => :entry_title, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章标题"},
              {:name => :keyword_tags, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章关键字"},
              {:name => :channel_id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章频道"},
              {:name => :details,:classify => [:input], :type => "Object",:example_value => '', :required => "Y", :description => "知识文章段落列表，数组每个元素包括{:entry_template_element_id => 模板元素ID, :element_name => 段落标题, :entry_content => 段落内容}"},
              {:name => :details,:classify => [:output], :type => "Object", :description => "知识文章段落列表，数组每个元素包括{:element_id => 元素ID， :entry_template_element_id => 模板元素ID, :element_name => 段落标题, :entry_content => 段落内容}"},
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
              {:name => :author_name, :classify => [:output], :type => "String", :description => "知识文章作者"},
              {:name => :author_login_name, :classify => [:output], :type => "String", :description => "知识文章作者登录名"}
          ],
      },

      #添加知识文章
      :update => {
          :name => "更新知识接口",
          :description => "更新知识接口",
          :params => [
              {:name => :id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章唯一ID"},
              {:name => :new_version_flag, :classify => [:input], :type => "String", :default_value => "N", :description => "是否保存为新版不，可选值['Y','N'],默认为‘N’"},
              {:name => :project_id, :classify => [:input, :output], :type => "String", :description => "知识所属项目ID"},
              {:name => :project_name, :classify => [:input, :output], :type => "String", :description => "知识所属项目ID"},
              {:name => :entry_template_id, :classify => [:output], :type => "String", :required => "Y", :description => "知识文章模板ID"},
              {:name => :entry_title, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章标题"},
              {:name => :keyword_tags, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章关键字"},
              {:name => :channel_id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识文章频道"},
              {:name => :details,:classify => [:input], :type => "Object",:example_value => '', :required => "Y", :description => "知识文章段落列表，数组每个元素包括{:entry_template_element_id => 模板元素ID, :element_name => 段落标题, :entry_content => 段落内容}"},
              {:name => :details,:classify => [:output], :type => "Object", :description => "知识文章段落列表，数组每个元素包括{:element_id => 元素ID， :entry_template_element_id => 模板元素ID, :element_name => 段落标题, :entry_content => 段落内容}"},
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
              {:name => :author_name, :classify => [:output], :type => "String", :description => "知识文章作者"},
              {:name => :author_login_name, :classify => [:output], :type => "String", :description => "知识文章作者登录名"}
          ],
      },

      #查看知识
      :show => {
          :name => "查看知识接口",
          :description => "查看知识接口",
          :params => [
              {:name => :id, :classify => [:input,:output], :type => "String", :required => "Y", :description => "知识文章唯一ID"},
              {:name => :entry_title, :classify => [:output], :type => "String", :description => "知识文章标题"},
              {:name => :project_id, :classify => [:output], :type => "String", :description => "知识所属项目ID"},
              {:name => :project_name, :classify => [:output], :type => "String", :description => "知识所属项目名称"},
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
              {:name => :author_name, :classify => [:output], :type => "String", :description => "知识文章作者"},
              {:name => :author_login_name, :classify => [:output], :type => "String", :description => "知识文章作者登录名"},
              {:name => :details, :classify => [:output], :type => "Object", :description => "知识文章内容，包括{:element_id => 段落ID, :element_name => 段落标题, :entry_content => 段落内容, :entry_template_element_id => 元素模板ID }"}
          ]
      },

      #获取知识频道分类关系数据
      :channel_columns => {
          :name => "知识频道关系接口",
          :description => "知识频道关系接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :description => "ID"},
              {:name => :channel_id, :classify => [:output], :type => "String", :description => "频道ID"},
              {:name => :column_id, :classify => [:output], :type => "String", :description => "分类ID"},
              {:name => :status_code, :classify => [:output], :type => "String", :description => "状态:【ENABLED or DISABLED】"}
          ]
      }
  }

  map.controller "skm/api_entry_books", {
      #获取知识专题列表
      :get_data => {
          :name => "知识专题列表接口",
          :description => "知识专题列表接口",
          :params => [
              {:name => :start, :classify => [:input], :type => "Number", :required => "Y", :default_value => 0, :description => "用于分页，从第几条记录开始"},
              {:name => :limit, :classify => [:input], :type => "Number", :required => "Y", :default_value => 10, :description => "每页显示记录数"},
              {:name => :name, :classify => [:input], :type => "String", :description => "知识专题名称，用户进行模糊查询"},
              {:name => :project_id, :classify => [:input], :type => "String", :description => "项目ID,当其值为-1时查询模板专题"},
              {:name => :project_name, :classify => [:input], :type => "String", :description => "项目名称，可进行模糊查询"},
              {:name => :author_id, :classify => [:input], :type => "String", :description => "作者ID"},
              {:name => :author_login_name, :classify => [:input], :type => "String", :description => "作者登录名"},
              {:name => :column_id, :classify => [:input], :type => "String", :description => "专题类别ID"},
              {:name => :total_rows, :classify => [:output], :type => "Number", :default_value => 0, :description => "记录总数"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "知识专题列表，包括(id: 专题ID, name: 专题名称, description: 专题说明, updated_at: 专题更新时间， author_name: 作者名"}
          ]
      },

      #获取模板专题结构数据
      :get_relations => {
          :name => "知识专题模板结构数据接口",
          :description => "知识专题模板结构数据接口",
          :params => [
              {:name => :id, :classify => [:output], :type => "String", :description => "ID"},
              {:name => :book_id, :classify => [:output], :type => "String", :description => "专题ID"},
              {:name => :relation_type, :classify => [:output], :type => "String", :description => "关系类别(ENTRYBOOK，ENTRYHEADER)"},
              {:name => :target_id, :classify => [:output], :type => "String", :description => "目标对象ID（专题ID或者知识ID）"},
              {:name => :display_name, :classify => [:output], :type => "String", :description => "在专题中的显示名称"},
              {:name => :display_sequence, :classify => [:output], :type => "String", :description => "在专题中的显示顺序，从小到大（数字不一定连续）"},
              {:name => :doc_number, :classify => [:output], :type => "String", :description => "知识文章的文档号，专题类型的为-1"},
              {:name => :published_date, :classify => [:output], :type => "String", :description => "知识文章的发布日期，若为专题则为专题的创建日期"},
              {:name => :author_name, :classify => [:output], :type => "String", :description => "知识或者专题的作者名"}
          ]
      },

      ##获取知识专题列表
      #:get_template_data => {
      #    :name => "知识专题模板列表接口",
      #    :description => "知识专题模板列表接口",
      #    :params => [
      #        {:name => :start, :classify => [:input], :type => "Number", :required => "Y", :default_value => 0, :description => "用于分页，从第几条记录开始"},
      #        {:name => :limit, :classify => [:input], :type => "Number", :required => "Y", :default_value => 10, :description => "每页显示记录数"},
      #        {:name => :name, :classify => [:input], :type => "String", :description => "知识专题名称，用户进行模糊查询"},
      #        {:name => :author_id, :classify => [:input], :type => "String", :description => "作者ID"},
      #        {:name => :author_login_name, :classify => [:input], :type => "String", :description => "作者登录名"},
      #        {:name => :column_id, :classify => [:input], :type => "String", :description => "专题类别ID"},
      #        {:name => :total_rows, :classify => [:output], :type => "Number", :default_value => 0, :description => "记录总数"},
      #        {:name => :items, :classify => [:output], :type => "Object", :description => "知识专题列表，包括(id: 专题ID, name: 专题名称, description: 专题说明, updated_at: 专题更新时间， author_name: 作者名"}
      #    ]
      #},

      #获取知识专题下的知识和知识专题
      :show => {
          :name => "查看知识专题接口",
          :description => "查看知识专题接口",
          :params => [
              {:name => :id, :classify => [:input,:output], :type => "String", :required => "Y", :description => "知识专题唯一ID"},
              {:name => :name, :classify => [:output], :type => "String", :description => "知识专题名称"},
              {:name => :project_id, :classify => [:output], :type => "String", :description => "项目ID"},
              {:name => :project_name, :classify => [:output], :type => "String", :description => "项目名称，可进行模糊查询"},
              {:name => :author_id, :classify => [:output], :type => "String", :description => "作者ID"},
              {:name => :author_login_name, :classify => [:output], :type => "String", :description => "作者登录名"},
              {:name => :author_name, :classify => [:output], :type => "String", :description => "作者名"},
              {:name => :channel_id, :classify => [:output], :type => "String", :description => "专题频道ID"},
              {:name => :description, :classify => [:output], :type => "String", :description => "知识专题描述"},
              {:name => :updated_at, :classify => [:output], :type => "String", :description => "知识专题最新修改日期"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "知识专题下的知识或子专题，包括(类型:【专题OR文章】, display_name: 章节标题, title: 标题, published_date:发布日期(限知识文章),created_at： 创建时间，updated_at: 更新时间, doc_number: 文档编码（限知识文章）,author_name: 作者名"}
          ]
      },

      #添加专题
      :add => {
          :name => "创建知识专题接口",
          :description => "创建知识专题接口",
          :params => [
            {:name => :id, :classify => [:output], :type => "String",:description => "知识专题唯一ID"},
            {:name => :name, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识专题名称"},
            {:name => :project_id, :classify => [:input,:output], :type => "String", :description => "项目ID"},
            {:name => :project_name, :classify => [:input,:output], :type => "String", :description => "项目名称"},
            {:name => :author_id, :classify => [:output], :type => "String", :description => "作者ID"},
            {:name => :author_login_name, :classify => [:output], :type => "String", :description => "作者登录名"},
            {:name => :author_name, :classify => [:output], :type => "String", :description => "作者名"},
            {:name => :channel_id, :classify => [:input,:output], :type => "String", :description => "专题频道ID"},
            {:name => :description, :classify => [:input,:output], :type => "String", :description => "知识专题描述"},
            {:name => :updated_at, :classify => [:output], :type => "String", :description => "知识专题最新修改日期"},
            {:name => :items, :classify => [:output], :type => "Object", :description => "知识专题下的知识或子专题，包括(类型:【专题OR文章】, display_name: 章节标题, title: 标题, published_date:发布日期(限知识文章),created_at： 创建时间，updated_at: 更新时间, doc_number: 文档编码（限知识文章）,author_name: 作者名"}
          ]
      },

      #编辑专题
      :update => {
          :name => "编辑知识专题接口",
          :description => "编辑知识专题接口",
          :params => [
              {:name => :id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "知识专题唯一ID"},
              {:name => :name, :classify => [:input, :output], :type => "String", :description => "知识专题名称"},
              {:name => :project_id, :classify => [:input,:output], :type => "String", :description => "项目ID"},
              {:name => :project_name, :classify => [:input,:output], :type => "String", :description => "项目名称"},
              {:name => :author_id, :classify => [:output], :type => "String", :description => "作者ID"},
              {:name => :author_login_name, :classify => [:output], :type => "String", :description => "作者登录名"},
              {:name => :author_name, :classify => [:output], :type => "String", :description => "作者名"},
              {:name => :channel_id, :classify => [:input,:output], :type => "String", :description => "专题频道ID"},
              {:name => :description, :classify => [:input,:output], :type => "String", :description => "知识专题描述"},
              {:name => :items, :classify => [:input], :type => "Object", :description => "知识专题下的知识或子专题，对象数组包括(id：对象ID， relation_type: 类型【专题OR文章】值为ENTRYHEADER or ENTRYBOOK，display_name: 显示名称)"},
              {:name => :updated_at, :classify => [:output], :type => "String", :description => "知识专题最新修改日期"},
              {:name => :items, :classify => [:output], :type => "Object", :description => "知识专题下的知识或子专题，包括(类型:【专题OR文章】, display_name: 章节标题, title: 标题, published_date:发布日期(限知识文章),created_at： 创建时间，updated_at: 更新时间, doc_number: 文档编码（限知识文章）,author_name: 作者名"},
          ]
      }
  }
end