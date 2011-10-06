$(function(){
   $('form a[type=submit]').live('click', function(e) {
     parent_forms = $(this).parents("form");
     e.preventDefault()
     if(parent_forms[0])
       parent_forms[0].submit();
   });

   $('form a.submit').live('click', function(e) {
       href = $(this).attr("href");
       parent_forms = $(this).parents("form");
       e.preventDefault()
       if(parent_forms[0]){
           $(parent_forms[0]).attr("action",href);
           parent_forms[0].submit();
       }
   });
   //BEGIN========================全局ajax事件监听========================================
   $(document).ajaxSend(function(event, jqXHR, ajaxOptions){
   });
   $(document).ajaxSuccess(function(event, jqXHR, ajaxOptions){
   });
   $(document).ajaxError(function(event, jqXHR, ajaxOptions,error){
   });
   $(document).ajaxComplete(function(event, jqXHR, ajaxOptions){
   });
   //END========================全局ajax事件监听========================================

});

//BEGIN========================过滤器 帮助函数========================================
var rawConditionClause = function (clause_dom_id,e){
  var content = $("#"+clause_dom_id).val();
  var addition = e.target.getAttribute("ref");
  content = content.replace(/\s*$/,"");
  content = content.replace(/^\s*/,"");
  var re = new RegExp(e.target.getAttribute("ref"));
  var m = re.exec(content);
  if($(e.target).val())
  {
      if(m == null){

        if(new RegExp("\\d+").exec(content)!=null)
          addition = " AND "+ addition;
        $("#"+clause_dom_id).val(content+ addition);
      }
  }
  else
  {
    if(m != null){
      var originLength = content.length;
      if(m.index ==0){
        var rp = new RegExp(addition+"\\s*AND\\s*");
        content = content.replace(rp,"");
        rp = new RegExp(addition+"\\s+OR\\s*");
        content = content.replace(rp,"");
        if(originLength == content.length)
          content = content.replace(re,"");
      }
      else{
        var rp = new RegExp("AND\\s*"+addition+"\\s*");
        content = content.replace(rp,"");
        rp = new RegExp("OR\\s*"+addition+"\\s*");
        content = content.replace(rp,"");
        if(originLength == content.length)
          content = content.replace(re,"");
      }
      $("#"+clause_dom_id).val(content);
    }
  }
};

var refreshFilterOptions = function(container,e) {
    var con = $("#"+container);
    var currentTarget  = $(e.currentTarget);
    var seq_num = currentTarget.attr("ref");
    var attribute_id = "";
    var refreshNode = $("#filter"+seq_num);

    if(currentTarget.val()&&currentTarget.val()!=""){
       attribute_id = $(e.target).find("option[value="+$(e.target).val()+"]:first").attr("attribute_id")
     }
    var url = decodeURIComponent(con.attr("href"));
    url = url.replace("{seq_num}",seq_num);
    url = url.replace("{attribute_id}",attribute_id);
    refreshNode.load(url);

};

//END========================过滤器 帮助函数========================================
