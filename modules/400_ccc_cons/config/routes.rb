Rails.application.routes.draw do
  scope :module => "cons" do
    # 顾问
    match '/consultants(/index)(.:format)' => "consultants#index", :via => :get
    match '/consultants/new(.:format)' => "consultants#new", :via => :get
    match '/consultants/create(.:format)' => "consultants#create", :via => [:post,:put]
    match '/consultants/get_data(.:format)' => "consultants#get_data"
    match '/consultants/:id/show(.:format)' => "consultants#show", :via => :get
    match '/consultants/:id/edit(.:format)' => "consultants#edit", :via => :get
    match '/consultants/:id/update(.:format)' => "consultants#update", :via => :put

    # 客户
    match '/customer(/index)(.:format)' => "customer#index", :via => :get
    match '/customer/new(.:format)' => "customer#new", :via => :get
    match '/customer/create(.:format)' => "customer#create", :via => :post
    match '/customer/get_data(.:format)' => "customer#get_data"
    match '/customer/:id/show(.:format)' => "customer#show", :via => :get
    match '/customer/:id/edit(.:format)' => "customer#edit", :via => :get
    match '/customer/:id/update(.:format)' => "customer#update", :via => :put
    match '/customer/searchCustomerNo(.:format)' => "customer#searchCustomerNo"


    # 项目
    match '/product(/index)(.:format)' => "product#index", :via => :get
    match '/product/new(.:format)' => "product#new", :via => :get
    match '/product/create(.:format)' => "product#create", :via => :post
    match '/product/get_data(.:format)' => "product#get_data"
    match '/product/:id/show(.:format)' => "product#show", :via => :get
    match '/product/:id/edit(.:format)' => "product#edit", :via => :get
    match '/product/:id/update(.:format)' => "product#update", :via => :put


    # 公司
    match '/company(/index)(.:format)' => "company#index", :via => :get
    match '/company/new(.:format)' => "company#new", :via => :get
    match '/company/create(.:format)' => "company#create", :via => :post
    match '/company/get_data(.:format)' => "company#get_data"
    match '/company/:id/show(.:format)' => "company#show", :via => :get
    match '/company/:id/edit(.:format)' => "company#edit", :via => :get
    match '/company/:id/update(.:format)' => "company#update", :via => :put
    match '/company/searchCompany(.:format)' => "company#searchCompany"

    # 连接类型
    match '/connect(/index)(.:format)' => "connect#index", :via => :get
    match '/connect/new(.:format)' => "connect#new", :via => :get
    match '/connect/create(.:format)' => "connect#create", :via => :post
    match '/connect/get_data(.:format)' => "connect#get_data"
    match '/connect/:id/show(.:format)' => "connect#show", :via => :get
    match '/connect/:id/edit(.:format)' => "connect#edit", :via => :get
    match '/connect/:id/update(.:format)' => "connect#update", :via => :put

    # 顾问类型
    match '/consType(/index)(.:format)' => "consType#index", :via => :get
    match '/consType/new(.:format)' => "consType#new", :via => :get
    match '/consType/create(.:format)' => "consType#create", :via => :post
    match '/consType/get_data(.:format)' => "consType#get_data"
    match '/consType/:id/show(.:format)' => "consType#show", :via => :get
    match '/consType/:id/edit(.:format)' => "consType#edit", :via => :get
    match '/consType/:id/update(.:format)' => "consType#update", :via => :put

    # 组别
    match '/group(/index)(.:format)' => "group#index", :via => :get
    match '/group/new(.:format)' => "group#new", :via => :get
    match '/group/create(.:format)' => "group#create", :via => :post
    match '/group/get_data(.:format)' => "group#get_data"
    match '/group/:id/show(.:format)' => "group#show", :via => :get
    match '/group/:id/edit(.:format)' => "group#edit", :via => :get
    match '/group/:id/update(.:format)' => "group#update", :via => :put


    # 行业类型
    match '/industry(/index)(.:format)' => "industry#index", :via => :get
    match '/industry/new(.:format)' => "industry#new", :via => :get
    match '/industry/create(.:format)' => "industry#create", :via => :post
    match '/industry/get_data(.:format)' => "industry#get_data"
    match '/industry/:id/show(.:format)' => "industry#show", :via => :get
    match '/industry/:id/edit(.:format)' => "industry#edit", :via => :get
    match '/industry/:id/update(.:format)' => "industry#update", :via => :put


    # Level
    match '/level(/index)(.:format)' => "level#index", :via => :get
    match '/level/new(.:format)' => "level#new", :via => :get
    match '/level/create(.:format)' => "level#create", :via => :post
    match '/level/get_data(.:format)' => "level#get_data"
    match '/level/:id/show(.:format)' => "level#show", :via => :get
    match '/level/:id/edit(.:format)' => "level#edit", :via => :get
    match '/level/:id/update(.:format)' => "level#update", :via => :put

    # 模块
    match '/module(/index)(.:format)' => "module#index", :via => :get
    match '/module/new(.:format)' => "module#new", :via => :get
    match '/module/create(.:format)' => "module#create", :via => :post
    match '/module/get_data(.:format)' => "module#get_data"
    match '/module/:id/show(.:format)' => "module#show", :via => :get
    match '/module/:id/edit(.:format)' => "module#edit", :via => :get
    match '/module/:id/update(.:format)' => "module#update", :via => :put

    # 计价方式
    match '/price(/index)(.:format)' => "price#index", :via => :get
    match '/price/new(.:format)' => "price#new", :via => :get
    match '/price/create(.:format)' => "price#create", :via => :post
    match '/price/get_data(.:format)' => "price#get_data"
    match '/price/:id/show(.:format)' => "price#show", :via => :get
    match '/price/:id/edit(.:format)' => "price#edit", :via => :get
    match '/price/:id/update(.:format)' => "price#update", :via => :put

    # 项目类别
    match '/projectType(/index)(.:format)' => "projectType#index", :via => :get
    match '/projectType/new(.:format)' => "projectType#new", :via => :get
    match '/projectType/create(.:format)' => "projectType#create", :via => :post
    match '/projectType/get_data(.:format)' => "projectType#get_data"
    match '/projectType/:id/show(.:format)' => "projectType#show", :via => :get
    match '/projectType/:id/edit(.:format)' => "projectType#edit", :via => :get
    match '/projectType/:id/update(.:format)' => "projectType#update", :via => :put

    # 客户状态
    match '/status(/index)(.:format)' => "status#index", :via => :get
    match '/status/new(.:format)' => "status#new", :via => :get
    match '/status/create(.:format)' => "status#create", :via => :post
    match '/status/get_data(.:format)' => "status#get_data"
    match '/status/:id/show(.:format)' => "status#show", :via => :get
    match '/status/:id/edit(.:format)' => "status#edit", :via => :get
    match '/status/:id/update(.:format)' => "status#update", :via => :put

  end

end