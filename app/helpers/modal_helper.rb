module ModalHelper
  def hand_result(obj, render_template, success_callback = '', error_callback = '')
    if obj.errors.any?
      script = %Q(
        $('#linkModal').html('#{escape_javascript(render(render_template))}');
        $('#linkModal form').each(function () {
          var action = $(this).attr("action");
          action += action.indexOf("?") > 0 ? "&_dom_id=linkModal" : "?_dom_id=linkModal";
          $(this).data("remote", true);
          $(this).attr("action", action);
          var error_callback = #{error_callback};
          if(error_callback){
             error_callback.call();
          }
        });
      )
    else
      script = %Q(
        $('#linkModal').modal('hide');
        var success_callback = #{success_callback};
        if(success_callback) {
          success_callback.call();
        }
      )
    end
    script.html_safe
  end
end