class Irm::PasswordPoliciesController < ApplicationController
  def index
    @policy = Irm::PasswordPolicy.all.first
    if @policy.nil?
      @policy = Irm::PasswordPolicy.create()
    end
  end

  def update
    @policy = Irm::PasswordPolicy.find(params[:id])

    respond_to do |format|
      if @policy.update_attributes(params[:irm_password_policy])
        format.html {redirect_to({:action=>"index"},:notice => (t :successfully_created))}
        format.xml  { head :ok }
      else
        @error = @policy
        format.html { render "index" }
        format.xml  { render :xml => @policy.errors, :status => :unprocessable_entity }
      end
    end
  end
end