class Skm::WikisController < ApplicationController
  layout "bootstrap_application_full"

  # GET /irm/wikis
  # GET /irm/wikis.xml
  def index
    @wikis = Skm::Wiki.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @wikis }
    end
  end

  # GET /irm/wikis/1
  # GET /irm/wikis/1.xml
  def show
    @wiki = Skm::Wiki.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @wiki }
      format.pdf {
        pdf_path = Skm::WikiToStatic.instance.wiki_to_static(@wiki,:pdf)
        send_file pdf_path, :filename=>"#{@wiki.name}.pdf",:type => 'application/pdf', :disposition => 'inline'
      }
      #format.pdf {
      #  render :pdf => "#{@wiki.name}",
      #         :print_media_type => false,
      #         :encoding => 'utf-8',
      #         :layout => "layouts/markdown_pdf.html.erb",
      #         :show_as_html=>true,
      #         :book => true,
      #         :page_size => 'A4',
      #         :toc => {:header_text => t(:label_skm_wiki_table_of_content), :disable_back_links => true}
      #}
    end
  end

  # GET /irm/wikis/new
  # GET /irm/wikis/new.xml
  def new
    @wiki = Skm::Wiki.new(:content_format => 'markdown')

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @wiki }
    end
  end

  # GET /irm/wikis/1/edit
  def edit
    @wiki = Skm::Wiki.find(params[:id])
    @wiki.description=""
    @wiki.content = @wiki.page.raw_data.force_encoding('utf-8')
  end

  # POST /irm/wikis
  # POST /irm/wikis.xml
  def create
    @wiki = Skm::Wiki.new(params[:skm_wiki])

    respond_to do |format|
      if @wiki.save
        process_files(@wiki)
        format.html { redirect_to({:action => "show", :id => @wiki.id}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/wikis/1
  # PUT /irm/wikis/1.xml
  def update
    @wiki = Skm::Wiki.find(params[:id])

    respond_to do |format|
      if @wiki.update_attributes(params[:skm_wiki])
        process_files(@wiki)
        format.html { redirect_to({:action => "show", :id => @wiki.id}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /irm/wikis/1/edit_chapter
  def edit_chapter
    @wiki = Skm::Wiki.find(params[:id])
    @wiki.description= params[:skm_wiki]
    @wiki.content = @wiki.page.raw_data.force_encoding('utf-8')
    if params[:hdata] && params[:hdata].split("#").length == 2
      type, index = params[:hdata].split("#").collect { |i| i.to_i }
      start, final = chapter_content_index(type, index, @wiki.content)
      tmp_content = @wiki.content
      @wiki.content = @wiki.content[start..final]
    end

  end

  def update_chapter
    @wiki = Skm::Wiki.find(params[:id])
    @wiki.description= params[:skm_wiki][:description]
    @wiki.content = @wiki.page.raw_data.force_encoding('utf-8')
    if params[:hdata] && params[:hdata].split("#").length == 2
      type, index = params[:hdata].split("#").collect { |i| i.to_i }
      start, final = chapter_content_index(type, index, @wiki.content)
      tmp_content = @wiki.content
      @wiki.content = params[:skm_wiki][:content]
      if start!=0
        @wiki.content = "\n"+@wiki.content unless ["\n","\r"].include?(@wiki.content[0])
        @wiki.content = tmp_content[0..start-1] + @wiki.content
      end
      if final!=-1
        @wiki.content = @wiki.content+"\n" unless ["\n","\r"].include?(tmp_content[0])||["\n","\r"].include?(@wiki.content[-1])
        @wiki.content = @wiki.content+tmp_content[final+1..-1]
      end


    end
    respond_to do |format|
      if @wiki.save
        process_files(@wiki)
        format.html { redirect_to({:action => "show", :id => @wiki.id}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        @wiki.content = params[:skm_wiki][:content]
        format.html { render :action => "edit_chapter" }
        format.xml { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end


  def new_word
    @wiki = Skm::Wiki.new(:content_format => 'markdown')

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @wiki }
    end
  end

  def create_word
    @wiki = Skm::Wiki.new(params[:skm_wiki])
    @wiki.content = t(:label_skm_wiki_word_content)
    @wiki.description = t(:label_skm_wiki_word_description) unless @wiki.description.present?

    respond_to do |format|
      if params[:files]&&params[:files].any?&&@wiki.save
        files = process_word_files(@wiki)
        if files[0].present?
          Delayed::Job.enqueue(Skm::Jobs::WikiDocJob.new({:wiki_id=>@wiki.id,:attachment_id=>files[0].id}))
        end
        format.html { redirect_to({:action => "show", :id => @wiki.id}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new_word" }
        format.xml { render :xml => @wiki.errors, :status => :unprocessable_entity }
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
      format.xml { head :ok }
    end
  end


  def get_data
    irm_wikis_scope = Skm::Wiki.where("1=1")
    irm_wikis_scope = irm_wikis_scope.match_value("#{Skm::Wiki.table_name}.name", params[:name])
    irm_wikis, count = paginate(irm_wikis_scope)
    respond_to do |format|
      format.json { render :json => to_jsonp(irm_wikis.to_grid_json([:name, :description, :content], count)) }
      format.html {
        @count = count
        @datas = irm_wikis
      }
    end
  end


  def history
    @wiki = Skm::Wiki.find(params[:id])
    versions = @wiki.versions
    @datas = []
    person_login_names = versions.collect { |v| v.author.name }
    persons = Irm::Person.select_all.where("login_name in (?)", person_login_names)

    versions.each do |v|
      vh = {:id => v.id, :person => persons.detect { |i| i.login_name.eql?(v.author.name) }, :short_message => v.patch_id, :message => v.message.force_encoding('utf-8'), :created_at => v.authored_date}
      @datas << vh
    end
    @count = @datas.length
  end

  def compare
    @wiki = Skm::Wiki.find(params[:id])
    #　version info
    version_ids = params[:versions]
    versions = @wiki.versions.collect { |i| i if params[:versions].include?(i.id) }.compact
    @version_datas = []
    person_login_names = versions.collect { |v| v.author.name }
    persons = Irm::Person.select_all.where("login_name in (?)", person_login_names)

    versions.each do |v|
      vh = {:id => v.id, :person => persons.detect { |i| i.login_name.eql?(v.author.name) }, :message => v.message.force_encoding('utf-8'), :created_at => v.authored_date}
      @version_datas << vh
    end

    page = @wiki.page
    diffs = Ironmine::WIKI.repo.diff(params[:versions][1], params[:versions][0], page.path)
    diff = diffs.first
    @lines = []
    @left_diff_line_number = nil
    @right_diff_line_number = nil
    diff.diff.split("\n")[2..-1].each_with_index do |line, line_index|
      @lines << {:line => line.force_encoding('utf-8'),
                 :class => line_class(line),
                 :ldln => left_diff_line_number(0, line),
                 :rdln => right_diff_line_number(0, line)}
    end if diff
  end


  def revert
    @wiki = Skm::Wiki.find(params[:id])
    #　version info
    version_ids = params[:versions]
    versions = @wiki.versions.collect { |i| i if params[:versions].include?(i.id) }.compact


    commit_message = t(:label_irm_wiki_revert_message, :from => versions[1].authored_date.strftime('%Y-%m-%d %H:%M:%S'), :to => versions[0].authored_date.strftime('%Y-%m-%d %H:%M:%S'))
    commit = {:message => commit_message, :name => Irm::Person.current.login_name, :email => Irm::Person.current.email_address}
    Ironmine::WIKI.revert_page(@wiki.page, params[:versions][1], params[:versions][0], commit)
    redirect_back_or_default({:action => "history"})
  end

  def preview
    if params[:skm_wiki][:id]
      @wiki = Skm::Wiki.find(params[:skm_wiki][:id])
      @wiki.attributes = params[:skm_wiki]
    else
      @wiki = Skm::Wiki.new(params[:skm_wiki])
    end
    preview = Ironmine::WIKI.preview_page(@wiki.name, @wiki.content, @wiki.content_format)
    @wiki.page = preview

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @wiki }
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

  def process_files(ref)
    @files = []
    params[:files].each do |key, value|
      if value[:file].present?
        @files << Irm::AttachmentVersion.create({:source_id => ref.id,
                                                 :source_type => ref.class.name,
                                                 :data => value[:file],
                                                 :description => value[:description]})
      elsif value[:id].present?
        attachment = Irm::AttachmentVersion.where(:id => value[:id]).first
        attachment.update_attributes(:source_id => ref.id,
                                     :source_type => ref.class.name,
                                     :description => value[:description]) if attachment
        @files << attachment
      end
    end if params[:files]
    @files
  end


  def process_word_files(ref)
    @files = []
    params[:files].each do |key, value|
      if value[:file].present?
        @files << Irm::AttachmentVersion.create({:source_id => ref.id,
                                                 :source_type => ref.class.name,
                                                 :data => value[:file],
                                                 :description => value[:description]})
      elsif value[:id].present?
        attachment = Irm::AttachmentVersion.where(:id => value[:id]).first
        attachment.update_attributes(:source_id => ref.id,
                                     :source_type => ref.class.name,
                                     :description => value[:description]) if attachment
        @files << attachment
        if @files.any?
          break
        end
      end
    end if params[:files]
    @files
  end

  def chapter_content_index(type, index, content)
    results = []
    1.upto type do |i|
      start = 0
      loop do
        num = content.index(/[\n\r]?(^\#{#{i}}[^#\n\r]*)$[\n\r]?/, start)
        break if !num.present?
        results << {:position => num, :type => i}
        start = num+i+1
      end
    end
    count = 0
    find = 0
    results.sort! { |a, b| a[:position]<=>b[:position] }
    results.each_with_index do |r, i|
      if r[:type] == type
        count = count + 1
        if count == index
          find = i
        end
      end
    end
    if find == results.length-1
      return [results[find][:position], -1]
    else
      return [results[find][:position], results[find+1][:position]-1]
    end

  end
end
