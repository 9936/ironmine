class Skm::SettingsController < ApplicationController
  def index
    @setting_names={}
    Irm::SystemParameter.multilingual.query_by_type("SKM_SETTING").each {|i| @setting_names.merge!({i[:parameter_code].to_sym=>i[:name]}) }

    @setting_values={}
    Irm::SystemParameterValue.query_by_type("SKM_SETTING").each {|i|
      if i[:data_type].eql?("IMAGE")
        @setting_values.merge!({i[:parameter_code].to_sym=>i.img})
      else
        @setting_values.merge!({i[:parameter_code].to_sym=>i[:value]})
      end
    }
  end

  def edit
    @setting_names={}
    Irm::SystemParameter.multilingual.query_by_type("SKM_SETTING").each {|i| @setting_names.merge!({i[:parameter_code].to_sym=>i[:name]}) }

    @setting_values={}
    Irm::SystemParameterValue.query_by_type("SKM_SETTING").each {|i|
      if i[:data_type].eql?("IMAGE")
        @setting_values.merge!({i[:parameter_code].to_sym=>i.img})
      else
        @setting_values.merge!({i[:parameter_code].to_sym=>i[:value]})
      end
    }
  end

  def update

    system_parameters = Irm::SystemParameter.query_by_type("SKM_SETTING")

    respond_to do |format|
      if true

        system_parameters.each do |s|
          if s.data_type == "IMAGE"
            if params[s[:parameter_code].to_sym] && !params[s[:parameter_code].to_sym].blank?
              paramvalue=Irm::SystemParameterValue.query_by_code(s[:parameter_code])
              if paramvalue.present?
                paramvalue.first.update_attribute(:img, params[s[:parameter_code].to_sym])
                paramvalue.first.update_attribute(:value, "Y")
              else
                Irm::SystemParameterValue.create(:system_parameter_id=>s.id,:img=>params[s[:parameter_code].to_sym],:value=>"Y")
              end

            end
          elsif s.data_type == "TEXT"
            if params[s[:parameter_code].to_sym]
              paramvalue=Irm::SystemParameterValue.query_by_code(s[:parameter_code])

              if paramvalue.present?
                paramvalue.first.update_attribute(:value, params[s[:parameter_code].to_sym])
              else
                Irm::SystemParameterValue.create(:system_parameter_id=>s.id,:value=>params[s[:parameter_code].to_sym])
              end
            end
          else
            if params[s[:parameter_code].to_sym]
              paramvalue=Irm::SystemParameterValue.query_by_code(s[:parameter_code])
              if paramvalue.present?
                paramvalue.first.update_attribute(:value, params[s[:parameter_code].to_sym])
              else
                Irm::SystemParameterValue.create(:system_parameter_id=>s.id,:value=>params[s[:parameter_code].to_sym])
              end
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