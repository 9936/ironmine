# -*- coding: utf-8 -*-
module Irm::CommonHelper
  def echo
    "返回中文"
  end

  def get_global_icon
    Irm::GlobalSetting.all.first.logo.url(:original);
  end

  #用户登录时会传入back_url参数,下面的函数用来将back_url包装成隐藏字段
  def back_url_hidden_field_tag
    #back_url = params[:back_url] || request.env['HTTP_REFERER']
    back_url = params[:back_url]
    back_url = CGI.unescape(back_url.to_s)
    hidden_field_tag('back_url', CGI.escape(back_url)) unless back_url.blank?
  end

  def back_url_default(default_options={})
    if params[:back_url].present?
      CGI.unescape(params[:back_url].to_s)
    elsif default_options.any?
      default_options
    else
      "javascript:history.back()"
    end
  end


  def hidden_params_field(key)
    hidden_field_tag(key, params[key.to_sym]) if params[key.to_sym].present?
  end

  def show_recently_object_list(companies = [])
    show_limit = 10
    html_content = ""
    obs = Irm::RecentlyObject.where("1=1").order("updated_at DESC").limit(50)
    types = obs.group(:source_type).collect(&:source_type)
    accessible_scope = {}
    types.each do |tp|
      accessible_scope = accessible_scope.merge({tp.to_sym => eval(tp).current_accessible([])})
    end

    obs.each do |ob|
      unless accessible_scope[ob.source_type.to_sym] && accessible_scope[ob.source_type.to_sym].include?(ob.source_id)
        next
      end
      if show_limit > 0
        title = eval(ob.source_type).find(ob.source_id).recently_object_name
        url_ops = eval(ob.source_type).find(ob.source_id).recently_object_url_options
        html_content << content_tag(:tr, content_tag(:td, link_to(get_list_icon + title, url_ops, {:title => title})))
        show_limit = show_limit - 1
      else
        break
      end
    end

    raw(html_content)
  end

  #去除HTML标签
  def plain_text(text,replacement=" ")
    text = text.to_s
    text.gsub(/<[^>]*>/){|html| replacement}
  end

  #获取当前的session过期时间(秒为单位)
  def get_session_time
    session = Irm::SessionSetting.all.first
    if session.nil?
      15 * 60
    else
      session.time_out.to_i * 60
    end
  end
end
