class Irm::GlobalSettingsController < ApplicationController
  # GET /global_settings
  # GET /global_settings.xml
  def index

    @setting_names={}
    Irm::SystemParameter.multilingual.query_by_type("GLOBAL_SETTING").each {|i| @setting_names.merge!({i[:parameter_code].to_sym=>i[:name]}) }

    @setting_values={}
    Irm::SystemParameterValue.query_by_type("GLOBAL_SETTING").each {|i|
      if i[:data_type].eql?("IMAGE")
        @setting_values.merge!({i[:parameter_code].to_sym=>i.img})
      else
        @setting_values.merge!({i[:parameter_code].to_sym=>i[:value]})
      end
    }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @settings }
    end
  end

  # GET /global_settings/1/edit
  def edit
    @setting_names={}
    Irm::SystemParameter.multilingual.query_by_type("GLOBAL_SETTING").each {|i| @setting_names.merge!({i[:parameter_code].to_sym=>i[:name]}) }

    @setting_values={}
    Irm::SystemParameterValue.query_by_type("GLOBAL_SETTING").each {|i|
      if i[:data_type].eql?("IMAGE")
        @setting_values.merge!({i[:parameter_code].to_sym=>i.img})
      else
        @setting_values.merge!({i[:parameter_code].to_sym=>i[:value]})
      end
    }
  end


  # PUT /global_settings/1
  # PUT /global_settings/1.xml
  def update
    @setting_names={}
    Irm::SystemParameter.multilingual.query_by_type("GLOBAL_SETTING").each {|i| @setting_names.merge!({i[:parameter_code].to_sym=>i[:name]}) }

    @setting_values={}
    Irm::SystemParameterValue.query_by_type("GLOBAL_SETTING").each {|i|
      if i[:data_type].eql?("IMAGE")
        @setting_values.merge!({i[:parameter_code].to_sym=>i.img})
      else
        @setting_values.merge!({i[:parameter_code].to_sym=>i[:value]})
      end
    }

    system_parameters = Irm::SystemParameter.multilingual.query_by_type("GLOBAL_SETTING")
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

  def crop
#    @global_setting = Irm::GlobalSetting.all.first
    render "crop"
  end
end
