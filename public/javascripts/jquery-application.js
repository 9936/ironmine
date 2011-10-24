$(function(){

    //BEGIN========================全局ajax事件监听========================================
    $(document).ajaxSend(function(event, jqXHR, ajaxOptions){
        $("body").mask($.i18n("processing"));
    });
    $(document).ajaxSuccess(function(event, jqXHR, ajaxOptions){
    });
    $(document).ajaxError(function(event, jqXHR, ajaxOptions,error){
    });
    $(document).ajaxComplete(function(event, jqXHR, ajaxOptions){
        $("body").unmask();
    });
    //END========================全局ajax事件监听========================================
    $("*[required]").each(function(i,e){
        e.removeAttribute("required");
    });
    //BEGIN========================系统全局初始化========================================
    $('form a[type=submit]').live('click', function(e) {
      parent_forms = $(this).parents("form");
      e.preventDefault()
      if(parent_forms[0])
        $(parent_forms[0]).trigger("submit");
    });

    $('form a.submit').live('click', function(e) {
        href = $(this).attr("href");
        parent_forms = $(this).parents("form");
        e.preventDefault()
        if(parent_forms[0]){
            $(parent_forms[0]).attr("action",href);
            $(parent_forms[0]).trigger("submit");
        }
    });

    $('input[irm_uppercase]').live('keyup', function(event){
         $(this).val($(this).val().toUpperCase().replace(/^(_+)|[^A-Z_]/g, ""));
    });

    $('input[irm_uppercase]').each(function(index,n){
         $(n).attr("autocomplete", "off");
    });

    $('input[irm_chr_only]').live('keyup', function(event){
         $(this).val($(this).val().replace(/^(_+)|^( +)|[^A-Z a-z0-9_]/g, ""));
    });

    $('input[irm_chr_only]').each(function(index,n){
         $(n).attr("autocomplete", "off");
    });

    $('input[irm_number_only]').live('keyup', function(event){
         $(this).val($(this).val().replace(/D/g, ""));
    });

    $('form:not([data-remote])').bind("submit",function(e){
         $(e.target).find("input[type=submit]").each(function(index,el){
             $(el).attr("disabled",true);
             $(el).addClass("disabled");
             $(el).attr("value",$.i18n("processing"));
         });
         $(e.target).find("div.button a").each(function(index,el){
             $(el).attr("disabled",true);
             $(el).attr("onclick","alert('"+$.i18n("processing")+"');return false;");
             $(el).addClass("disabled");
             $(el).html($.i18n("processing"));
         });
    });

    $('a[disabled]').each(function(index,n){
        $(n).addClass("disabled");
        n.removeAttribute("disabled");
        $(n).attr("href", "javascript:void(0);");
    });

    if($.fn.datePicker){
        $("input.date").each(function(i,e){
            var options = {};
            if(!$(e).attr("future")){
                options["startDate"] =new Date(1996, 1, 1);
            }
            if($(e).attr("nobutton")){
                options["createButton"] =false;
            }
            if($(e).attr("today")){
                $(e).datePicker(options).val(new Date().asString()).trigger('change');
            }
            else
            {
                $(e).datePicker(options);
            }
            $(e).bind("click",function(event){
                $(this).dpDisplay();
            })
            $(e).bind("keyup",function(event){
                if(event.keyCode=="9"){
                    $(this).dpDisplay();
                }
            })
            $(e).bind("keydown",function(event){
                if(event.keyCode=="9"){
                  $(this).dpClose();
                }
            })

        });
    }
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
