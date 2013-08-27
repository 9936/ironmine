class Sug::SkillsController < ApplicationController
  # GET /skills
  # GET /skills.xml
  def index
    @skills = Sug::Skill.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skills }
    end
  end

  # GET /skills/1
  # GET /skills/1.xml
  def show
    @skill = Sug::Skill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @skill }
    end
  end

  # GET /skills/new
  # GET /skills/new.xml
  def new
    @skill = Sug::Skill.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @skill }
    end
  end

  # GET /skills/1/edit
  def edit
    @skill = Sug::Skill.find(params[:id])
  end

  # POST /skills
  # POST /skills.xml
  def create
    @skill = Sug::Skill.new(params[:sug_skill])

    respond_to do |format|
      if @skill.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @skill, :status => :created, :location => @skill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skills/1
  # PUT /skills/1.xml
  def update
    @skill = Sug::Skill.find(params[:id])

    respond_to do |format|
      if @skill.update_attributes(params[:sug_skill])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        puts "===============#{@skill.errors}================"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.xml
  def destroy
    @skill = Sug::Skill.find(params[:id])
    @skill.destroy

    respond_to do |format|
      format.html { redirect_to(skills_url) }
      format.xml  { head :ok }
    end
  end

  def owned_categories
    category_scope = Sug::Category.list_all.with_leaf("SERVICE_REQUEST_CATEGORY").owned_by_skill(params[:id])
    category_scope = category_scope.match_value("#{Sug::Category.table_name}.name", params[:first_name])
    categories,count = paginate(category_scope)
    respond_to do |format|
      format.html  {
        @datas = categories
        @count = count
      }
    end
  end

  def available_categories
    category_scope = Sug::Category.list_all.with_leaf("SERVICE_REQUEST_CATEGORY").available_by_skill(params[:id])
    category_scope = category_scope.match_value("#{Sug::Category.table_name}.name", params[:first_name])
    categories,count = paginate(category_scope)
    respond_to do |format|
      format.html  {
        @datas = categories
        @count = count
      }
    end
  end

  def create_categories
    if params[:sug_skill] && params[:sug_skill][:status_code] && params[:id]
      category_ids = params[:sug_skill][:status_code].split(",")
      category_ids.each do |c_id|
        Sug::CategorySkill.create(:category_id => c_id, :skill_id => params[:id])
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action => "show", :id => params[:id]}) }
      format.xml  { head :ok }
    end
  end

  def remove_categories
    if params[:sug_skill] && params[:sug_skill][:temp_id_string] && params[:id]
      category_ids = params[:sug_skill][:temp_id_string].split(",")
      category_ids.each do |c_id|
        skill_category = Sug::CategorySkill.where(:category_id => c_id, :skill_id => params[:id]).first
        skill_category.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action => "show", :id => params[:id]}) }
      format.xml  { head :ok }
    end
  end


  def get_data
    skills_scope = Sug::Skill
    skills,count = paginate(skills_scope)
    respond_to do |format|
      format.html  {
        @datas = skills
        @count = count
      }
    end
  end
end
