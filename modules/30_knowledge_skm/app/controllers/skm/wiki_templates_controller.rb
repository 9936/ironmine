class Skm::WikiTemplatesController < ApplicationController
  layout "application_full"
  # GET /skm/wiki_templates
  # GET /skm/wiki_templates.xml
  def index
    @wiki_templates = Skm::WikiTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @wiki_templates }
    end
  end

  # GET /skm/wiki_templates/1
  # GET /skm/wiki_templates/1.xml
  def show
    @wiki_template = Skm::WikiTemplate.find(params[:id])
    @preview = Ironmine::WIKI.preview_page(@wiki_template.name, @wiki_template.content, @wiki_template.content_format)
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @wiki_template }
    end
  end

  # GET /skm/wiki_templates/new
  # GET /skm/wiki_templates/new.xml
  def new
    @wiki_template = Skm::WikiTemplate.new(:content_format => 'markdown')

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @wiki_template }
    end
  end

  # GET /skm/wiki_templates/1/edit
  def edit
    @wiki_template = Skm::WikiTemplate.find(params[:id])
  end

  # POST /skm/wiki_templates
  # POST /skm/wiki_templates.xml
  def create
    @wiki_template = Skm::WikiTemplate.new(params[:skm_wiki_template])

    respond_to do |format|
      if @wiki_template.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @wiki_template, :status => :created, :location => @wiki_template }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @wiki_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skm/wiki_templates/1
  # PUT /skm/wiki_templates/1.xml
  def update
    @wiki_template = Skm::WikiTemplate.find(params[:id])

    respond_to do |format|
      if @wiki_template.update_attributes(params[:skm_wiki_template])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @wiki_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skm/wiki_templates/1
  # DELETE /skm/wiki_templates/1.xml
  def destroy
    @wiki_template = Skm::WikiTemplate.find(params[:id])
    @wiki_template.destroy

    respond_to do |format|
      format.html { redirect_to(skm_wiki_templates_url) }
      format.xml { head :ok }
    end
  end

  def multilingual_edit
    @wiki_template = Skm::WikiTemplate.find(params[:id])
  end

  def get_data
    skm_wiki_templates_scope = Skm::WikiTemplate.where("1=1")
    skm_wiki_templates_scope = skm_wiki_templates_scope.match_value("#{Skm::WikiTemplate.table_name}.name", params[:name])
    skm_wiki_templates, count = paginate(skm_wiki_templates_scope)
    respond_to do |format|
      format.html {
        @count = count
        @datas = skm_wiki_templates
      }
      format.json { render :json => to_jsonp(skm_wiki_templates.to_grid_json([:name, :description, :status_meaning], count)) }
    end
  end


  def preview
    @wiki_template = Skm::WikiTemplate.new(params[:skm_wiki_template])
    @preview = Ironmine::WIKI.preview_page(@wiki_template.name, @wiki_template.content, @wiki_template.content_format)

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @wiki_template }
    end
  end

  def sample
    @wiki_template = Skm::WikiTemplate.find(params[:id])
    @preview = Ironmine::WIKI.preview_page(@wiki_template.name, @wiki_template.content, @wiki_template.content_format)
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @wiki_template }
    end
  end
end
