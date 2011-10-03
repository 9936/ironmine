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
};

//菜单下拉按钮
jQuery.fn.menubutton = function(){
    var menuNode = this;
    var _menuContent = jQuery(this).find(".menuContent:first");
    var _menuLabel = jQuery(this).find(".menuLabel:first");
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
};


//树开菜单
jQuery.fn.navtree = function(){

};


// Ironmine duelselect
(function($)
{
       // 插件名称
    var PLUGIN_NAME = "duelselect";

    // 插件默认配置参数
    var DEFAULT_OPTIONS =
    {

    };

    // 插件实例计数器
    var pluginInstanceIdCount = 0;


    // 插件内部类工厂方法
    var I = function(/*HTMLElement*/ element)
    {
        if($(element).data(PLUGIN_NAME))
            return $(element).data(PLUGIN_NAME)["target"];
        else
            return new Internal(element);
    };


    // 定义插件内部类
    var Internal = function(/*HTMLElement*/ element)
    {
        var me = this;
        this.$element = $(element);
        this.element = element;
        this.data = this.getData();

        // Shorthand accessors to data entries:
        this.id = this.data.id;
        this.options = this.data.options;

        this.typeSelect = this.$element.find("select.duel-type:first");
        this.searchInput = this.$element.find("input.duel-query:first");
        this.searchButton = this.$element.find("a.duel-search-button:first");
        this.addButton = this.$element.find("a.duelAdd:first");
        this.removeButton = this.$element.find("a.duelRemove:first");
        this.upButton = this.$element.find("a.duelUp:first");
        this.downButton = this.$element.find("a.duelDown:first");
        this.sourceSelect = this.$element.find("select.source:first");
        this.targetSelect = this.$element.find("select.target:first");
        this.hiddenValue = this.$element.find("input.duelValue:first");

        // 初始化时记录已经选中的值
        this.selectedValues = this.hiddenValue.val().split(",");
        this.storedOptions = [];
        $.each(this.sourceSelect.find("option"),function(index,option){
            $(option).attr("html",$(option).html());
            me.storedOptions.push(option);
        });
        // 绑定事件
        if(this.addButton){
            this.addButton.click(this,function(event){me.add()});
        }

        if(this.removeButton){
            this.removeButton.click(this,function(event){me.remove()})
        }

        if(this.upButton){
            this.upButton.click(this,function(event){me.up()})
        }

        if(this.downButton){
            this.downButton.click(this,function(event){me.down()})
        }

        if(this.typeSelect){
            this.typeSelect.change(this,function(event){me.syncUI()})
        }

        if(this.searchInput){
            this.searchInput.keydown(this,function(event){
                if(event.keyCode=="13")
                    me.syncUI();
            });
        }


        if(this.searchButton){
            this.searchButton.click(this,function(event){
                    me.syncUI();
            });
        }
    };

    /**
     * 定义插件内部类的方法，内部类方法实现插件的内部逻辑，不能从外部访问
     */

    // 初始化内部类
    Internal.prototype.init = function(/*Object*/ customOptions)
    {
        var data = this.getData();

        // 初始化插件内部数据
        if (!data.initialised)
        {
            data.initialised = true;
            data.options = $.extend(DEFAULT_OPTIONS, customOptions);
        }

        this.syncUI();

    };

    /**
     * 取得使用插的Element的内部数据
     * 如果没有，则初始化一份，为Eelement生成插件id ，并标记为新生成的数据，等待初始化
     *
     */
    Internal.prototype.getData = function()
    {
        if (!this.$element.data(PLUGIN_NAME))
        {
            this.$element.data(PLUGIN_NAME, {
                id : pluginInstanceIdCount++,
                initialised : false,
                target: this
            });
        }

        return this.$element.data(PLUGIN_NAME);
    };


    /**
     * Returns the event namespace for this widget.
     * The returned namespace is unique for this widget
     * since it could bind listeners to other elements
     * on the page or the window.
     */
    Internal.prototype.getEventNs = function(/*boolean*/ includeDot)
    {
        return (includeDot !== false ? "." : "") + PLUGIN_NAME + "_" + this.id;
    };

    /**
     * Removes all event listeners, data and
     * HTML elements automatically created.
     */
    Internal.prototype.destroy = function()
    {
        this.$element.unbind(this.getEventNs());
        this.$element.removeData(PLUGIN_NAME);
    };


    Internal.prototype.syncUI = function(){

        this.targetSelect.html("");
        this.sourceSelect.html("");
        var unselectedOptions = [];
        var selectedOptions = new Array(this.selectedValues.length);
        for(var i=0;i< this.storedOptions.length;i++){
            var option = $(this.storedOptions[i]);
            option.html(option.attr("html"));

            var selectableOption = option;

            if(this.present(this.duelType())&&this.duelType()!=option.attr("type")){
              selectableOption = null;
            }
            if(this.present(this.duelQuery())&&option.attr("query").indexOf(this.duelQuery())<0){
              selectableOption = null;
            }
            var valueIndex =  $.inArray(option.attr("value"),this.selectedValues);
            if(valueIndex > -1){
              selectedOptions[valueIndex] = option;
              selectableOption = null;
            }

            if(selectableOption)
              unselectedOptions.push(selectableOption);
        }

        for(var i=0;i<unselectedOptions.length;i++){
            this.sourceSelect.append(unselectedOptions[i]);
        }
        for(var i=0;i<selectedOptions.length;i++){
            this.targetSelect.append(selectedOptions[i]);
        }
    }

    Internal.prototype.syncValue = function(){
        this.hiddenValue.val(this.selectedValues.join(","));
    }

    Internal.prototype.present = function(value){
        return value&&value!=""
    }

    Internal.prototype.duelType = function(value){
        if(this.typeSelect)
            return this.typeSelect.val();
        else
            return null;
    }

    Internal.prototype.duelQuery = function(value){
        if(this.searchInput)
            return this.searchInput.val();
        else
            return null;
    }

    Internal.prototype.add = function(){

      var addValues = this.sourceSelect.val();
      this.selectedValues = this.selectedValues.concat(addValues);
      this.syncValue();
      this.syncUI();
    }
    Internal.prototype.remove = function(){
      var newValues = [];
      var removeValues = this.targetSelect.val();
      for(var e in this.selectedValues){
        if($.inArray(this.selectedValues[e],removeValues)<0)
          newValues.push(this.selectedValues[e]);
      }
      this.selectedValues = newValues;
      this.syncValue();
      this.syncUI();
    }
    Internal.prototype.up = function(){
      var newValues = [];
      var selectedValues = this.targetSelect.val();
      if(selectedValues.length<1)
        return;
      var firstIndex = $.inArray(selectedValues[0],this.selectedValues);
      if(firstIndex == 0)
        return;
      for(var i=0;i<firstIndex-1;i++){
        newValues.push(this.selectedValues[i]);
      }
      for(var i= 0;i<selectedValues.length;i++){
        newValues.push(selectedValues[i]);
      }
      for(var i=firstIndex-1;i<this.selectedValues.length;i++){
        if($.inArray(this.selectedValues[i],selectedValues)<0)
          newValues.push(this.selectedValues[i]);
      }
      this.selectedValues = newValues;
      this.syncValue();
      this.syncUI();
    }
    Internal.prototype.down = function(){
      var newValues = [];
      var selectedValues = this.targetSelect.val();
      if(selectedValues.length<1)
        return;
      var firstIndex = $.inArray(selectedValues[0],this.selectedValues);
      if(firstIndex == this.selectedValues.length-1)
        return;
      for(var i=0;i<firstIndex;i++){
          newValues.push(this.selectedValues[i]);
      }
      for(var i=firstIndex+1,addedFirst = true;addedFirst&&i<this.selectedValues.length;i++){
         if($.inArray(this.selectedValues[i],selectedValues)<0){
            newValues.push(this.selectedValues[i]);
            addedFirst = false;
         }
      }
      for(var i= 0;i<selectedValues.length;i++){
        newValues.push(selectedValues[i]);
      }
      for(var i=firstIndex+1;i<this.selectedValues.length;i++){
        if($.inArray(this.selectedValues[i],selectedValues)<0&&$.inArray(this.selectedValues[i],newValues)<0)
          newValues.push(this.selectedValues[i]);
      }
      this.selectedValues = newValues;
      this.syncValue();
      this.syncUI();
    }



    // 插件的公有方法

    var publicMethods =
    {
        init : function(/*Object*/ customOptions)
        {
            return this.each(function()
            {
                I(this).init(customOptions);
            });
        },

        destroy : function()
        {
            return this.each(function()
            {
                I(this).destroy();
            });
        }

        // TODO: Add additional public methods here.
    };

    $.fn[PLUGIN_NAME] = function(/*String|Object*/ methodOrOptions)
    {
        if (!methodOrOptions || typeof methodOrOptions == "object")
        {
            return publicMethods.init.call(this, methodOrOptions);
        }
        else if (publicMethods[methodOrOptions])
        {
            var args = Array.prototype.slice.call(arguments, 1);

            return publicMethods[methodOrOptions].apply(this, args);
        }
        else
        {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);