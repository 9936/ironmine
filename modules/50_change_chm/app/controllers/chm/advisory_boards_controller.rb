class Chm::AdvisoryBoardsController < ApplicationController
  # GET /advisory_boards
  # GET /advisory_boards.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  {
        @advisory_boards = Chm::AdvisoryBoard.all
        render :xml => @advisory_boards
      }
    end
  end

  # GET /advisory_boards/1
  # GET /advisory_boards/1.xml
  def show
    @advisory_board = Chm::AdvisoryBoard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @advisory_board }
    end
  end

  # GET /advisory_boards/new
  # GET /advisory_boards/new.xml
  def new
    @advisory_board = Chm::AdvisoryBoard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advisory_board }
    end
  end

  # GET /advisory_boards/1/edit
  def edit
    @advisory_board = Chm::AdvisoryBoard.find(params[:id])
  end

  # POST /advisory_boards
  # POST /advisory_boards.xml
  def create
    @advisory_board = Chm::AdvisoryBoard.new(params[:chm_advisory_board])

    respond_to do |format|
      if @advisory_board.save
        format.html { redirect_to({:action => "show",:id=>@advisory_board.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @advisory_board, :status => :created, :location => @advisory_board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @advisory_board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /advisory_boards/1
  # PUT /advisory_boards/1.xml
  def update
    @advisory_board = Chm::AdvisoryBoard.find(params[:id])

    respond_to do |format|
      if @advisory_board.update_attributes(params[:chm_advisory_board])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @advisory_board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /advisory_boards/1
  # DELETE /advisory_boards/1.xml
  def destroy
    @advisory_board = Chm::AdvisoryBoard.find(params[:id])
    @advisory_board.destroy

    respond_to do |format|
      format.html { redirect_to(advisory_boards_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    advisory_boards_scope = Chm::AdvisoryBoard.order("created_at desc")
    advisory_boards_scope = advisory_boards_scope.match_value("advisory_board.name",params[:name])
    advisory_boards,count = paginate(advisory_boards_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(advisory_boards.to_grid_json([:name,:code,:description,:status_meaning],count))}
      format.html  {
        @count = count
        @datas = advisory_boards
      }
    end
  end
end
