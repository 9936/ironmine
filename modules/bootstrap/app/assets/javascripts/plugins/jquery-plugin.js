// 级联下拉列表
(function($)
{
       // 插件名称
    var PLUGIN_NAME = "cascade";

    var OPTIONS_TEMPLATE = "<option value=${value}>${label}</option>";
    // 插件默认配置参数
    var DEFAULT_OPTIONS =
    {
        targets:[]
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
            var targets = [];
            if($.isArray(customOptions)){
                targets = customOptions
            }else{
                targets = [String(customOptions)]
            }

            data.options = $.extend({},DEFAULT_OPTIONS, {targets:targets});
        }

        var me = this;
        me.$element.change(function(event){
            me.processEvent();
        });
        me.processEvent();


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

    Internal.prototype.processEvent = function(){
        var me = this;
        var targets = me.data.options.targets;

        for(var i=0;i<targets.length;i++){
            var target = $(targets[i]);
            // 取得加载数据的链接
            var href = target.attr("href");
            var depends = target.attr("depend")||"";
            if(depends!="")
                depends=depends.split(",");
            else
                depends = [];
            var url_options = {};
            var value_length = 0;

            for(var j=0;j<depends.length;j++){
              if($("#"+depends[j]).val()&&$("#"+depends[j]).val()!=""){
                url_options[depends[j]] = $("#"+depends[j]).val();
                value_length++;
              }
            }
            //decodeURIComponent
            if(value_length==depends.length||value_length>0){
                target.html("");
                if(target.attr("blank")!=""){
                  option =  $($.tmpl(OPTIONS_TEMPLATE,{label:target.attr("blank"),value:""})) ;
                  target.append(option);
                }
                href = $.tmpl(decodeURIComponent(href),url_options).text();
                //创建代理函数，修改this
                var processor =  me.processResult.customCreateDelegate({me:me,index:i});
                //获取当前的表单的id
                var dom_id = $($(me.$element).parents("form")[0]).attr("id");
                $.getJSON(href,{_dom_id:dom_id},processor);
            }else
            {   target.html("");
                if(target.attr("blank")!=""){
                  option =  $($.tmpl(OPTIONS_TEMPLATE,{label:target.attr("blank"),value:""})) ;
                  target.append(option);
                }
                target.val("");
                target.trigger("change");
            }
        }
    }

    Internal.prototype.processResult = function(datas){
        var me = this.me;
        var i = this.index;
        var targets = me.data.options.targets;
        var targetValue = $(targets[i]).attr("origin_value");

        datas = datas["items"] ;
        if(!datas)
          datas = [];
        $.each(datas,function(index,data){
            var option = $('<option/>');
            for(var v in data){
                if(v=="label")
                    option.html(data[v]);
                else
                    option.attr(v,data[v]);
            }

            $(targets[i]).append(option);
        });

        // 使用 setTimeout防止IE6中 报 [无法设置selected属性。未指明的错误。]的错误.
        setTimeout(function() {
            $(targets[i]).val(targetValue);

            // 自动选择第一个
            if($(targets[i]).attr("irequired"))
                autoChooseFirst(targets[i]);

            $(targets[i]).trigger('change');
        },1);

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

        if (methodOrOptions ) {
            return publicMethods.init.apply( this, arguments );
        } else {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);


//菜单下拉按钮
jQuery.fn.menubutton = function(){
    var menuNode = this;
    var _menuContent = jQuery(this).find(".menu-content:first");
    var _menuLabel = jQuery(this).find(".menu-label:first");
    _menuLabel.hover(function(){
        jQuery(this).addClass("menu-label-hover");
    },function(){
        jQuery(this).removeClass("menu-label-hover");
    });

    _menuLabel.click(function(e){
        if(jQuery(this).hasClass("menu-label-click")){
            jQuery(this).removeClass("menu-label-click");
            _menuContent.removeClass("menu-content-visual");
            jQuery(this).removeClass("menu-label-hover");
            jQuery(document).unbind("click",_globalClickHandler);
        }else
        {
            jQuery(this).addClass("menu-label-click");
            _menuContent.addClass("menu-content-visual");
            jQuery(document).bind("click",_globalClickHandler);
        }
    });

    var _globalClickHandler = function(e){
        if(jQuery(menuNode).find(e.target).length<1){
            if(_menuLabel.hasClass("menu-label-click")){
                _menuLabel.removeClass("menu-label-click");
                _menuContent.removeClass("menu-content-visual");
                _menuLabel.removeClass("menu-label-hover");
            }
            jQuery(document).unbind("click",_globalClickHandler);
        }
    }
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
        this.addButton = this.$element.find("a.duel-add:first");
        this.removeButton = this.$element.find("a.duel-remove:first");
        this.upButton = this.$element.find("a.duel-up:first");
        this.downButton = this.$element.find("a.duel-down:first");
        this.sourceSelect = this.$element.find("select.source:first");
        this.targetSelect = this.$element.find("select.target:first");
        this.hiddenValue = this.$element.find("input.duel-value:first");

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
            data.options = $.extend({},DEFAULT_OPTIONS, customOptions);
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
        var newValues =  new Array(this.selectedValues.length);
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
              newValues[valueIndex] = this.selectedValues[valueIndex];
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


        var orderedValues = []
        for(var i=0;i<newValues.length;i++){
            if(newValues[i]){
                orderedValues.push(newValues[i]);
            }
        }
        this.selectedValues = newValues;
        this.syncValue();
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
      this.syncUI();
    }

    Internal.prototype.removeItemForType=function(type){
        var newStoreOptions = []
        for(var i=0;i< this.storedOptions.length;i++){
            var option = $(this.storedOptions[i]);
            if(type!=option.attr("type")){
              newStoreOptions.push(this.storedOptions[i]);
            }
        }

        this.storedOptions = newStoreOptions;
        this.syncUI();

    }

    Internal.prototype.addItem=function(items){
        var template = "<option value='${value}' html='${html}' query='${query}' type='${type}'>${html}</option>";
        for(var i=0;i<items.length;i++){
            var item = items[i];
            var item_str = $.tmpl(template,item);
            this.storedOptions.push(item_str);
        }
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
        removeItemForType : function(/*Object*/ customOptions)
        {
            return this.each(function()
            {
                I(this).removeItemForType(customOptions);
            });
        },
        addItem : function(/*Object*/ customOptions)
        {
            return this.each(function()
            {
                I(this).addItem(customOptions);
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

        if ( publicMethods[methodOrOptions] ) {
            return publicMethods[methodOrOptions].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof methodOrOptions === 'object' || ! methodOrOptions ) {
            return publicMethods.init.apply( this, arguments );
        } else {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);

// Ironmine duelselect
(function($)
{
       // 插件名称
    var PLUGIN_NAME = "menutree";

    // 插件默认配置参数
    var DEFAULT_OPTIONS =
    {
        open:[]
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
            data.options = $.extend({},DEFAULT_OPTIONS, customOptions);
        }

        this.createTree();

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



    Internal.prototype.createTree = function(){
        var opened_menus = this.data.options["open"];
        var cookie_menus = [];
        opened_menus = opened_menus.concat(cookie_menus);

        this.$element.find(".nav-icon-link").click(function(event){
          if($(this).hasClass("nav-tree-col")){
            $(this).removeClass("nav-tree-col");
            $(this).addClass("nav-tree-exp");
            $('#tree_'+$(this).attr("real")+"_child").css({display:"block"});
            var menu_code =  $(this).attr("real");

          }
          else{
            $(this).removeClass("nav-tree-exp");
            $(this).addClass("nav-tree-col");
            $('#tree_'+$(this).attr("real")+"_child").css({display:"none"});
            var menu_code =  $(this).attr("real");
          }

        });

        for(var i=0;i<opened_menus.length;i++){
            $("a.nav-icon-link[real='"+opened_menus[i]+"']").each(function(index,child){
                $(child).parents(".parent").each(function(index,parent){
                    var icon_link = $(parent).find(".nav-icon-link:first");
                    if(icon_link&&icon_link.hasClass("nav-tree-col")) {
                        icon_link.trigger("click");
                    }
                });
            });
            var leaf = $("div.setup-leaf[ti="+opened_menus[i]+"]:first");
            if(leaf)
                leaf.addClass("setup-highlight-leaf");
        }
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

        if ( publicMethods[methodOrOptions] ) {
            return publicMethods[methodOrOptions].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof methodOrOptions === 'object' || ! methodOrOptions ) {
            return publicMethods.init.apply( this, arguments );
        } else {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);


// Ironmine elastic textarea
(function($)
{
     // 插件名称
    var PLUGIN_NAME = "elastic";

    // 插件默认配置参数
    var DEFAULT_OPTIONS =
    {
        minHeight: 10,
        maxHeight: 150,
        growBy : 20 ,
        forceFitWidth: false
    };

    var STYLES = ['padding-top', 'padding-bottom', 'padding-left', 'padding-right', 'line-height', 'font-size', 'font-family', 'font-weight', 'font-style'];

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
            data.options = $.extend({},DEFAULT_OPTIONS, customOptions,{minHeight:this.$element.height()});
        }

        this.bindTextArea();

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



    Internal.prototype.bindTextArea = function(){
        var me = this;
        if(me.data.options.forceFitWidth)
        {
            me.$element.width(me.$element.parent().innerWidth() - 30);
        }
        if(!me.div){
            var textareaStyles = me.getStyles(STYLES,me.$element)
            me.div = $("<div></div>").attr("id",me.id);
            me.div.css(textareaStyles).css({position: "absolute", top: "-100000px", left: "-100000px"});
        }
        $("body:first").append(me.div);

        me.$element.keyup(function(event) {
            if(event.keyCode == "13"||event.keyCode == "8")
                me.resizeTextArea(true);
        });
    }


    Internal.prototype.resizeTextArea = function(){
        var me = this;
        var maxHeight = me.data.options.maxHeight;
        var minHeight = me.data.options.minHeight;

        me.div.html(
            me.$element.val().replace(/<br \/>&nbsp;/, '<br />')
                        .replace(/<|>/g, ' ')
                        .replace(/&/g,"&amp;")
                        .replace(/\n/g, '<br />&nbsp;')
        );

        var textHeight = me.div.height();
        var growBy = me.data.options.growBy;
        if ( (textHeight > maxHeight ) && (maxHeight > 0) ){
              textHeight = maxHeight ;
              me.$element.css({overflow:auto});
        }
        if ( (textHeight < minHeight ) && (minHeight > 0) ) {
            textHeight = minHeight ;
        }
         //resize the text area
         me.$element.height(textHeight + growBy);
    }


    Internal.prototype.getStyles = function(style_keys,element){
        var length = style_keys.length;
        var ret = {};
        for(var i = 0 ;i<length;i++){
          ret[style_keys[i]] = element.css(style_keys[i]);
        }
        return ret;
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

        if ( publicMethods[methodOrOptions] ) {
            return publicMethods[methodOrOptions].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof methodOrOptions === 'object' || ! methodOrOptions ) {
            return publicMethods.init.apply( this, arguments );
        } else {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);



// Ironmine file upload
(function($)
{
     // 插件名称
    var PLUGIN_NAME = "upload_file";

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
            data.options = $.extend({},DEFAULT_OPTIONS, customOptions);
        }

        this.bindUpload();

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



    Internal.prototype.bindUpload = function(){
        var me = this;
        me.$element.find(".file-buttons a.add-file").click();

        me.$element.find(".file-buttons .add-file").click(function(event){
            var templateElement = me.$element.find("tbody.file-template");
            var sequence = templateElement.attr("sequence");
            templateElement.attr("sequence",sequence+1);
            var row = $.tmpl(templateElement.html(), {sequence:sequence,ref:"files"});
            me.$element.find("tbody.file-contents").append(row);
        });
        $("table#"+me.$element.attr("id")+" .file-contents .delete-file").live("click",function(event){
            me.$element.find(".file-item[ref="+$(this).attr("delete_ref")+"]").remove();
        }) ;
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

        if ( publicMethods[methodOrOptions] ) {
            return publicMethods[methodOrOptions].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof methodOrOptions === 'object' || ! methodOrOptions ) {
            return publicMethods.init.apply( this, arguments );
        } else {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);

// Ironmine datatable for limit device
(function($)
{
     // 插件名称
    var PLUGIN_NAME = "datatable";

    // 插件默认配置参数
    var DEFAULT_OPTIONS =
    {
        pageSize: 10,
        totalCount: 0,
        currentPage:0,
        baseUrl: "",
        filterBox: null,
        searchBox: null,
        paginatorBox: null,
        exportBox: null,
        columns :[],
        scrollOptions:{},
        defaultOptions:{},
        filterOptions:{},
        searchOptions:{},
        orderOptions:{}
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
            data.options = $.extend({},DEFAULT_OPTIONS, customOptions);
        }

        this.buildTable();

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



    Internal.prototype.buildTable = function(){
        var me = this;
        me.data.options = $.extend({},me.data.options,{currentPage:1});
        me.buildUI();
        me.load();
    };

    //初始化checkbox
    Internal.prototype.buildCheckbox = function(){
        var me = this;
        // 仅在表格有数据时,才显示checkbox
        if(parseInt(me.$element.find(".table-body table:first").attr("count")) <= 0) return;
        if(me.data.options.selectType) {
            //标题栏
            var ids = [];
            var table_th = me.$element.find(".include-header table:first thead th:first");
            if(me.data.options.selectType == 'multiple') {
                var th_check_box = $("<input type='checkbox' name='select_all'/>").attr("title", $.i18n("select_all"));
                table_th.before($("<th/>").css({width:'15px'}).html($("<div/>").html(th_check_box)));
                //添加全选和反选事件
                th_check_box.click(function(e){
                    ids = [];
                    if ($(this).is(':checked')){
                        me.$element.find(".table-body table:first tbody input[name='ids']").each(function(){
                            $(this).attr("checked", true);
                            ids.push($(this).val());
                        });
                    }else{
                        me.$element.find(".table-body table:first tbody input[name='ids']").each(function(){
                            $(this).removeAttr("checked");
                        });
                    }
                    e.ids = ids;
                    me.$element.trigger('selectionchange',[ids]);
                });
            }else{
                table_th.before($("<th/>").css({width:'15px'}).html($("<div/>")));
            }
            //表格列表中的值
            //判断当前表格中是否有数据，没有数据直接跳出该方法

            me.$element.find(".table-body table:first tbody tr").each(function(){
               var table_td = $(this).find("td:first");
               //获取id
               var item_id = $(this).attr("id"),
                   td_check_box = $("<input type='checkbox' name='ids' value='"+item_id+"'/>");
               table_td.before($("<td/>").html($("<div/>").html(td_check_box)));
               //更新全选框
               var hand_click = function(e){
                   if(!$(this).is(td_check_box)) {
                      if(td_check_box.is(':checked')) {
                         td_check_box.removeAttr("checked");
                      }else{
                         td_check_box.attr("checked", true);
                      }
                   }
                   if(me.data.options.selectType == 'multiple') {
                       var all_selected = true;
                       ids = [];
                       me.$element.find(".table-body table:first tbody input[name='ids']").each(function(){
                          if ($(this).is(':checked')) {
                              ids.push($(this).val());
                          }else{
                              all_selected = false;
                          }
                       });
                       if(all_selected && !th_check_box.is(':checked')) {
                          th_check_box.attr("checked", true);
                       }
                       if(!all_selected && th_check_box.is(':checked')) {
                         th_check_box.removeAttr("checked")
                       }
                   }else{
                       if(td_check_box.is(':checked')) {
                           me.$element.find(".table-body table:first tbody input[name='ids']").each(function(){
                               if(!$(this).is(td_check_box)) {
                                   $(this).removeAttr("checked");
                               }
                           });
                       }
                   }
                   e.ids = ids;
                   me.$element.trigger('selectionchange',[ids]);
                   e.stopPropagation()||(e.cancelBubble = true);
               };
               table_td.parent().bind('click', hand_click);
               td_check_box.bind('click', hand_click);
            });
        }
    };
    //初始化排序列
    Internal.prototype.buildOrderColumn = function(){
        var me = this;

        me.$element.find(".include-header table:first thead th[sort]").each(function(){
            var currentColumn = $(this);
            currentColumn.addClass("sortable");
            //将当前的光标变为手形，并提交提示信息
            //var sortIcon = $("<a class='sortable' href='javascript:void(0);'>sort</a>")
            //currentColumn.find("div").attr("title",$.i18n("sort_this_column"));
            //var column_name = current_th.attr("key");
            //如果当前没有传递指定排序，默认显示第一列
            if(me.data.options.orderOptions["order_name"] == currentColumn.attr("key")){
                var sortIcon = $("<a class='sort-icon' href='javascript:void(0);'>sort</a>");
                var className = me.data.options.orderOptions["order_value"] == "DESC"? "sort-desc" : "sort-asc";
                sortIcon.addClass(className);
                currentColumn.find("div").append(sortIcon);
            }
            currentColumn.bind("click", function(){
                //将其他所有的排序标志不可见
                var orderValue = '';
                $(this).parent().find('a.sort-icon').each(function(){
                    $(this).hide();
                });
                if($(this).find("a.sort-icon").length<1){
                    $(this).find("div").append($("<a class='sort-icon' href='javascript:void(0);'>sort</a>"));
                }
                if ($(this).find("a.sort-icon").hasClass("sort-desc")) {
                    orderValue = "ASC";
                    $(this).find("a.sort-icon").removeClass("sort-desc").addClass("sort-asc");
                }else{
                    orderValue = "DESC";
                    $(this).find("a.sort-icon").removeClass("sort-asc").addClass("sort-desc")
                }
                $(this).find("a.sort-icon").show();
                me.data.options.orderOptions["order_name"] = $(this).attr("key");
                me.data.options.orderOptions["order_value"] = orderValue;
                me.loadPage(1);
            });
        });

    }

    Internal.prototype.buildUI = function(){
        var me = this;
        //build paginator
        if(me.data.options.paginatorBox)
        {   var paginatorBox = $("#"+me.data.options.paginatorBox);
            me.paginator = $('<div class="paginator form-inline">' +
                               '<span class="paginator-left">' +
                                 '<a class="paginator-button paginator-first-page"><i></i></a>' +
                                 '<a class="paginator-button paginator-pre-page"><i></i></a>' +
                                 '<span class="paginator-button paginator-split"><i></i></span>' +
                                 '<span class="paginator-button">' +
                                   '<span class="paginator-before-page"></span>' +
                                   '<input class="paginator-current-page"/>' +
                                   '<span class="paginator-after-page"></span>' +
                                 '</span>'+
                                 '<span class="paginator-button paginator-split"><i></i></span>' +
                                 '<a class="paginator-button paginator-next-page"><i></i></a>' +
                                 '<a class="paginator-button paginator-last-page"><i></i></a>' +
                                 '<span class="paginator-button paginator-split"><i></i></span>' +
                                 '<a class="paginator-button paginator-refresh"><i></i></a>' +
                               '</span>'+
                               '<span class="paginator-center">' +

                               '</span>'+
                               '<span class="paginator-right">' +
                                 '<span>' +
                                   '<span>'+$.i18n("paginatorBeforeSize")+'</span>' +
                                   '<span class="select-page-size"><select name="page-size"><option value="10">10</option><option value="20">20</option><option value="50">50</option><option value="100">100</option></select></span>' +
                                   '<span>'+$.i18n("paginatorAfterSize")+'</span>' +
                                 '</span>' +
                                 '<span class="paginator-record-label"></span>' +
                               '</span>'+
                             '</div>');
            paginatorBox.append(me.paginator);
            paginatorBox.find(".paginator-first-page:first").click(function(event){
                if(!$(this).find("i:first").hasClass("disabled"))
                    me.loadPage(1);
            });
            paginatorBox.find(".paginator-pre-page:first").click(function(event){
                if(!$(this).find("i:first").hasClass("disabled"))
                    me.prePage();
            });
            paginatorBox.find(".paginator-next-page:first").click(function(event){
                if(!$(this).find("i:first").hasClass("disabled"))
                    me.nextPage();
            });
            paginatorBox.find(".paginator-last-page:first").click(function(event){
                if(!$(this).find("i:first").hasClass("disabled")) {
                    var options = me.data.options;
                    me.loadPage(Math.ceil(options.totalCount/options.pageSize));
                }
            });
            paginatorBox.find("select[name='page-size']:first").change(function(){
                if (me.data.options.pageSize != $(this).val()) {
                    me.data.options.pageSize = $(this).val();
                    me.loadPage(1);
                }
            });
            paginatorBox.find(".paginator-refresh:first").click(function(event){
                if(!$(this).find("i:first").hasClass("disabled"))
                    me.load();
            });
            paginatorBox.find(".paginator-current-page:first").keyup(function(event){
                var value = $(this).val();
                var keyCode =  parseInt(event.keyCode);
                if(keyCode<48&&keyCode>57){
                  value=value.replace(/[^\d]/g,'') ;
                }
                //value = me.getRightPage(value);
                $(this).val(value);
                if(keyCode==13){

                    me.loadPage(value);
                }


            });
            me.syncPaginatorUI();
        }
        //build searchbox
        if(me.data.options.searchBox)
        {
            var show_able = false;
            var searchBox = $("#"+me.data.options.searchBox);
            if(searchBox){
                searchBox.css({display:"none"});

                var search_template = '<div class="datable-search-box form-inline">'+
                                        '<select class="search-select"></select>'+
                                        '<div class="input-append">'+
                                          '<input class="search-box-input" type="text" />'+
                                          '<a class="add-on btn search-box-button" href="javascript:void(0)"></a>'+
                                        '</div>'+
                                      '</div>'
                searchBox.append($(search_template));
                searchBox.find("a.search-box-button:first").html($.i18n("search"));

                searchBox.find("a.search-box-button:first").click(function(event){
                        var params = {};
                        params[searchBox.find("select.search-select:first").val()] = searchBox.find("input.search-box-input:first").val();
                        me.data.options.searchOptions = params;
                        me.loadPage(1);
                });

                searchBox.find("input.search-box-input:first").keydown(function(event){
                    if(event.keyCode==13){
                        searchBox.find("a.search-box-button:first").trigger("click")
                    }
                });
            }
        }
        //build viewFilter
        if(me.data.options.filterBox)
        {
            var filterBox = $("#"+me.data.options.filterBox)
            if(filterBox){
                var selectElement = filterBox.find("select.view-filter:first");
                me.data.options.filterOptions = {_view_filter_id:selectElement.val()||""};

                selectElement.change(function(event){
                    me.data.options.filterOptions = {_view_filter_id:$(this).val()||""};
                    me.loadPage(1);
                });

                var editLink = filterBox.find("a.edit-link:first");

                editLink.click(function(event){
                    var link =  $(event.currentTarget);
                    if(!link.attr("thref")){
                        link.attr("thref",link.attr("href"))
                    }
                    var href = decodeURIComponent(link.attr("thref"));
                    href = href.replace("{id}",selectElement.val());
                    link.attr("href",href);
                    if(!selectElement.val())
                      event.preventDefault();
                });
                filterBox.css({display:"block"});
            }
        }

        if(me.data.options.exportBox){
            if(me.data.options.exportBox.indexOf("#")<0)
                me.data.options.exportBox = "#"+me.data.options.exportBox;
            $(me.data.options.exportBox).click(function(event){
                var url = me.buildCurrentRequest();
                var rp = new RegExp("\\..+\\?");
                url = url.replace(rp,".xls?");

                window.open(url, "_blank")
            });
        }
    }

    Internal.prototype.syncPaginatorUI = function(){
        var me = this;
        if(me.data.options.paginatorBox)
        {
            var paginatorBox = $("#"+me.data.options.paginatorBox);

            var options = me.data.options;
            var preText = $.i18n("paginatorPre");
            var nextText = $.i18n("paginatorNext");
            var refreshText = $.i18n("paginatorRefresh");
            var pageBeforeText = $.tmpl($.i18n("paginatorBeforePage"),{totalPage:Math.ceil(options.totalCount/options.pageSize)})
            var pageAfterText = $.tmpl($.i18n("paginatorAfterPage"),{totalPage:Math.ceil(options.totalCount/options.pageSize)})
            var recordStart = Math.max(options.currentPage-1,0)*options.pageSize+1;
            var recordEnd = Math.min(options.currentPage*options.pageSize,me.data.options.totalCount);
            recordStart = Math.min(recordEnd,recordStart);
            var recordText = $.tmpl($.i18n("paginatorRecord"),{start:recordStart,end:recordEnd,totalCount:me.data.options.totalCount})
//            paginatorBox.find(".pre-button:first").html(preText);
//            paginatorBox.find(".next-button:first").html(nextText);
//            paginatorBox.find(".refresh-button:first").html(refreshText);
            paginatorBox.find(".paginator-before-page:first").html(pageBeforeText);
            paginatorBox.find(".paginator-after-page:first").html(pageAfterText);
            paginatorBox.find(".paginator-record-label:first").html(recordText);
            paginatorBox.find(".paginator-current-page:first").val(options.currentPage);
            if(options.currentPage<2){
               paginatorBox.find(".paginator-pre-page i:first").addClass("disabled");
               paginatorBox.find(".paginator-first-page i:first").addClass("disabled");
            }
            else{
              paginatorBox.find(".paginator-pre-page i:first").removeClass("disabled");
              paginatorBox.find(".paginator-first-page i:first").removeClass("disabled");
            }
            if(options.currentPage>=Math.ceil(options.totalCount/options.pageSize)){
               paginatorBox.find(".paginator-next-page i:first").addClass("disabled");
               paginatorBox.find(".paginator-last-page i:first").addClass("disabled");
            }
            else{
              paginatorBox.find(".paginator-next-page i:first").removeClass("disabled");
              paginatorBox.find(".paginator-last-page i:first").removeClass("disabled");
            }
        }
    };

    Internal.prototype.syncSearchUI = function(){
        var me = this;
        var showable = false;
        if(me.data.options.searchBox && typeof $("#"+me.data.options.searchBox) != "undefined"){
            var searchBox = $("#"+me.data.options.searchBox);
            var currentColumnValue = searchBox.find("select.search-select:first").val();
            var currentValue = searchBox.find("input.search-box-input:first").val();
            searchBox.find("select.search-select:first").html("");
            me.$element.find(".include-header table:first thead th[search]").each(function(index,column){
                if($(column).attr("search")){
                    showable = true;
                    var option = $("<option></option>")
                    option.html($(column).attr("title"));
                    option.attr("value",$(column).attr("key"));
                    searchBox.find("select.search-select:first").append(option);
                }
            });
            searchBox.find("select.search-select:first").val(currentColumnValue);
            searchBox.find("input.search-box-input:first").val(currentValue);
            if(showable)
                searchBox.css({display:""});
            else
                searchBox.css({display:"none"});
        }
    }


    Internal.prototype.adjustScroll = function(){
        var me = this;
        // 判断否需要滚动
        var scrollable = me.data.options.scrollOptions.scrollX||me.data.options.scrollOptions.scrollY;
        // 不需要滚动的
        if(!scrollable)
            return;
        // 设置表头宽度
        var realHeaders = me.$element.find(".datatable-scroll .include-header table:first thead:first th");
        me.$element.find(".datatable-scroll .scroll-header:first thead:first th").each(function(index,header){
            $(header).css("width",$(realHeaders[index]).outerWidth(true));
            $(realHeaders[index]).css("width",$(realHeaders[index]).outerWidth(true));
        });

        if(me.$element.find(".datatable-scroll .include-header:first").hasVerticalScrollBar()){
            me.$element.find(".datatable-scroll .scroll-header:first").css("border-right-width",$.scrollbarWidth());
            me.$element.find(".datatable-scroll .scroll-header:first").css("border-style","solid");
        }else{
            me.$element.find(".datatable-scroll .scroll-header:first").css("border-right-width",0);
        }

    }

    Internal.prototype.syncScrollUI = function(){
        var me = this;
        // 判断否需要滚动
        var scrollable = me.data.options.scrollOptions.scrollX||me.data.options.scrollOptions.scrollY;
        // 不需要滚动的
        if(!scrollable)
            return;

        // 需要横向滚动 ,计算是否需要调整表格宽度
        if(me.data.options.scrollOptions.scrollX){
            var totalWidth = 0;
            me.$element.find(".datatable-scroll .include-header table:first thead:first th").each(function(index,header){
                totalWidth  = parseInt(($(header).attr("origin-width")||"80").replace(/\D/mg,""))+totalWidth;

            });
            var currentWidth = me.$element.find(".datatable-scroll .include-header table:first").outerWidth(true);
            // 如果列的实际所需宽度大于表格宽度,则使用百分比重置表格宽度
            if(totalWidth>currentWidth){
                var percentWidth = Math.ceil(totalWidth*100/currentWidth)
                me.$element.find(".datatable-scroll .include-header table:first").css("width",percentWidth+"%");
                me.$element.find(".datatable-scroll .scroll-header table:first").css("width",percentWidth+"%");
            }
            me.$element.find(".datatable-scroll .include-header:first").scroll(function(e){
                me.$element.find(".datatable-scroll .scroll-header:first").scrollLeft($(this).scrollLeft());
            })

        }

        // 设置表头宽度
        me.$element.find(".datatable-scroll .include-header table:first thead:first th").each(function(index,header){
            $(header).css("width",$(header).outerWidth(true));
        });

        // 纵向滚动
        if(me.data.options.scrollOptions.scrollY){
            var height = parseInt(me.data.options.scrollOptions.height);

            if(!me.data.options.scrollOptions.staticY&&me.$element.find(".datatable-scroll .include-header:first").hasHorizontalScrollBar()){
                height = $.scrollbarWidth()+height;
            }
            me.$element.find(".datatable-scroll .include-header:first").css("height",height);
        }


        me.$element.find(".datatable-scroll .scroll-header table:first").append(me.$element.find(".datatable-scroll .include-header table:first thead:first"));
        me.$element.find(".datatable-scroll .include-header table:first").prepend("<thead>"+me.$element.find(".datatable-scroll .scroll-header table:first thead:first").html()+"</thead>")

        if(me.$element.find(".datatable-scroll .include-header:first").hasVerticalScrollBar()){
            me.$element.find(".datatable-scroll .scroll-header:first").css("border-right-width",$.scrollbarWidth());
            me.$element.find(".datatable-scroll .scroll-header:first").css("border-style","solid");

        }


    }

    Internal.prototype.getRightPage = function(page){
        var me = this;
        var rightPage = page;
        if(me.data.options.totalCount>0){
            rightPage = Math.min(rightPage,Math.ceil(me.data.options.totalCount/me.data.options.pageSize));
            rightPage = Math.max(1,rightPage);
        }
        else
        {
            rightPage = 1;
        }
        return rightPage;
    }

    Internal.prototype.loadPage = function(page){
        var me = this;
        if(page)
            me.data.options.currentPage = me.getRightPage(page);
        me.load();
    };

    Internal.prototype.nextPage = function(){
        this.loadPage(this.data.options.currentPage+1);
    };

    Internal.prototype.prePage = function(){
        this.loadPage(this.data.options.currentPage-1);
    };

    Internal.prototype.load = function(){
        var me = this;
        me.$element.load(me.buildCurrentRequest(),function(responseText, textStatus, XMLHttpRequest){
            me.processLoadResult(responseText, textStatus, XMLHttpRequest);
        });
    };


    Internal.prototype.buildCurrentRequest = function(){
        var me = this;
        var options = me.data.options;
        var request_url = options.baseUrl;
        var params =  $.extend({limit:options.pageSize,start:Math.max(options.currentPage-1,0)*options.pageSize},options.defaultOptions,options.filterOptions,options.searchOptions,options.orderOptions,{_dom_id: me.$element.context.id},{_scroll:options.scrollOptions.mode});
        if(!options.paginatorBox)
            params = $.extend({},params,{limit:""})
        var paramsStr = $.param(params);

        if(request_url.indexOf("?")>0)
          return request_url+"&"+ paramsStr
        else
          return request_url+"?"+ paramsStr
    };

    Internal.prototype.processLoadResult = function(responseText, textStatus, XMLHttpRequest){
        var me = this;
        var count = me.$element.find(".table-body table:first").attr("count");
        if(count&&count!="")
            me.data.options.totalCount = parseInt(count);
        me.syncPaginatorUI();
        me.syncSearchUI();
        //必须等待当前页面的数据加载完成后才能够对表头数据进行处理
        me.buildOrderColumn();
        me.buildCheckbox();
        me.syncScrollUI();
    };




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
        loadPage : function(/*Object*/ customOptions)
        {
            return this.each(function()
            {
                I(this).loadPage(customOptions);
            });
        },
        adjustScroll : function(/*Object*/ customOptions)
        {
            return this.each(function()
            {
                I(this).adjustScroll();
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

        if ( publicMethods[methodOrOptions] ) {
            return publicMethods[methodOrOptions].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof methodOrOptions === 'object' || ! methodOrOptions ) {
            return publicMethods.init.apply( this, arguments );
        } else {
            $.error("Method '" + methodOrOptions + "' doesn't exist for " + PLUGIN_NAME + " plugin");
        }
    };
})(jQuery);

jQuery.checkRadioButton = function(selector){

    if(jQuery(selector+"[checked=checked]").length>0)
    {
        jQuery(selector+"[checked=checked]").trigger("click");
    }
    else
    {
        jQuery(selector+":first").trigger("click");

    }
}

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        var names = this.name.split("[");

        var current = o;
        for(var i=0;i<names.length;i++){
            names[i] = names[i].replace("]","");
            if(i==names.length-1){
                if (current[names[i]] !== undefined) {
                    if (!current[names[i]].push) {
                        current[names[i]] = [current[names[i]]];
                    }
                    current[names[i]].push(this.value || '');
                } else {
                    if(names.length>1&&names[i].length==0){
                        current.push(this.value || '');
                    } else{
                        current[names[i]] = this.value || '';
                    }
                }
            }else{
                if (current[names[i]] == undefined){
                    if(names[i+1]=="]")
                      current[names[i]]=[];
                    else
                      current[names[i]]={};
                }

                current = current[names[i]];
            }

        }

    });
    return o;
};
