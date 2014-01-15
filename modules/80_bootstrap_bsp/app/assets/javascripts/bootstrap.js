function openModal(href){
    var modalTitle = $.i18n("loading"),
        modalDialog = $("#linkModal");

    if(modalDialog.length == 0){
        modalDialog = buildModal();
        $('body').append(modalDialog);
    }else{
        $(".modal-footer", modalDialog).html("");
        modalDialog.css({"width": "560px", "margin-left": "-280px"});
    }
    $(".modal-header h3", modalDialog).text(modalTitle);
    $(".modal-body", modalDialog).html('<div class="loading-circle"></div>');
    modalDialog.modal('show');
    if(href.indexOf('#') == 0){
        $(href).modal({
            show: true,
            keyboard: true,
            backdrop: 'static'
        });
    }else{
        href += href.indexOf("?") > 0 ? "&_dom_id=null" : "?_dom_id=null"
        modalDialog.load(href, function(){
            $('form', modalDialog).each(function(){
                var $form = $(this),
                    $action = $form.attr("action");
                $action += $action.indexOf("?") > 0 ? "&_dom_id=linkModal" : "?_dom_id=linkModal";
                $form.data("remote", true);
                $form.attr("action", $action);
            });
            //根据modoal的宽度自动进行设置
            modalDialog.css({"min-width": "560px", "max-width": "1000px", "width": "auto"});
            modalDialog.css({"margin-left": "-"+modalDialog.width()/2 + "px"})
        });
    }
}

function buildModal(){
    return $('<div class="modal" id="linkModal" tabindex="-1" role="dialog" data-backdrop="static"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h3></h3></div><div class="modal-body"></div><div class="modal-footer"></div></div>');
}

$(function(){
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();

  $("a[rel=modal]").live("click",function(e){
      e.preventDefault();
      var href = $(this).attr('href');

      openModal(href);
  });
});