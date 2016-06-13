class Yan::WorkloadRegisterController < ApplicationController
  layout "application_full"
  def index

  end

  def create_workload
    register_workload = Yan::RegisterWorkload.create({:request_id => params[:request_id],
                                                      :description => params[:description],
                                                      :start_date=> params[:start_date],
                                                      :end_date=>params[:end_date],
                                                      :supporter_id=>Irm::Person.current.id,
                                                      :workload=>((params[:end_date].to_time-params[:start_date].to_time)/3600).round(2)
                                                     })
    if register_workload.save
      render json: {:result=>"OK",:id=>register_workload.id}
    else
      render json: {:result=>"ERROR"}
    end
  end

  def update_workload
    register_workload = Yan::RegisterWorkload.find(params[:id])
    if register_workload.present?
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
      if register_workload.update_attributes({:end_date=>params[:end_date],:workload=>((params[:end_date].to_time-params[:start_date].to_time)/3600).round(2)})
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
      incident_journal = Icm::IncidentJournal.where("DATE_FORMAT(created_at, '%Y-%m-%d') = ? AND replied_by = ? AND incident_request_id = ?",params[:date_time],Irm::Person.current.id,register_workload.request_id)
      # 如果存在回复
      if incident_journal.length > 0
        if register_workload.update_attributes({:end_date=>params[:end_date],:start_date=>params[:start_date],:workload=>((params[:end_date].to_time-params[:start_date].to_time)/3600).round(2)})
          render json: {:result=>"OK"}
        else
          render json: {:result=>"ERROR"}
        end
      else
        if register_workload.update_attributes({:end_date=>params[:end_date],:start_date=>params[:start_date],:workload=>((params[:end_date].to_time-params[:start_date].to_time)/3600).round(2),:request_id=>nil})
          render json: {:result=>"OK"}
        else
          render json: {:result=>"ERROR"}
        end
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

  def get_week_workload
    register_workload = []
    sum = 0.0
    7.times do |i|
      date_time = (params[:first_date].to_time + i.day).to_s[0,10]
      Yan::RegisterWorkload.
      select("sum(workload) workload").
      where("date_format(start_date, '%Y-%m-%d') = ? and date_format(end_date, '%Y-%m-%d') = ? and supporter_id = ?", date_time,date_time,Irm::Person.current.id).collect{|rw|
        if !rw.workload.present?
          rw.workload = 0
        end
        register_workload << rw.workload
        sum = sum + rw.workload
      }
    end
    # register_workload << sum
    render json: {:register_workload=>register_workload}
  end

  def get_month_workload
    month_workload = 0.0
    date_time = (params[:first_date].to_time).to_s[0,10]
    Yan::RegisterWorkload.
        select("sum(workload) workload").
        where("date_format(start_date, '%Y-%m-01') = ? and date_format(end_date, '%Y-%m-01') = ? and supporter_id = ?",
              Date.strptime(date_time,'%Y-%m'),Date.strptime(date_time,'%Y-%m'),Irm::Person.current.id).collect{|rw|
      if !rw.workload.present?
        rw.workload = 0.0
      end
      month_workload = month_workload + rw.workload
    }

    render json: {:month_workload=>month_workload}
  end

  def get_data
    my_events = Yan::RegisterWorkload.where("supporter_id = ?",Irm::Person.current.id).collect{|w|
      {:id=>w.id,:title=>w.description,:start_date=>w.start_date,:end_date=>w.end_date}
    }

    render json: {:my_events=>my_events}
  end


end
