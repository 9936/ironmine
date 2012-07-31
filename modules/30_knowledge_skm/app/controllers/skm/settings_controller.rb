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
    system_parameters = Irm::SystemParameter.query_by_type("SKM_SETTING")
    @errors={}
    system_parameters.each do |s|
      if s.data_type == "IMAGE"
        if params[s[:parameter_code].to_sym] && !params[s[:parameter_code].to_sym].blank?
          paramvalue=Irm::SystemParameterValue.query_by_code(s[:parameter_code])
          if paramvalue.present?
            pv=paramvalue.first
            pv.update_attributes({:img=>params[s[:parameter_code].to_sym],:value=>"Y"})
            @errors.merge!({s[:name]=>pv.errors}) if pv.errors.messages.present?
          else
            pv=Irm::SystemParameterValue.create(:system_parameter_id=>s.id,:img=>params[s[:parameter_code].to_sym],:value=>"Y")
            @errors.merge!({s[:name]=>pv.errors}) if pv.errors.messages.present?
          end

        end
      elsif s.data_type == "TEXT"
        if params[s[:parameter_code].to_sym]
          paramvalue=Irm::SystemParameterValue.query_by_code(s[:parameter_code])

          if paramvalue.present?
            pv=paramvalue.first
            pv.update_attributes({:value=>params[s[:parameter_code].to_sym]})
            @errors.merge!({s[:name]=>pv.errors}) if pv.errors.messages.present?
          else
            pv=Irm::SystemParameterValue.create(:system_parameter_id=>s.id,:value=>params[s[:parameter_code].to_sym])
            @errors.merge!({s[:name]=>pv.errors}) if pv.errors.messages.present?
          end
        end
      else
        if params[s[:parameter_code].to_sym]
          paramvalue=Irm::SystemParameterValue.query_by_code(s[:parameter_code])
          if paramvalue.present?
            pv=paramvalue.first
            pv.update_attributes({:value=>params[s[:parameter_code].to_sym]})
            @errors.merge!({s[:name]=>pv.errors}) if pv.errors.messages.present?
          else
            pv=Irm::SystemParameterValue.create(:system_parameter_id=>s.id,:value=>params[s[:parameter_code].to_sym])
            @errors.merge!({s[:name]=>pv.errors}) if pv.errors.messages.present?
          end
        end
      end

    end

       respond_to do |format|
         if @errors.size==0
           format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
           format.xml  { head :ok }
         else
           format.html { render :action => "edit" }
           format.xml  { render :xml => @errors, :status => :unprocessable_entity }
         end
       end
  end
end