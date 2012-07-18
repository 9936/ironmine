class Skm::WikisController < ApplicationController
  layout "bootstrap_application_full"

  # GET /irm/wikis
  # GET /irm/wikis.xml
  def index
    @wikis = Skm::Wiki.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wikis }
    end
  end

  # GET /irm/wikis/1
  # GET /irm/wikis/1.xml
  def show
    @wiki = Skm::Wiki.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  # GET /irm/wikis/new
  # GET /irm/wikis/new.xml
  def new
    @wiki = Skm::Wiki.new(:content_format=>'markdown')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  # GET /irm/wikis/1/edit
  def edit
    @wiki = Skm::Wiki.find(params[:id])
    @wiki.content =  @wiki.page.raw_data.force_encoding('utf-8')
  end

  # POST /irm/wikis
  # POST /irm/wikis.xml
  def create
    @wiki = Skm::Wiki.new(params[:skm_wiki])

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/wikis/1
  # PUT /irm/wikis/1.xml
  def update
    @wiki = Skm::Wiki.find(params[:id])

    respond_to do |format|
      if @wiki.update_attributes(params[:skm_wiki])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /irm/wikis/1
  # DELETE /irm/wikis/1.xml
  def destroy
    @wiki = Skm::Wiki.find(params[:id])
    @wiki.destroy

    respond_to do |format|
      format.html { redirect_to(irm_wikis_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def get_data
    irm_wikis_scope = Skm::Wiki.where("1=1")
    irm_wikis_scope = irm_wikis_scope.match_value("#{Skm::Wiki.table_name}.name",params[:name])
    irm_wikis,count = paginate(irm_wikis_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(irm_wikis.to_grid_json([:name,:description,:content], count)) }
      format.html  {
        @count = count
        @datas = irm_wikis
      }
    end
  end


  def history
    @wiki = Skm::Wiki.find(params[:id])
    versions = @wiki.versions
    @datas = []
    person_login_names = versions.collect{|v| v.author.name}
    persons = Irm::Person.select_all.where("login_name in (?)",person_login_names)

    versions.each do |v|
      vh = {:id=>v.id,:person=>persons.detect{|i| i.login_name.eql?(v.author.name)},:short_message=>v.patch_id,:message=>v.message.force_encoding('utf-8') ,:created_at => v.authored_date}
      @datas << vh
    end
    @count = @datas.length
  end

  def compare
    @wiki = Skm::Wiki.find(params[:id])
    #　version info
    version_ids = params[:versions]
    versions = @wiki.versions.collect{|i| i if params[:versions].include?(i.id)}.compact
    @version_datas = []
    person_login_names = versions.collect{|v| v.author.name}
    persons = Irm::Person.select_all.where("login_name in (?)",person_login_names)

    versions.each do |v|
      vh = {:id=>v.id,:person=>persons.detect{|i| i.login_name.eql?(v.author.name)},:message=>v.message.force_encoding('utf-8'),:created_at => v.authored_date}
      @version_datas << vh
    end

    page = @wiki.page
    diffs = Ironmine::WIKI.repo.diff(params[:versions][1], params[:versions][0], page.path)
    diff = diffs.first
    @lines = []
    @left_diff_line_number = nil
    @right_diff_line_number = nil
    diff.diff.split("\n")[2..-1].each_with_index do |line, line_index|
      @lines << { :line  => line.force_encoding('utf-8'),
                 :class => line_class(line),
                 :ldln  => left_diff_line_number(0, line),
                 :rdln  => right_diff_line_number(0, line) }
    end if diff
  end


  def revert
    @wiki = Skm::Wiki.find(params[:id])
    #　version info
    version_ids = params[:versions]
    versions = @wiki.versions.collect{|i| i if params[:versions].include?(i.id)}.compact


    commit_message = t(:label_irm_wiki_revert_message,:from=>versions[1].authored_date.strftime('%Y-%m-%d %H:%M:%S'),:to=>versions[0].authored_date.strftime('%Y-%m-%d %H:%M:%S'))
    commit = {:message=>commit_message,:name=>Irm::Person.current.login_name,:email=>Irm::Person.current.email_address}
    Ironmine::WIKI.revert_page(@wiki.page, params[:versions][1], params[:versions][0], commit)
    redirect_back_or_default({:action=>"history"})
  end

  def preview
    @wiki = Skm::Wiki.new(params[:skm_wiki])
    @preview = Ironmine::WIKI.preview_page(@wiki.name, @wiki.content, @wiki.content_format)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  private
  def line_class(line)
    if line =~ /^@@/
      'gc'
    elsif line =~ /^\+/
      'gi'
    elsif line =~ /^\-/
      'gd'
    else
      ''
    end
  end

  def left_diff_line_number(id, line)
    if line =~ /^@@/
      m, li = *line.match(/\-(\d+)/)
      @left_diff_line_number = li.to_i
      @current_line_number = @left_diff_line_number
      ret = '...'
    elsif line[0] == ?-
      ret = @left_diff_line_number.to_s
      @left_diff_line_number += 1
      @current_line_number = @left_diff_line_number - 1
    elsif line[0] == ?+
      ret = ' '
    else
      ret = @left_diff_line_number.to_s
      @left_diff_line_number += 1
      @current_line_number = @left_diff_line_number - 1
    end
    ret
  end

  def right_diff_line_number(id, line)
    if line =~ /^@@/
      m, ri = *line.match(/\+(\d+)/)
      @right_diff_line_number = ri.to_i
      @current_line_number = @right_diff_line_number
      ret = '...'
    elsif line[0] == ?-
      ret = ' '
    elsif line[0] == ?+
      ret = @right_diff_line_number.to_s
      @right_diff_line_number += 1
      @current_line_number = @right_diff_line_number - 1
    else
      ret = @right_diff_line_number.to_s
      @right_diff_line_number += 1
      @current_line_number = @right_diff_line_number - 1
    end
    ret
  end
end
