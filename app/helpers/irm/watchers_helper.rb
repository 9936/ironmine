module Irm::WatchersHelper
  def ava_watchers(watchable_id, watchable_type)
    if watchable_id && !watchable_id.blank?
      watchable = watchable_type.find(watchable_id)
      (Irm::Person.enabled.collect{|p| [p.name, p.id]} - watchable.all_person_watchers.collect{|p| [p[:person_name], p[:person_id]]})
    else
      Irm::Person.enabled.collect{|p| [p.name, p.id]}
    end
  end

  def watchers_list(watchable, order_target, editable = true, order_type = "DESC")
    watchers = watchable.all_person_watchers(order_target, order_type)
    ret = ""
    watchers.each do |w|
      deletable = editable&&Irm::Constant::SYS_YES.eql?(w.deletable_flag)
      ret << content_tag(:tr,
                  content_tag(:td,
                              content_tag(:div,
                                          link_to(w[:person_name], {}, {:href => "javascript:void(0);", :class=>"watcher_info", :pid => w[:member_id], :pname => w[:person_name]}),
                                          {:style => "float:left"}) + raw("&nbsp;") + (icon_link_delete({:controller => "irm/watchers",
                                                                                                         :action => "delete_watcher",
                                                                                                         :watcher_id => w[:person_id],
                                                                                                         :watchable_id => watchable.id,
                                                                                                         :watchable_type => watchable.class.to_s}, :remote => true) if deletable)))
    end
    raw(ret)
  end

  def watchers_size(watchable)
    watchable.all_person_watchers.size
  end
end