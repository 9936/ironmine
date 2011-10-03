// 级联下拉列表
jQuery.fn.cascade = function(target_or_targets,event) {
    var OPTIONS_TEMPLATE = "<option value=${value}>${label}</option>";
    var source = this;

    var targets = [];
    if(jQuery.isArray(target_or_targets)){
        targets = target_or_targets
    }else{
        targets = [String(target_or_targets)]
    }

    function _processEvent(){
        for(var i=0;i<targets.length;i++){
            var target = jQuery(targets[i]);
            // 取得加载数据的链接
            var href = target.attr("href");
            var depends = target.attr("depend");
            if(depends!="")
                depends=depends.split(",");
            else
                depends = [];
            var url_options = {};
            var value_length = 0;

            for(var j=0;j<depends.length;j++){
              if(jQuery("#"+depends[j]).val()&&jQuery("#"+depends[j]).val()!=""){
                url_options[depends[j]] = jQuery("#"+depends[j]).val();
                value_length++;
              }
            }
            //decodeURIComponent
            if(value_length==depends.length||value_length>0){
                target.html("");
                if(target.attr("blank")!=""){
                  option =  jQuery(jQuery.tmpl(OPTIONS_TEMPLATE,{label:target.attr("blank"),value:""})) ;
                  target.append(option);
                }
                href = jQuery.tmpl(decodeURIComponent(href),url_options).text();
                jQuery.getJSON(href,{},function(datas){
                    var targetValue = target.attr("origin_value");
                    datas = datas["items"] ;
                    if(!datas)
                      datas = [];
                    jQuery.each(datas,function(index,data){
                        var option = jQuery('<option/>');
                        for(var v in data){
                            if(v=="label")
                                option.html(data[v]);
                            else
                                option.attr(v,data[v]);
                        }

                        target.append(option);
                    });

                    target.val(targetValue);
                    target.trigger('change');
                });
            }else
            {   target.html("");
                if(target.attr("blank")!=""){
                  option =  jQuery(jQuery.tmpl(OPTIONS_TEMPLATE,{label:target.attr("blank"),value:""})) ;
                  target.append(option);
                }
                target.val("");
                target.trigger("change");
            }
        }
    }
    jQuery(this).change(_processEvent);
    return this;
}

//菜单下拉按钮
jQuery.fn.menubutton = function(){
    var menuNode = this;
    var _menuContent = jQuery(this).find(".menuContent:first");
    var _menuLabel = jQuery(this).children(".menuLabel:first");
    _menuLabel.hover(function(){
        jQuery(this).addClass("menuLabelHover");
    },function(){
        jQuery(this).removeClass("menuLabelHover");
    });

    _menuLabel.click(function(e){
        if(jQuery(this).hasClass("menuLabelClick")){
            jQuery(this).removeClass("menuLabelClick");
            _menuContent.removeClass("menuContentVisual");
            jQuery(this).removeClass("menuLabelHover");
            jQuery(document).unbind("click",_globalClickHandler);
        }else
        {
            jQuery(this).addClass("menuLabelClick");
            _menuContent.addClass("menuContentVisual");
            jQuery(document).bind("click",_globalClickHandler);
        }
    });

    var _globalClickHandler = function(e){
        if(jQuery(menuNode).find(e.target).length<1){
            if(_menuLabel.hasClass("menuLabelClick")){
                _menuLabel.removeClass("menuLabelClick");
                _menuContent.removeClass("menuContentVisual");
                _menuLabel.removeClass("menuLabelHover");
            }
            jQuery(document).unbind("click",_globalClickHandler);
        }
    }
}


//树开菜单
jQuery.fn.navtree = function(){

}


//树开菜单
jQuery.duelselect = function(){

}