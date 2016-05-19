class Yan::WorkloadRegisterController < ApplicationController
  layout "application_full"
  def index
    @my_events = ""
    Yan::RegisterWorkload.where("supporter_id = ?",Irm::Person.current.id).collect{|w|
      @my_events =  "#{@my_events}#{w.id}--#{w.description}--#{w.start_date}--#{w.end_date};"
    }
  end

  def create_workload
    register_workload = Yan::RegisterWorkload.create({:request_id => params[:request_id],
                                                      :description => params[:description],
                                                      :start_date=> params[:start_date],
                                                      :end_date=>params[:end_date],
                                                      :supporter_id=>Irm::Person.current.id
                                                     })
    if register_workload.save
      render json: {:result=>"OK"}
    else
      render json: {:result=>"ERROR"}
    end
  end

  def update_workload
    register_workload = Yan::RegisterWorkload.where(:supporter_id=>Irm::Person.current.id,:start_date=> params[:start_date],:end_date=>params[:end_date])
    if register_workload.present?
      register_workload = register_workload.first()
      if register_workload.update_attributes({:description=>params[:description],:request_id=>params[:request_id]})
        render json: {:result=>"OK"}
      else
        render json: {:result=>"ERROR"}
      end
    else
      render json: {:result=>"ERROR"}
    end
  end

  def update_workload_by_resize
    register_workload = Yan::RegisterWorkload.where(:supporter_id=>Irm::Person.current.id,:start_date=> params[:start_date])
    if register_workload.present?
      register_workload = register_workload.first()
      if register_workload.update_attribute(:end_date,params[:end_date])
        render json: {:result=>"OK"}
      else
        render json: {:result=>"ERROR"}
      end
    else
      render json: {:result=>"ERROR"}
    end
  end

  def update_workload_by_drop
    register_workload = Yan::RegisterWorkload.find(params[:id])
    if register_workload.present?
      if register_workload.update_attributes({:end_date=>params[:end_date],:start_date=>params[:start_date]})
        render json: {:result=>"OK"}
      else
        render json: {:result=>"ERROR"}
      end
    else
      render json: {:result=>"ERROR"}
    end
  end

  def delete_workload
    register_workload = Yan::RegisterWorkload.find(params[:id])
    if register_workload.destroy
      render json: {:result=>"OK"}
    else
      render json: {:result=>"ERROR"}
    end
  end

end
