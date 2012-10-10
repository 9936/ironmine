$(function(){
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();

  $("a[rel=modal]").live("click",function(e){
      e.preventDefault();
      var href = $(this).attr('href'),
          modalTitle = $(this).attr('modal_title'),
          modalDialog = $("#linkModal");
      if(modalDialog.length == 0){
          modalDialog = buildModal();
          $('body').append(modalDialog);
      }
      $(".modal-header h3", modalDialog).text(modalTitle);
      $(".modal-body", modalDialog).html('<div class="loading-circle"></div>');
      modalDialog.modal('show');
      if(href.indexOf('#') == 0){
          $(href).modal('show');
      }else{
          href += href.indexOf("?") > 0 ? "&_dom_id=null" : "?_dom_id=null"
          $.get(href, function(data){
              $(".modal-body", modalDialog).html(data);
              $('form', modalDialog).each(function(){
                  var action = $(this).attr("action");
                  action += action.indexOf("?") > 0 ? "&_dom_id=linkModal" : "?_dom_id=linkModal";
                  $(this).attr("action",action)
              })
          });
      }
  });
  function buildModal(){
      return $('<div class="modal" id="linkModal" tabindex="-1" role="dialog"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h3></h3></div><div class="modal-body"></div><div class="modal-footer"></div></div>');
  }
});