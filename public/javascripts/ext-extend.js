Ext.define("Ext.irm.EventHelper",{
    statics: {
        //mouse events supported
        mouseEvents: {
            click:      1,
            dblclick:   1,
            mouseover:  1,
            mouseout:   1,
            mousedown:  1,
            mouseup:    1,
            mousemove:  1
        },
        //key events supported
        keyEvents: {
            keydown:    1,
            keyup:      1,
            keypress:   1
        },
        //HTML events supported
        uiEvents  : {
            blur:       1,
            change:     1,
            focus:      1,
            resize:     1,
            scroll:     1,
            select:     1
        },
        //events that bubble by default
        bubbleEvents : {
            scroll:     1,
            resize:     1,
            reset:      1,
            submit:     1,
            change:     1,
            select:     1,
            error:      1,
            abort:      1
        }
    }
});


Ext.apply(Ext.irm.EventHelper.bubbleEvents,Ext.irm.EventHelper.mouseEvents,Ext.irm.EventHelper.keyEvents);

Ext.irm.EventHelper.simulateKeyEvent = function(target /*:HTMLElement*/, type /*:String*/,
                             bubbles /*:Boolean*/,  cancelable /*:Boolean*/,
                             view /*:Window*/,
                             ctrlKey /*:Boolean*/,    altKey /*:Boolean*/,
                             shiftKey /*:Boolean*/,   metaKey /*:Boolean*/,
                             keyCode /*:int*/,        charCode /*:int*/) /*:Void*/
{
    //check target
    if (!target){

    }

    //check event type
    if (Ext.isString(type)){
        type = type.toLowerCase();
        switch(type){
            case "textevent": //DOM Level 3
                type = "keypress";
                break;
            case "keyup":
            case "keydown":
            case "keypress":
                break;
            default:
                //no event type
        }
    } else {
        //error("simulateKeyEvent(): Event type must be a string.");
    }

    //setup default values
    if (!Ext.isBoolean(bubbles)){
        bubbles = true; //all key events bubble
    }
    if (!Ext.isBoolean(cancelable)){
        cancelable = true; //all key events can be cancelled
    }
    if (!Ext.isObject(view)){
        view = window; //view is typically window
    }
    if (!Ext.isBoolean(ctrlKey)){
        ctrlKey = false;
    }
    if (!Ext.isBoolean(altKey)){
        altKey = false;
    }
    if (!Ext.isBoolean(shiftKey)){
        shiftKey = false;
    }
    if (!Ext.isBoolean(metaKey)){
        metaKey = false;
    }
    if (!Ext.isNumber(keyCode)){
        keyCode = 0;
    }
    if (!Ext.isNumber(charCode)){
        charCode = 0;
    }

    //try to create a mouse event
    var customEvent /*:MouseEvent*/ = null;

    //check for DOM-compliant browsers first
    if (Ext.isFunction(document.createEvent)){

        try {

            //try to create key event
            customEvent = document.createEvent("KeyEvents");

            /*
             * Interesting problem: Firefox implemented a non-standard
             * version of initKeyEvent() based on DOM Level 2 specs.
             * Key event was removed from DOM Level 2 and re-introduced
             * in DOM Level 3 with a different interface. Firefox is the
             * only browser with any implementation of Key Events, so for
             * now, assume it's Firefox if the above line doesn't error.
             */
            // @TODO: Decipher between Firefox's implementation and a correct one.
            customEvent.initKeyEvent(type, bubbles, cancelable, view, ctrlKey,
                altKey, shiftKey, metaKey, keyCode, charCode);

        } catch (ex /*:Error*/){

            /*
             * If it got here, that means key events aren't officially supported.
             * Safari/WebKit is a real problem now. WebKit 522 won't let you
             * set keyCode, charCode, or other properties if you use a
             * UIEvent, so we first must try to create a generic event. The
             * fun part is that this will throw an error on Safari 2.x. The
             * end result is that we need another try...catch statement just to
             * deal with this mess.
             */
            try {

                //try to create generic event - will fail in Safari 2.x
                customEvent = document.createEvent("Events");

            } catch (uierror /*:Error*/){

                //the above failed, so create a UIEvent for Safari 2.x
                customEvent = document.createEvent("UIEvents");

            } finally {

                customEvent.initEvent(type, bubbles, cancelable);

                //initialize
                customEvent.view = view;
                customEvent.altKey = altKey;
                customEvent.ctrlKey = ctrlKey;
                customEvent.shiftKey = shiftKey;
                customEvent.metaKey = metaKey;
                customEvent.keyCode = keyCode;
                customEvent.charCode = charCode;

            }

        }

        //fire the event
        target.dispatchEvent(customEvent);

    } else if (Ext.isObject(document.createEventObject)){ //IE

        //create an IE event object
        customEvent = document.createEventObject();

        //assign available properties
        customEvent.bubbles = bubbles;
        customEvent.cancelable = cancelable;
        customEvent.view = view;
        customEvent.ctrlKey = ctrlKey;
        customEvent.altKey = altKey;
        customEvent.shiftKey = shiftKey;
        customEvent.metaKey = metaKey;

        /*
         * IE doesn't support charCode explicitly. CharCode should
         * take precedence over any keyCode value for accurate
         * representation.
         */
        customEvent.keyCode = (charCode > 0) ? charCode : keyCode;

        //fire the event
        target.fireEvent("on" + type, customEvent);

    } else {
        //error("simulateKeyEvent(): No event simulation framework present.");
    }
};

Ext.irm.EventHelper.simulateMouseEvent = function(target /*:HTMLElement*/, type /*:String*/,
                               bubbles /*:Boolean*/,  cancelable /*:Boolean*/,
                               view /*:Window*/,        detail /*:int*/,
                               screenX /*:int*/,        screenY /*:int*/,
                               clientX /*:int*/,        clientY /*:int*/,
                               ctrlKey /*:Boolean*/,    altKey /*:Boolean*/,
                               shiftKey /*:Boolean*/,   metaKey /*:Boolean*/,
                               button /*:int*/,         relatedTarget /*:HTMLElement*/) /*:Void*/
{

    //check target
    if (!target){
        Y.error("simulateMouseEvent(): Invalid target.");
    }

    //check event type
    if (Ext.isString(type)){
        type = type.toLowerCase();

        //make sure it's a supported mouse event
        if (!this.mouseEvents[type]){
            Y.error("simulateMouseEvent(): Event type '" + type + "' not supported.");
        }
    } else {
        Y.error("simulateMouseEvent(): Event type must be a string.");
    }

    //setup default values
    if (!Ext.isBoolean(bubbles)){
        bubbles = true; //all mouse events bubble
    }
    if (!Ext.isBoolean(cancelable)){
        cancelable = (type != "mousemove"); //mousemove is the only one that can't be cancelled
    }
    if (!Ext.isObject(view)){
        view = window; //view is typically window
    }
    if (!Ext.isNumber(detail)){
        detail = 1;  //number of mouse clicks must be at least one
    }
    if (!Ext.isNumber(screenX)){
        screenX = 0;
    }
    if (!Ext.isNumber(screenY)){
        screenY = 0;
    }
    if (!Ext.isNumber(clientX)){
        clientX = 0;
    }
    if (!Ext.isNumber(clientY)){
        clientY = 0;
    }
    if (!Ext.isBoolean(ctrlKey)){
        ctrlKey = false;
    }
    if (!Ext.isBoolean(altKey)){
        altKey = false;
    }
    if (!Ext.isBoolean(shiftKey)){
        shiftKey = false;
    }
    if (!Ext.isBoolean(metaKey)){
        metaKey = false;
    }
    if (!Ext.isNumber(button)){
        button = 0;
    }

    relatedTarget = relatedTarget || null;

    //try to create a mouse event
    var customEvent /*:MouseEvent*/ = null;

    //check for DOM-compliant browsers first
    if (Ext.isFunction(document.createEvent)){

        customEvent = document.createEvent("MouseEvents");

        //Safari 2.x (WebKit 418) still doesn't implement initMouseEvent()
        if (customEvent.initMouseEvent){
            customEvent.initMouseEvent(type, bubbles, cancelable, view, detail,
                                 screenX, screenY, clientX, clientY,
                                 ctrlKey, altKey, shiftKey, metaKey,
                                 button, relatedTarget);
        } else { //Safari

            //the closest thing available in Safari 2.x is UIEvents
            customEvent = document.createEvent("UIEvents");
            customEvent.initEvent(type, bubbles, cancelable);
            customEvent.view = view;
            customEvent.detail = detail;
            customEvent.screenX = screenX;
            customEvent.screenY = screenY;
            customEvent.clientX = clientX;
            customEvent.clientY = clientY;
            customEvent.ctrlKey = ctrlKey;
            customEvent.altKey = altKey;
            customEvent.metaKey = metaKey;
            customEvent.shiftKey = shiftKey;
            customEvent.button = button;
            customEvent.relatedTarget = relatedTarget;
        }

        /*
         * Check to see if relatedTarget has been assigned. Firefox
         * versions less than 2.0 don't allow it to be assigned via
         * initMouseEvent() and the property is readonly after event
         * creation, so in order to keep YAHOO.util.getRelatedTarget()
         * working, assign to the IE proprietary toElement property
         * for mouseout event and fromElement property for mouseover
         * event.
         */
        if (relatedTarget && !customEvent.relatedTarget){
            if (type == "mouseout"){
                customEvent.toElement = relatedTarget;
            } else if (type == "mouseover"){
                customEvent.fromElement = relatedTarget;
            }
        }

        //fire the event
        target.dispatchEvent(customEvent);

    } else if (Ext.isObject(document.createEventObject)){ //IE

        //create an IE event object
        customEvent = document.createEventObject();

        //assign available properties
        customEvent.bubbles = bubbles;
        customEvent.cancelable = cancelable;
        customEvent.view = view;
        customEvent.detail = detail;
        customEvent.screenX = screenX;
        customEvent.screenY = screenY;
        customEvent.clientX = clientX;
        customEvent.clientY = clientY;
        customEvent.ctrlKey = ctrlKey;
        customEvent.altKey = altKey;
        customEvent.metaKey = metaKey;
        customEvent.shiftKey = shiftKey;

        //fix button property for IE's wacky implementation
        switch(button){
            case 0:
                customEvent.button = 1;
                break;
            case 1:
                customEvent.button = 4;
                break;
            case 2:
                //leave as is
                break;
            default:
                customEvent.button = 0;
        }

        /*
         * Have to use relatedTarget because IE won't allow assignment
         * to toElement or fromElement on generic events. This keeps
         * YAHOO.util.customEvent.getRelatedTarget() functional.
         */
        customEvent.relatedTarget = relatedTarget;

        //fire the event
        target.fireEvent("on" + type, customEvent);

    } else {
        Y.error("simulateMouseEvent(): No event simulation framework present.");
    }
};

Ext.irm.EventHelper.simulateUIEvent = function(target /*:HTMLElement*/, type /*:String*/,
                               bubbles /*:Boolean*/,  cancelable /*:Boolean*/,
                               view /*:Window*/,        detail /*:int*/) /*:Void*/
{

    //check target
    if (!target){
        Y.error("simulateUIEvent(): Invalid target.");
    }

    //check event type
    if (Ext.isString(type)){
        type = type.toLowerCase();

        //make sure it's a supported mouse event
        if (!this.uiEvents[type]){
            //error("simulateUIEvent(): Event type '" + type + "' not supported.");
        }
    } else {
        //error("simulateUIEvent(): Event type must be a string.");
    }

    //try to create a mouse event
    var customEvent = null;


    //setup default values
    if (!Ext.isBoolean(bubbles)){
        bubbles = (type in this.bubbleEvents);  //not all events bubble
    }
    if (!Ext.isBoolean(cancelable)){
        cancelable = (type == "submit"); //submit is the only one that can be cancelled
    }
    if (!Ext.isObject(view)){
        view = window; //view is typically window
    }
    if (!Ext.isNumber(detail)){
        detail = 1;  //usually not used but defaulted to this
    }

    //check for DOM-compliant browsers first
    if (Ext.isFunction(document.createEvent)){

        //just a generic UI Event object is needed
        customEvent = document.createEvent("UIEvents");
        customEvent.initUIEvent(type, bubbles, cancelable, view, detail);

        //fire the event
        target.dispatchEvent(customEvent);

    } else if (Ext.isObject(document.createEventObject)){ //IE

        //create an IE event object
        customEvent = document.createEventObject();

        //assign available properties
        customEvent.bubbles = bubbles;
        customEvent.cancelable = cancelable;
        customEvent.view = view;
        customEvent.detail = detail;

        //fire the event
        target.fireEvent("on" + type, customEvent);

    } else {
        //error("simulateUIEvent(): No event simulation framework present.");
    }
};

Ext.irm.EventHelper.simulate = function(target, type, options){
    options = options || {};

    if (this.mouseEvents[type]){
        this.simulateMouseEvent(target, type, options.bubbles,
            options.cancelable, options.view, options.detail, options.screenX,
            options.screenY, options.clientX, options.clientY, options.ctrlKey,
            options.altKey, options.shiftKey, options.metaKey, options.button,
            options.relatedTarget);
    } else if (this.keyEvents[type]){
        this.simulateKeyEvent(target, type, options.bubbles,
            options.cancelable, options.view, options.ctrlKey,
            options.altKey, options.shiftKey, options.metaKey,
            options.keyCode, options.charCode);
    } else if (this.uiEvents[type]){
        this.simulateUIEvent(target, type, options.bubbles,
            options.cancelable, options.view, options.detail);
     } else {

    }
};

Ext.define("Ext.irm.ViewFilter",{
    filter: null,
    table: null,
    constructor: function(config) {
        var me = this;
        me.filter = config.filter || me.filter,
        me.table = config.table || me.table;
        if(me.filter&&Ext.get(me.filter)&&me.table){
            select_element = Ext.get(me.filter).down("select.viewFilter");
            me.table.store.dtFilter({_view_filter_id:select_element.getValue()});
            select_element.on("change",function(event){
                me.table.store.dtFilter({_view_filter_id:Ext.get(this).getValue()});
            });
            edit_link = Ext.get(me.filter).down("a.EditLink");

            edit_link.on("click",function(event){
                if(!Ext.get(event.currentTarget).getAttribute("thref")){
                    Ext.get(event.currentTarget).set({"thref":Ext.get(event.currentTarget).getAttribute("href")});
                }
                var href = decodeURIComponent(Ext.get(event.currentTarget).getAttribute("thref"));
                href = new Ext.Template(href).apply({id:select_element.getValue()});
                Ext.get(event.currentTarget).set({"href":href});
                if(!select_element.getValue())
                  event.preventDefault();
            });
            Ext.get(me.filter).setStyle("display","block");
        }

    }

});

Ext.define("Ext.irm.DatatableSearchBox",{
    box: null,
    table: null,
    constructor: function(config) {

        var show_able = false;
        var me = this;
        if(Ext.get(me.box))
            Ext.get(me.box).setStyle("display","none");
        me.box = config.box || me.box,
        me.table = config.table || me.table;
        if(me.box&&Ext.get(me.box)&&me.table){
            var search_template = new Ext.Template(['<div class="search-box">','<select class="searchSelect">{options}</select>',
                '<input class="searchBoxInput" type="text" size="20">','</div>']
            );
            search_template.compile();
            var options = "";
            Ext.each(me.table.columns,function(column){
                if(column.searchable){
                    show_able = true;
                    options = options + Ext.String.format('<option value="{0}">{1}</option>', column.dataIndex, column.text);
                }
            });
            search_template.append(Ext.get(me.box),{"options":options});
            if(show_able)
                Ext.get(me.box).setStyle("display","");

            Ext.get(me.box).down("input.searchBoxInput").on("keydown",function(event){
                if(event.keyCode==13){
                    var params = {};
                    params[Ext.get(me.box).down("select.searchSelect").getValue()] = Ext.get(me.box).down("input.searchBoxInput").getValue();
                    me.table.store.dtSearch(params);
                }
            });
        }

    }

});


Ext.define("Ext.irm.DatatableExport",{

});


Ext.define("Ext.irm.DatatableStore",{
    extend: 'Ext.data.Store',

    filterParams: {},
    searchParams: {},
    dtSearch: function(options){
        var me = this;
        me.searchParams = options||{};
        me.loadPage(1);
    },
    dtFilter: function(options){
        var me = this;
        me.filterParams = options||{};
        me.loadPage(1);
    },

    load: function(options) {
        var me = this;

        var params = {};

        Ext.apply(params,me.filterParams);
        Ext.apply(params,me.searchParams);

        options = options || {};

        if (Ext.isFunction(options)) {
            options = {
                callback: options
            };
        }

        Ext.applyIf(options, {
            groupers: me.groupers.items,
            page: me.currentPage,
            start: (me.currentPage - 1) * me.pageSize,
            limit: me.pageSize,
            params: params,
            addRecords: false
        });

        return me.callParent([options]);
    }
});


// 表格列宣染器
Ext.irm.dtTemplate = function(value, cellmeta, record, rowIndex, columnIndex, store){
    var me = this;
    var dataIndex = me.columns[columnIndex].dataIndex;
    var templateElement =me.getEl().parent().down("div#"+dataIndex)||me.getEl().down("div."+dataIndex);
    if(templateElement){
        return  new Ext.Template(decodeURIComponent(templateElement.dom.innerHTML)).apply(record.data);
    }
    else{
        return value;
    }
}

Ext.irm.dtScriptTemplate = function(value, cellmeta, record, rowIndex, columnIndex, store){
    var me = this;
    var dataIndex = me.columns[columnIndex].dataIndex;
    var templateElement =me.getEl().parent().down("div#"+dataIndex)||me.getEl().down("div."+dataIndex);
    if(templateElement){
        console.debug(record);
         var scriptString =  new Ext.Template(decodeURIComponent(templateElement.dom.innerHTML)).apply(record.data);
         scriptString = scriptString.replace(/&amp;/g,"&");
         scriptString = scriptString.replace(/&gt;/g,">");
         scriptString = scriptString.replace(/&lt;/g,"<");
         scriptString = eval(scriptString);
         return scriptString;
    }
    else{
        return value;
    }

}