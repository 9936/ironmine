class Skm::SettingsController < ApplicationController
  def index
    @settings = Irm::SystemParameter.select_all.query_by_type("SKM_SETTING")
  end

  def edit
    @settings = Irm::SystemParameter.select_all.query_by_type("SKM_SETTING")
  end

  def update

     system_parameters = Irm::SystemParameter.query_by_type("SKM_SETTING")

         respond_to do |format|
           if true

             system_parameters.each do |s|
               if s.data_type == "IMAGE"
                 if params[s[:parameter_code].to_sym] && !params[s[:parameter_code].to_sym].blank?
                     s.update_attribute(:img, params[s[:parameter_code].to_sym])
                     s.update_attribute(:value, "Y")

                 end
               elsif s.data_type == "TEXT"
                 if params[s[:parameter_code].to_sym]
                   s.update_attribute(:value, params[s[:parameter_code].to_sym])
                 end
               else
                 if params[s[:parameter_code].to_sym]
                   s.update_attribute(:value, params[s[:parameter_code].to_sym])
                 end
               end
             end

             format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
             format.xml  { head :ok }
           else
             format.html { render :action => "edit" }
             format.xml  { render :xml => @settings.errors, :status => :unprocessable_entity }
           end
         end
  end
end