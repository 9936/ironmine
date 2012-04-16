$(function(){

    //BEGIN========================全局ajax事件监听========================================
    $(document).ajaxSend(function(event, jqXHR, ajaxOptions){
        var _dom_id = get_dom_id(ajaxOptions);
        if (typeof _dom_id != 'undefined' && _dom_id != null && _dom_id.length > 0) {
            $("#"+_dom_id).mask($.i18n("processing"));
        }else{
            $("body").mask($.i18n("processing"));
        }
    });
    $(document).ajaxSuccess(function(event, jqXHR, ajaxOptions){
    });
    $(document).ajaxError(function(event, jqXHR, ajaxOptions,error){
    });
    $(document).ajaxComplete(function(event, jqXHR, ajaxOptions){
        var _dom_id = get_dom_id(ajaxOptions);
        if (typeof _dom_id != 'undefined' && _dom_id != null && _dom_id.length > 0) {
            $("#"+_dom_id).unmask();
        }else {
            $("body").unmask();
        }
    });
    //END========================全局ajax事件监听========================================
    $("*[required]").each(function(i,e){
        e.removeAttribute("required");
        $(e).attr("irequired",true);
    });
    //BEGIN========================系统全局初始化========================================
    $('form a[type=submit]').live('click', function(e) {
      parent_forms = $(this).parents("form");
      e.preventDefault();
      if(parent_forms[0]){
          $(parent_forms[0]).trigger("submit");
      }
    });

    $('form a.submit').live('click', function(e) {
        href = $(this).attr("href");
        parent_forms = $(this).parents("form");
        e.preventDefault()
        if(parent_forms[0]){
            if($(this).attr("target"))
              $(parent_forms[0]).attr("target",$(this).attr("target"));
            else
              $(parent_forms[0]).removeAttr("target");
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
         $(this).val($(this).val().replace(/[^0-9]/g, ""));
    });

    $('input[irm_number_and_cross]').live('keyup', function(event){
         $(this).val($(this).val().replace(/[^- 0-9]/g, ""));
    });

    $('input[irm_number_and_cross]').each(function(index,n){
         $(n).attr("autocomplete", "off");
    });

    $('input[irm_number_only]').each(function(index,n){
         $(n).attr("autocomplete", "off");
    });

    $('input[jrequired]').each(function(index, n){
        var parent_node = $(n).parent();
        var node = '<div class="requiredInput"><div class="requiredBlock"></div>' + $(parent_node).html() + '</div>';
        $(parent_node).html(node);
    });
    $("*[jrequired]").each(function(i,e){
        e.removeAttribute("jrequired");
    });
    $('form:not([data-remote]):not([target])').bind("submit",function(e){
         if($(this).attr("target")){
           return;
         }
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
    //如果下拉列表中只有一个可选值,且当前值是空值,自动选择第一个选项
    $("select[irequired]:not([depend])").each(function(index,element){
        if($(element).val()!=""){
            return
        }
        var options = $(element).find("option")
        if(options.length==2&&$(options[0]).attr("value")==""&&$(options[1]).attr("value")!=""){
            $(element).val($(options[1]).attr("value"));
        }
    });

});

    var autoChooseFirst = function(element){
        if($(element).val()!=""){
            return
        }
        var options = $(element).find("option")
        if(options.length==2&&$(options[0]).attr("value")==""&&$(options[1]).attr("value")!=""){
            $(element).val($(options[1]).attr("value"));
        }
    }

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
//BEGIN========================LOOKUP lov 帮助函数========================================
//openLookup('/_ui/common/data/LookupPage?lkfm=editPage&lknm=acc3&lktp=' + getElementByIdCS('acc3_lktp').value,670,'1','&lksrch=' + escapeUTF(getElementByIdCS('acc3').value.substring(0, 80)))
var curPopupWindow,lastMouseX=0,lastMouseY=0;

function setLastMousePosition(a) {
    if (navigator.appName.indexOf("Microsoft") != -1) a = window.event;
    lastMouseX = a.screenX;
    lastMouseY = a.screenY
}

function openLookup(url, width) {
    openPopup(url, "lookup", 350, 480, "width=" + width + ",height=480,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true)
}

function openPopup(url, name, positionX, positionY, frameParams) {
    closePopup();
    if (lastMouseX - positionX < 0) lastMouseX = positionX;
    if (lastMouseY + positionY > screen.height) lastMouseY -= lastMouseY + positionY + 50 - screen.height;
    lastMouseX -= positionX;
    lastMouseY += 10;
    frameParams += ",screenX=" + lastMouseX + ",left=" + lastMouseX + ",screenY=" + lastMouseY + ",top=" + lastMouseY

    curPopupWindow = window.open(url, name, frameParams, false);
    curPopupWindow.focus();
    $(window).bind("focus",closePopup);
}

function closePopup() {
    if (curPopupWindow != null) {
        try {
            if (curPopupWindow.confirmOnClose) if (curPopupWindow.confirm(curPopupWindow.confirmOnCloseLabel)) {
                curPopupWindow.confirmOnClose = false;
                curPopupWindow.focus();
                return false
            }
            curPopupWindow.close()
        } catch (a) {}
        $(window).unbind("focus",closePopup);
        curPopupWindow = null;

    }
}

function lookupPick(fieldId,value,valueLabel,data){
    $("#"+fieldId).val(value);
    $("#"+fieldId+"_label").val(valueLabel);
    $("#"+fieldId+"_label").focus();
    $("#"+fieldId).data("lov",data);
    $("#"+fieldId).trigger("change");
    closePopup();
}

function clearLookup(fieldId){
    //$("#"+fieldId+"_label").val("");
    $("#"+fieldId).val("");
    $("#"+fieldId).trigger("change");
}

function setLookupValue(fieldId,value){
    var url = $("#"+fieldId).attr("href");
    url = url.replace("lov?","lov_value?");
    url = url+"&lkval="+value;
    //获取当前的form表单
    var parent_forms = $("#"+fieldId).parents("form");
    var dom_id = $(parent_forms[0]).attr("id");
    $.getJSON(url,{_dom_id:dom_id},function(data) {
        $("#"+fieldId).val(data.value);
        $("#"+fieldId+"_label").val(data.label_value);
        $("#"+fieldId).data("lov",data.data);
        $("#"+fieldId).trigger("change");
    });
}

function setLookupLabelValue(fieldId,labelValue){
    var url = $("#"+fieldId).attr("href");
    url = url.replace("lov?","lov_value?")
    url = url+"&lklblval="+labelValue;
    $.getJSON(url, function(data) {
        $("#"+fieldId).val(data.value);
        $("#"+fieldId+"_label").val(data.label_value);
        $("#"+fieldId).data("lov",data.data);
        $("#"+fieldId).trigger("change");
    });
}

//END========================LOOKUP lov 帮助函数========================================

//BEGIN========================datepicker 帮助函数========================================
function initDateField(dateField){
    var me = $(dateField);
    me.datepicker({format:"yyyy-mm-dd",weekStart:1});
    me.attr("onfocus","");
    me.trigger("focus");
}
function dateFieldChooseToday(fieldId,fieldValue){
  $("#"+fieldId).val(fieldValue);
  $("#"+fieldId).trigger("keyup");
}
//END========================datepicker 帮助函数========================================

//START =================================Ajax 监听帮助函数================================
function get_dom_id(ajaxOptions) {
    var _dom_id,
    paraString = ajaxOptions.url.substring(ajaxOptions.url.indexOf("?")+1,ajaxOptions.url.length).split("&"),
    paraObj = {};
    for (i=0; j=paraString[i]; i++){
        paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length);
    }
    _dom_id = paraObj["_dom_id".toLowerCase()];
    return _dom_id
}
//end =================================Ajax 监听帮助函数================================