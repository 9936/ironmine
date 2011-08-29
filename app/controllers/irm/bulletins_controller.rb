class Irm::BulletinsController < ApplicationController
  def new
    @bulletin = Irm::Bulletin.new
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bulletin }
    end
  end

  def create
    @bulletin = Irm::Bulletin.new(params[:irm_bulletin])
    @bulletin.author_id = Irm::Person.current.id
    @bulletin.page_views = 0
    column_ids = params[:irm_bulletin][:column_ids].split(",")
    respond_to do |format|
      if @bulletin.save
        column_ids.each do |c|
          Irm::BulletinColumn.create(:bulletin_id => @bulletin.id, :bu_column_id => c)
        end


        if params[:file]
          files = params[:file]
          #调用方法创建附件
          begin
            attached = Irm::AttachmentVersion.create_verison_files(files, "Irm::Bulletin", @bulletin.id)
          rescue
            @bulletin.errors << "FILE UPLOAD ERROR"
          end
        end
        @bulletin.create_access_from_str
        format.html {
          if(params[:return_url])
            redirect_to params[:return_url]
          else
            redirect_to({:action=>"index"}, :notice =>t(:successfully_created))
          end
          }
        format.xml  { render :xml => @bulletin, :status => :created, :location => @bulletin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bulletin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @bulletin = Irm::Bulletin.find(params[:id])
    @bulletin.column_ids = @bulletin.get_column_ids
  end

  def update
    @bulletin = Irm::Bulletin.find(params[:id])
    column_ids = params[:irm_bulletin][:column_ids].split(",")
    owned_column_ids = @bulletin.get_column_ids.split(",")
    respond_to do |format|
      if @bulletin.update_attributes(params[:irm_bulletin])
        (owned_column_ids - column_ids).each do |c|
          Irm::BulletinColumn.where(:bulletin_id => @bulletin.id, :bu_column_id => c).each do |t|
            t.destroy
          end
        end
        (column_ids - owned_column_ids).each do |c|
          Irm::BulletinColumn.create(:bulletin_id => @bulletin.id, :bu_column_id => c)
        end


        if params[:file]
          files = params[:file]
          #调用方法创建附件
          begin
            attached = Irm::AttachmentVersion.create_verison_files(files, "Irm::Bulletin", @bulletin.id)
          rescue
            @bulletin.errors << "FILE UPLOAD ERROR"
          end
        end
        @bulletin.create_access_from_str
        format.html {
#          if(params[:return_url])
#            redirect_to params[:return_url]
#          else
            render :action => "show", :id => @bulletin
#          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bulletin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @bulletin = Irm::Bulletin.where(:id => params[:id]).first()
    #浏览量统计
    if !session[:bulletins_show] || session[:bulletins_show] != @bulletin.id
      Irm::Bulletin.update(@bulletin.id, {:page_views => @bulletin.page_views + 1})
      session[:bulletins_show] = @bulletin.id
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bulletin }
    end
  end

  def get_data
#    bulletins_scope = Irm::Bulletin.list_all
    rec = Irm::Bulletin.without_delete.accessible(Irm::Person.current.id)
#    bulletins,count = paginate(rec)
    respond_to do |format|
      format.json  {render :json => to_jsonp(rec.to_grid_json([:id, :bulletin_title,:published_date,:page_views,:author], 10)) }
    end
  end

  def index

  end

  def destroy
    @bulletin = Irm::Bulletin.find(params[:id])
    @bulletin.update_attribute(:status_code, "DELETE")

    respond_to do |format|
      format.html { redirect_to({:controller => "irm/bulletins", :action=>"index"}) }
      format.xml  { head :ok }
    end
  end

  def remove_exits_attachments
    @file = Irm::Attachment.where(:latest_version_id => params[:att_id]).first
    @attachments = Irm::AttachmentVersion.query_all.where(:source_id => params[:bulletin_id]).where(:source_type => Irm::Bulletin.name)
    @bulletin = Irm::Bulletin.find(params[:bulletin_id])
    respond_to do |format|
      if @file.destroy
          format.js { render :remove_exits_attachments}
      end
    end
  end
end