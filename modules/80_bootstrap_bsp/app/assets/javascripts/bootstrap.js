$(function(){
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();

  $("a[rel=modal]").live("click",function(e){
      e.preventDefault();
      var href = $(this).attr('href'),
          modalTitle = $(this).attr('modal_title') || "Loading....",
          modalDialog = $("#linkModal");

      openModal(href);

//      if(modalDialog.length == 0){
//          modalDialog = buildModal();
//          $('body').append(modalDialog);
//      }else{
//          $(".modal-footer", modalDialog).html("");
//      }
//      $(".modal-header h3", modalDialog).text(modalTitle);
//      $(".modal-body", modalDialog).html('<div class="loading-circle"></div>');
//      modalDialog.modal('show');
//      if(href.indexOf('#') == 0){
//          $(href).modal('show');
//      }else{
//          href += href.indexOf("?") > 0 ? "&_dom_id=null" : "?_dom_id=null"
//          modalDialog.load(href, function(){
//              $('form', modalDialog).each(function(){
//                  var $form = $(this),
//                      $action = $form.attr("action");
//                  $action += $action.indexOf("?") > 0 ? "&_dom_id=linkModal" : "?_dom_id=linkModal";
//                  $form.data("remote", true);
//                  $form.attr("action", $action);
//              });
//          });
//      }
  });

  function openModal(href){
      var modalTitle = "Loading....",
          modalDialog = $("#linkModal");
      if(modalDialog.length == 0){
          modalDialog = buildModal();
          $('body').append(modalDialog);
      }else{
          $(".modal-footer", modalDialog).html("");
      }
      $(".modal-header h3", modalDialog).text(modalTitle);
      $(".modal-body", modalDialog).html('<div class="loading-circle"></div>');
      modalDialog.modal('show');
      if(href.indexOf('#') == 0){
          $(href).modal('show');
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
          });
      }
  }

  function buildModal(){
      return $('<div class="modal" id="linkModal" tabindex="-1" role="dialog"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h3></h3></div><div class="modal-body"></div><div class="modal-footer"></div></div>');
  }
});