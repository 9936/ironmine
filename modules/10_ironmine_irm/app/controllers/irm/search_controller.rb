# coding: utf-8
class Irm::SearchController < ApplicationController
  layout "bootstrap_application_full"

  #def indexs
  #  results = []
  #  Ironmine::Acts::Searchable.searchable_entity.each do |key,value|
  #    next unless !value.present?||allow_to_function?(value)
  #    search_entity = key.constantize
  #    if search_entity.searchable_options[:direct].present?&&search_entity.respond_to?(search_entity.searchable_options[:direct].to_sym)
  #      results =  search_entity.send(search_entity.searchable_options[:direct].to_sym,params[:query])
  #      if results.first
  #        redirect_to(results.first.searchable_show_url_options) and return
  #      end
  #    end
  #  end if params[:query].present?
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => results }
  #  end
  #end

  def index
    params[:search_option_str] ||= ''
    search_option_str = params[:search_option_str]
    entry_arr = []
    search_option_str.split(" ").each do |entry|
      entry_arr << entry.to_s.constantize if Ironmine::Acts::Searchable.searchable_entity.keys.include?(entry.to_s)
    end
    #根据单号搜素
    Ironmine::Acts::Searchable.searchable_entity.each do |key,value|
      next unless !value.present?||allow_to_function?(value)
      search_entity = key.constantize
      if search_entity.searchable_options[:direct].present?&&search_entity.respond_to?(search_entity.searchable_options[:direct].to_sym)
        results =  search_entity.send(search_entity.searchable_options[:direct].to_sym,params[:q])
        if results.first
          redirect_to(results.first.searchable_show_url_options) and return
        end
      end
    end if params[:q].present?


    #时间过滤以及一些基本的参数
    time_option = params[:time_option]
    time_limit = get_time_limit(time_option)
    params[:q] ||= ''
    q = params[:q].gsub("-","")
    params[:page] ||= 1
    params[:per_page] ||= 10


    @search = Sunspot.search(entry_arr) do |query|
      query.keywords q, :highlight => true
      query.with(:updated_at).greater_than(time_limit) if time_limit
      query.paginate(:page => params[:page], :per_page => params[:per_page])
    end if entry_arr.any? and !q.eql?('')

    @results_ids = @search.results.collect{|i| i[:id]}  if @search
    @results = {}
    @search.each_hit_with_result do |hit, result|
      #处理回复中的附件
      if result.class.to_s.eql?('Irm::AttachmentVersion') and result.source_type
        if result.source_type.to_s.eql?('Chm::ChangeJournal')
          class_type = 'Chm::ChangeRequest'
        elsif result.source_type.to_s.eql?('Chm::ChangeJournal')
          class_type = 'Icm::IncidentRequest'
        else
          class_type = result.source_type
        end
      else
        class_type = ''
      end

      if result.class.to_s.eql?('Irm::AttachmentVersion') && result.source_id && search_option_str.split(" ").include?(class_type)
        @results[result.source_id.to_sym] ||= {}
        @results[result.source_id.to_sym][:attachments] ||= []
        if @results_ids.include?(result.source_id.to_s)
          #@total_record -= 1
          @results[result.source_id.to_sym][:attachments] << hit
        elsif result.source_type
          if @results[result.source_id.to_sym][:result].present?
            @results[result.source_id.to_sym][:attachments] << hit
            #@total_record -= 1
          else
            begin
              record = result.source_type.constantize.find(result.source_id)
            rescue
              record = nil
            end
            #附件是否来自于回复
            if record && result.source_type.to_s.eql?('Icm::IncidentJournal')
              record = Icm::IncidentRequest.find(record.incident_request_id)
            elsif record && result.source_type.to_s.eql?('Chm::ChangeJournal')
              record = Chm::ChangeJournal.find(record.change_request_id)
            end
            if record.present?
              @results[result.source_id.to_sym][:attachments] << hit
              @results[result.source_id.to_sym][:result] =  record
            end
          end
        end
      else
        @results[result.id.to_sym] ||= {}
        @results[result.id.to_sym][:hit] = hit
      end
    end if @search
  end

  private
    def get_time_limit(time_option)
      time_limit = nil
      if time_option
        time_limit = 1.days.ago if time_option.eql?('day')
        time_limit = 1.weeks.ago if time_option.eql?('week')
        time_limit = 1.months.ago if time_option.eql?('month')
        time_limit = 1.years.ago if time_limit.eql?('year')
      end
      time_limit
    end

end
