$(function(){
    //BEGIN========================全局ajax事件监听========================================
    $(document).ajaxSend(function(event, jqXHR, ajaxOptions){
        var _dom_id = get_dom_id(ajaxOptions);
        if (typeof _dom_id != 'undefined' && _dom_id != null && _dom_id.length > 0) {
            $("#"+_dom_id).addClass("table-placeholder");
            $("#"+_dom_id).mask($.i18n("processing"));
        }else if(_dom_id != "null"){
            $("body").mask($.i18n("processing"));
        }
    });
    $(document).ajaxSuccess(function(event, jqXHR, ajaxOptions){
    });
    $(document).ajaxError(function(event, jqXHR, ajaxOptions,error){
    });
    $(document).ajaxComplete(function(event, jqXHR, ajaxOptions){
        //var ignore_script = getAjaxParams(ajaxOptions,"ignore_script");
        //console.debug(ignore_script);
        //if(ignore_script == "false"&&jqXHR.responseText){
        //
        //    $(jqXHR.responseText).closest("script").each(function(i) {
        //        console.debug($(this).text());
        //        eval($(this).text());
        //    });
        //}
        var _dom_id = get_dom_id(ajaxOptions);
        if (typeof _dom_id != 'undefined' && _dom_id != null && _dom_id.length > 0) {
            $("#"+_dom_id).removeClass("table-placeholder");
            $("#"+_dom_id).unmask();
        }else if(_dom_id != "null") {
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
      //当该元素含有disabled属性或者有class为disabled不进行提交
      if($(this).attr("disabled") || $(this).hasClass('disabled')){
          return false;
      }
      if($(this).attr('open-lov-first')){
          openLookup($(this).attr('open-lov-first'),670);
          return false;
      }
      if(parent_forms[0]){
        //对a的属性设置为target=_blank做特殊处理
        if($(this).attr("target") == '_blank' && typeof $(parent_forms[0]).attr('nomask') == 'undefined' ){
            $(parent_forms[0]).attr('nomask', 'true');
            $(parent_forms[0]).trigger("submit");
            $(parent_forms[0]).removeAttr('nomask');
        }else{
            $(parent_forms[0]).trigger("submit");
        }
      }
    });

    $('form a.submit').live('click', function(e) {
        href = $(this).attr("href");
        parent_forms = $(this).parents("form");
        e.preventDefault();
        //当该元素含有disabled属性或者有class为disabled不进行提交
        if($(this).attr("disabled") || $(this).hasClass('disabled')){
            return false;
        }
        if($(this).attr('open-lov-first')){
            openLookup($(this).attr('open-lov-first'),670);
            return false;
        }
        if(parent_forms[0]){
            var origin_target =  $(parent_forms[0]).attr("target");
            var origin_action = $(parent_forms[0]).attr("action");
            if($(this).attr("target"))
              $(parent_forms[0]).attr("target",$(this).attr("target"));
            else
              $(parent_forms[0]).removeAttr("target");
            $(parent_forms[0]).attr("action",href);
            //对a的属性设置为target=_blank做特殊处理
            if($(this).attr("target") == '_blank' && typeof $(parent_forms[0]).attr('nomask') == 'undefined' ){
                $(parent_forms[0]).attr('nomask', 'true');
                $(parent_forms[0]).trigger("submit");
                $(parent_forms[0]).removeAttr('nomask');
            }else{
                $(parent_forms[0]).trigger("submit");
            }
            if(origin_target)
                $(parent_forms[0]).attr("target",origin_target);
            else
                $(parent_forms[0]).removeAttr("target");
            if($(this).attr("target")){
              $(parent_forms[0]).attr("action",origin_action);
            }
        }
    });

    $('input[irm_uppercase]').live('blur', function(event){
        var reg = /^(_+)|[^A-Z_]/g, $this = $(this);
        if(reg.test($(this).val())){
            alert($.i18n("uppercase"));
            $this.val($this.val().toUpperCase().replace(reg, ""));
            setTimeout(function() {
                $this.focus();
            },0);
        }
        // $(this).val($(this).val().toUpperCase().replace(/^(_+)|[^A-Z_]/g, ""));
    });

    $('input[irm_uppercase]').each(function(index,n){
         $(n).attr("autocomplete", "off");
    });

    //文本框小写字母和数字下划线
    $('input[irm_lowercase_chr_only]').live('blur', function(event){
        var reg = /^(_+)|^( +)|[^a-z0-9_]/g, $this = $(this);
        if(reg.test($(this).val())){
            alert($.i18n("lowercase_chr_only"));
            $this.val($this.val().toLowerCase().replace(reg, ""));
            setTimeout(function() {
                $this.focus();
            },0);
        }
        // $(this).val($(this).val().replace(/^(_+)|^( +)|[^A-Z a-z0-9_]/g, ""));
    });

    $('input[irm_lowercase_chr_only]').each(function(index,n){
        $(n).attr("autocomplete", "off");
    });

    $('input[irm_chr_only]').live('blur', function(event){
        var reg = /^(_+)|^( +)|[^A-Z a-z0-9_]/g, $this = $(this);
        if(reg.test($(this).val())){
            alert($.i18n("chr_only"));
            $this.val($this.val().replace(reg, ""));
            setTimeout(function() {
                $this.focus();
            },0);
        }
        // $(this).val($(this).val().replace(/^(_+)|^( +)|[^A-Z a-z0-9_]/g, ""));
    });

    $('input[irm_chr_only]').each(function(index,n){
         $(n).attr("autocomplete", "off");
    });

    $('input[irm_number_only]').live('blur', function(event){
        var reg = /[^0-9]/g, $this = $(this);
        if(reg.test($(this).val())){
            alert($.i18n("number_only"));
            $this.val($this.val().replace(reg, ""));
            setTimeout(function() {
                $this.focus();
            },0);
        }
        // $(this).val($(this).val().replace(/[^0-9]/g, ""));
    });

    $('input[irm_number_and_cross]').live('blur', function(event){
        var reg = /[^- 0-9]/g, $this = $(this);
        if(reg.test($(this).val())){
            alert($.i18n("number_and_cross"));
            $this.val($this.val().replace(reg, ""));
            setTimeout(function() {
                $this.focus();
            },0);
        }
        //$(this).val($(this).val().replace(/[^- 0-9]/g, ""));
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

    /*只允许输入小数*/
    $('input[irm_pos_real_number]').live('keypress', function(event){
        if (!$.browser.mozilla) {
         if (event.keyCode && (event.keyCode < 48 || event.keyCode > 57) && event.keyCode != 46)
          event.preventDefault();
        }
        else {
         if (event.charCode && (event.charCode < 48 || event.charCode > 57) && event.charCode != 46)
          event.preventDefault();
        }
        $(this).attr("autocomplete", "off");
    });

    $('input[irm_pos_real_number]').live('blur', function(event){
        var input = $(this);
        var v = $.trim(input.val());
         var reg = new RegExp("^[0-9]+(.[0-9]{1,3})?$", "g");
         if (!reg.test(v)) {
             input.val("0");
         }
    });
    $('form:not([data-remote])').bind("submit",function(e){
         if($(this).attr("nomask"))
         {
           $(e.target).find("input[type=submit]").each(function(index,el){
               $(el).attr("disabled",true);
               $(el).addClass("disabled");
               $(el).attr("value",$.i18n("processing"));
           });
         }
         else
         {   if(!$(e.target).hasClass("masked")){
                $(e.target).mask($.i18n("processing"));
             }
         }
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
        var options = $(element).find("option");
        if(options.length==2&&$(options[0]).attr("value")==""&&$(options[1]).attr("value")!=""){
            $(element).val($(options[1]).attr("value"));
        }
    });
    //对select进行渲染,添加查询功能
    checkSelect();
    //对文件大小进行校验
    $("input[type=file]").live({change:function(){
        if (window.fileLimit)
            checkAttachment(this, 1024*(parseInt(window.fileLimit)));
    }});
    $('[placeholder]').placeholder();
});

var autoChooseFirst = function(element){
    if($(element).val()!=""){
        return
    }
    var options = $(element).find("option");
    if(options.length==2&&$(options[0]).attr("value")==""&&$(options[1]).attr("value")!=""){
        $(element).val($(options[1]).attr("value"));
    }
};

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
    var refreshNode = con.find("#filter"+seq_num);

    if(currentTarget.val()&&currentTarget.val()!=""){
       attribute_id = $(e.target).find("option[value="+$(e.target).val()+"]:first").attr("attribute_id")
     }
    var url = decodeURIComponent(con.attr("href"));
    url = url.replace("{seq_num}",seq_num);
    url = url.replace("{attribute_id}",attribute_id);

    var placeholderTr = refreshNode.parent().find("tr.placehoder:first");
    if (placeholderTr.length < 1) {
        placeholderTr = refreshNode.parent().append("<tr class='placehoder'></tr>")
        placeholderTr = placeholderTr.find("tr.placehoder:first");
    }
    placeholderTr.load(url, function () {
        refreshNode.find("td.operator-col:first").after(placeholderTr.find("td.operator-col:first"));
        refreshNode.find("td.operator-col:first").remove();
        refreshNode.find("td.value-col:first").after(placeholderTr.find("td.value-col:first"));
        refreshNode.find("td.value-col:first").remove();
    });
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
    url = encodeURI(url);
    openPopup(url, "lookup", 350, 480, "width=" + width + ",height=480,left="+(screen.width-width)/2+",top="+(screen.height-480)+",toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true)
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
    //移除提示框中的错误信息
    if($("#"+fieldId+"Tip").hasClass("alert-error")){
        $("#"+fieldId+"Tip").removeClass("alert-error");
        $("#"+fieldId+"Tip").html($("#"+fieldId+"Tip").attr("tooltip-text"));
    }
    var parent_forms = $("#"+fieldId).parents("form");
    $('a[type=submit]', $(parent_forms[0])).removeAttr('open-lov-first');
    $('a.submit', $(parent_forms[0])).removeAttr('open-lov-first');

    $("#"+fieldId+"_label").val(valueLabel);
    $("#"+fieldId+"_label").attr("data-old-value",valueLabel);
    //$("#"+fieldId+"_label").focus();
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
        $("#"+fieldId+"_label").attr("data-old-value",data.label_value);
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
        $("#"+fieldId+"_label").attr("data-old-value",data.label_value);
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

function dateFieldChooseToday(fieldId,fieldValue,timeField,timeValue){
  $("#"+fieldId).val(fieldValue);
  $("#"+fieldId).trigger("keyup");
  if(timeField && timeValue){
      $("#"+timeField).val(timeValue);
      $("#"+timeField).trigger('change');
  }
}
//END========================datepicker 帮助函数========================================

//BEGIN========================colorpicker 帮助函数========================================
function initColorField(colorField){
    var me = $(colorField);
    me.css("background-color",me.val()) ;
    me.css("color",getContrastYIQ(me.val().replace("#","")));
    me.colorpicker({format: 'hex'}).on('changeColor', function(ev){
        me.css("background-color",ev.color.toHex()) ;
        me.val(ev.color.toHex()) ;
        me.css("color",getContrastYIQ(ev.color.toHex().replace("#","")));
    });;

    me.attr("onfocus","");
    me.trigger("focus");
}

function getContrastYIQ(hexcolor){
	var r = parseInt(hexcolor.substr(0,2),16);
	var g = parseInt(hexcolor.substr(2,2),16);
	var b = parseInt(hexcolor.substr(4,2),16);
	var yiq = ((r*299)+(g*587)+(b*114))/1000;
	return (yiq >= 128) ? 'black' : 'white';
}
//END========================colorpicker 帮助函数========================================

//START =================================Ajax 监听帮助函数================================
function get_dom_id(ajaxOptions) {

    return getAjaxParams(ajaxOptions,"_dom_id");
}
function getAjaxParams(ajaxOptions,paramName) {

    var url = ajaxOptions.url||"",data=  ajaxOptions.data||"";
    if(url.indexOf("?")>-1){
        url = url.substring(url.indexOf("?")+1,url.length);
    }
    else{
        url = ""
    }
    data = data.substring(data.indexOf("?")+1,data.length);
    return $.extend({},$.deserialize(data),$.deserialize(url))[paramName];
}
//end =================================Ajax 监听帮助函数================================


//START =================================Chosen 渲染select==========w======================
function checkSelect(){
    $("select:not([multiple])").each(function(index,element){
        //如果当前select的options超过chosenMiniNum项或者chosen=true属性对其进行渲染
        if(($(element).find("option").length > chosenMiniNum && $(element).attr("chosen") != 'false') || $(element).attr("chosen") == 'true') {
            if ($(element).attr('depend')) return false;
            if (typeof $(element).attr("chosen") == 'undefined') $(element).attr("chosen",true);
            $(element).css('width', getSelectWidth($(element)));
            $(element).chosen({search_contains: true,disable_search_threshold: searchMiniNum});
        }
    });
}
//获取select宽度
function getSelectWidth(selectObj){
    if(!selectObj) return 0;
    var width = selectObj.width();
    //当select的父级元素不可见时
    if(width == 0){
        var cloneObj = selectObj.clone();
        cloneObj.css({visibility:"hidden"});
        $('body').append(cloneObj);
        width = cloneObj.width();
        cloneObj.remove();
    }
    //设置默认宽度当宽度小于100
    if(width < 100){
        width = 100
    }
    //检查元素是否设置了最大宽度
    if (selectObj.attr("max-width")){
        var maxWidth = parseInt(selectObj.attr("max-width").replace(/[^0-9]/ig, ""));
        if(width > maxWidth){
            width = maxWidth
        }
    }
    width = (width + 18) + "px";
    return width;
}
//end =================================Chosen 渲染select================================
//START =================================客户端校验文件大小================================
function checkAttachment(target, limitSize){
    var fileSize = 0;
    if ( $.browser.msie ) {
//        var file_system = new ActiveXObject("Scripting.FileSystemObject");
//        var file = file_system.GetFile($(target).val());
        fileSize = limitSize;
    }else{
        fileSize = target.files[0].size;
    }
    if(fileSize > limitSize) {
        var alertModal = $("#alertModal");
        if(alertModal.length < 1) {
            alertModal = $("<div>",{"id":"alertModal","class":"modal hide fade","style":"display: none; "});
            alertModal.append($("<div>",{"class":"modal-header"}).html("<button type='button' class='close' data-dismiss='modal'>&times;</button><h3>附件出错了</h3>"));
            alertModal.append($("<div>",{"class":"modal-body"}).html("<p>附件内容太大，请从新选择附件！</p>"));
            alertModal.append($("<div>",{"class":"modal-footer"}).html("<a href='#' data-dismiss='modal' class='btn btn-primary'>确定</a>"));
            $("body").append(alertModal);
        }
        alertModal.modal({show:true});
        $(target).val("");
        //处理模拟表单中input的值进行修改
        $(target).trigger("change");
    }
}
//end =================================客户端校验文件大小=================================

//START =================================返回顶部================================
var scrollToTop = scrollToTop || {
    setup:function () {
        var height = $(window).height() / 2;
        $(window).scroll(function () {
            (window.innerWidth ? window.pageYOffset : document.documentElement.scrollTop) >= height ? $("#scrollToTop").css("visibility", "visible") : $("#scrollToTop").css("visibility", "hidden");
        });
        $("#scrollToTop").click(function () {
            $("html, body").animate({
                scrollTop:"0px"
            },400);
            return false
        })
    }
};
//END =================================返回顶部================================

//START =================================根据bytes值返回文件大小================================
function formatFileSize(bytes){
    if (typeof bytes !== 'number') {
        return '';
    }
    if (bytes >= 1000000000) {
        return (bytes / 1000000000).toFixed(2) + ' GB';
    }
    if (bytes >= 1000000) {
        return (bytes / 1000000).toFixed(2) + ' MB';
    }
    return (bytes / 1000).toFixed(2) + ' KB';
}
//END =================================根据bytes值返回文件大小================================

function initDateTime(time_field_id, date_field_id, field_id, init_time){
    $("#"+time_field_id).timepicker({
        minuteStep: 5,
        showSeconds: true,
        secondStep: 10,
        showMeridian: false,
        showInputs: true,
        disableFocus: false
    });
    if(init_time){
        $("#"+time_field_id).val(init_time);
        $("#"+time_field_id).trigger('blur');
    }else{
        $("#"+time_field_id).val('');
    }
    var date_time = $("#"+field_id).val();
    $("#"+time_field_id).bind('change',function(){
        if($("#"+date_field_id).val()){
            date_time = $("#"+date_field_id).val() +" " + $(this).val();
            $("#"+field_id).val(date_time);
        }else{
            $("#"+field_id).val('');
        }
    });
    $("#"+date_field_id).bind('blur',function(){
        if($(this).val()){
            date_time = $(this).val() + " " + $("#"+time_field_id).val();
            $("#"+field_id).val(date_time);
        }else{
            $("#"+field_id).val('');
        }
    });
}


//START =================================检查lov输入的值================================
function checkLovResult(base_url,lov_field_id,relation_submit){
    var width = $("#"+lov_field_id +"Box").width(),relationSubmit = relation_submit;
    if(width == 0) width = 150;
    $("#"+lov_field_id +"Tip").css("width",width + "px");
    var parent_forms = $("#"+lov_field_id).parents("form");
    if(!$(parent_forms[0]).attr('id')){
        $(parent_forms[0]).attr('id', lov_field_id+'Form');
    }
    //show tip text
    $("#"+lov_field_id +"_label").bind('focus', function(){
        $("#"+lov_field_id +"Tip").show();
    });

    $("#"+lov_field_id +"_label").bind('blur',function(e){
        $("#"+lov_field_id +"Tip").hide();
        if($("#"+lov_field_id +"_label").val() === '' || $("#"+lov_field_id +"_label").val() === $("#"+lov_field_id +"_label").attr("placeholder")){
            $("#"+lov_field_id +"Tip").removeClass("alert-error");
            $("#"+lov_field_id +"Tip").html($("#"+lov_field_id +"Tip").attr("tooltip-text"));
            return false;
        }
        if($("#"+lov_field_id +"_label").val() === $("#"+lov_field_id +"_label").attr('data-old-value')){
            return false;
        }
        var url = base_url + "&lksrch="+$("#"+lov_field_id +"_label").val();
        url += '&_dom_id='+$(parent_forms[0]).attr('id');
        $.ajax({
            url:encodeURI(url),
            type:"GET",
            dataType:"json",
            error: function(data){},
            success: function(data){
                if(data.status == 'success'){
                    setTimeout(function () {lookupPick(lov_field_id,data.value,data.label,data);},100);
                }else{
                    $("#"+lov_field_id +"_label").attr('data-old-value', $("#"+lov_field_id +"_label").val());
                    $("#"+lov_field_id).val('');
                    if(data.num == 0){
                        $("#"+lov_field_id +"Tip").addClass("alert-error");
                        $("#"+lov_field_id +"Tip").html($("#"+lov_field_id +"Tip").attr("tooltip-error-text"));
                        $("#"+lov_field_id +"_label").focus();
                    }
                    url = url.replace(/lov_result/,'lov');
                    if(data.num > 1){
                        openLookup(url,670);
                    }
                    if(relationSubmit === 'true'){
                        $('a[type=submit]', $(parent_forms[0])).attr('open-lov-first', url);
                        $('a.submit', $(parent_forms[0])).attr('open-lov-first',url);
                    }
                }
            }
        });
    })
}
//END =================================检查lov输入的值================================