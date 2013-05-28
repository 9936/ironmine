class Isp::ProgramHistoriesController < ApplicationController

  # GET /program_histories/1
  # GET /program_histories/1.xml
  def show
    @program_history = Isp::ProgramHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_history }
    end
  end

  # DELETE /program_histories/1
  # DELETE /program_histories/1.xml
  def destroy
    @program_history = Isp::ProgramHistory.find(params[:id])
    @program_history.destroy

    respond_to do |format|
      format.html { redirect_to({:controller => "isp/programs", :id => @program_history.program_id, :action => "show"}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    program_histories_scope = Isp::ProgramHistory.with_program(params[:program_id])
    program_histories,count = paginate(program_histories_scope)
    respond_to do |format|
      format.html  {
        @datas = program_histories
        @count = count
      }
    end
  end
end
