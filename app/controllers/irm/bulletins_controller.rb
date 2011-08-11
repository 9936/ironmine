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
    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]
    column_ids = params[:irm_bulletin][:column_ids].split(",")
    respond_to do |format|
      if @bulletin.save
        column_ids.each do |c|
          Irm::BulletinColumn.create(:bulletin_id => @bulletin.id, :bu_column_id => c)
        end
        if params[:selected_actions] && params[:selected_actions].present?
          selected_accesses = params[:selected_actions].split(",")

          selected_accesses.each do |access_str|
            next unless access_str.strip.present?
            access = access_str.split("#")
            access_type = access_types.detect{|i| i[1].eql?(access[0])}

            Irm::BulletinAccess.create({:bulletin_id => @bulletin.id,
                                        :access_type => access_type[0].name,
                                        :access_id => access[1]})
          end if selected_accesses.any?
        end

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
    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]
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
        if params[:selected_actions] && params[:selected_actions].present?
          selected_accesses = params[:selected_actions].split(",")

          bulletin_access_records = @survey.survey_ranges
          bulletin_access_records.each do |t|
            type_short = access_types.detect{|i| i[0].name.eql?(t.access_type)}
            t.destroy unless selected_accesses.include?(type_short[1]+"#"+t.access_id.to_s)
          end
          bulletin_accesses_array = @bulletin.bulletin_accesses.collect{|p| [p.access_type, p.access_id]}

          selected_accesses.each do |access_str|
            next unless access_str.strip.present?
            access = access_str.split("#")
            access_type = access_types.detect{|i| i[1].eql?(access[0])}
            next if bulletin_accesses_array.include?([access_type[0].name, access[1].to_i])

            Irm::BulletinAccess.create({:bulletin_id => @bulletin.id,
                                        :access_type => access_type[0].name,
                                        :access_id => access[1]})
          end
        end

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
    rec = Irm::Bulletin.list_accessible(Irm::Person.current.id)
#    bulletins,count = paginate(rec)
    respond_to do |format|
      format.json  {render :json => to_jsonp(rec.to_grid_json([:id, :bulletin_title,:published_date,:page_views,:author], 10)) }
    end
  end

  def index

  end
end