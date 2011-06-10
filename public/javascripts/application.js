GY.use('node',function(Y){
   Y.all('input[irm_uppercase]').on('keyup', function(){
      this.set('value',this.get('value').toString().toUpperCase());
   });

   Y.all('input[irm_number_only]').on('keyup', function(){
        if(!this.get("value")==""){
          var reg = /^[A-Z0-9_]*$/;
          var pattern = /[^\d]/g;
          if(!reg.test(this.get('value').toString())){
            this.set("value", this.get('value').toString().replace(pattern,''));
          }
        }
   });

    Y.all('input[jrequired]').each(function(n){
        var parent_node = n.get('parentNode');
        var node = Y.Node.create('<div class="requiredInput"><div class="requiredBlock"></div>' + parent_node.getContent() + '</div>');
        parent_node.setContent(node);
    });
});
function show_irm_calendar(YAHOO,Event,Dom,id_button,id_date_field,id_cal, cfg){
        var dialog, calendar;
        var showBtn = Dom.get(id_button);
        Event.on(showBtn, "click", function () {
            // Lazy Dialog Creation - Wait to create the Dialog, and setup document click listeners,
            // until the first time the button is clicked.
            //if (!dialog) {
                // Hide Calendar if we click anywhere in the document other than the calendar
                Event.on(document, "click", function (e) {
                    var el = Event.getTarget(e);
                    var dialogEl = dialog.element;
                    if (el != dialogEl && !Dom.isAncestor(dialogEl, el) &&
                            el != showBtn && !Dom.isAncestor(showBtn, el)) {
                        dialog.hide();
                    }
                });
                dialog = new YAHOO.widget.Dialog("container", {
                    visible: false,
                    context: [id_button, "tl", "bl"],
                    draggable: false,
                    close: false
                });
//                dialog.setHeader('Pick A Date');
                dialog.setBody('<div id='+id_cal+'></div>');
                dialog.render(document.body);
                dialog.showEvent.subscribe(function () {
                    if (YAHOO.env.ua.ie) {
                        // Since we're hiding the table using yui-overlay-hidden, we
                        // want to let the dialog know that the content size has changed, when
                        // shown
                        dialog.fireEvent("changeContent");
                    }
                });
            //}
            // Lazy Calendar Creation - Wait to create the Calendar until
            // the first time the button is clicked.
            //if (!calendar) {
                calendar = new YAHOO.widget.Calendar(id_cal, cfg);
                calendar.render();

                calendar.selectEvent.subscribe(function () {
                    if (calendar.getSelectedDates().length > 0) {
                        var selDate = calendar.getSelectedDates()[0];
                        // Pretty Date Output, using Calendar's Locale values: Friday, 8 February 2008
                        calendar.cfg.setProperty("MONTHS_SHORT",   ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]);
                        var wStr = calendar.cfg.getProperty("WEEKDAYS_LONG")[selDate.getDay()];
                        var dStr = selDate.getDate();
                        var mStr = calendar.cfg.getProperty("MONTHS_SHORT")[selDate.getMonth()];
                        var yStr = selDate.getFullYear();
                        Dom.get(id_date_field).value =  yStr+"-"+mStr+"-"+dStr;
                    } else {
                        Dom.get(id_date_field).value = "";
                    }
                    dialog.hide();
                });

                calendar.renderEvent.subscribe(function () {
                // Tell Dialog it's contents have changed, which allows
                // container to redraw the underlay (for IE6/Safari2)
                dialog.fireEvent("changeContent");
                });
            //}
            var seldate = calendar.getSelectedDates();
            if (seldate.length > 0) {
                // Set the pagedate to show the selected date if it exists
                calendar.cfg.setProperty("pagedate", seldate[0]);
                calendar.render();
            }
            dialog.show();
        });
}
//记住用户名
GY.use("cookie",function(Y){
   if(Y.Cookie.get("username")){
      Y.Cookie.set("username", Y.Cookie.get("username"), { path:"/",expires: new Date("January 12, 2025") });
   }
});
YUI(yuiConfig).use('node-base', 'node-event-delegate', 'io-form','yui2-container',function(Y){
    var YAHOO = Y.YUI2;
    var doc = Y.one(document);
    doc.delegate('click', showDialog, 'a[type=dialog][zone]');

    function showDialog(e){
        var zone = this.getAttribute("zone");
        check(zone);
        var dialog = new YAHOO.widget.Panel(this.getAttribute("zone"), { height:"320px",width:"320px", visible:false, constraintoviewport:true } );
        dialog.render();
        dialog.show();
        alert(doc.one("#"+zone).getContent());
    }

    function check(zone){
        if(!doc.one("#"+zone)){
          doc.one('body').appendChild(Y.Node.create("<div id='"+zone+"'></div>"))
        }
    }
});

function add_upload_image_button_to_editor(editor_id)
{
    GY.use('irm','node','substitute','yui2-editor',function(Y) {
        var dialog = new Y.YUI2.widget.Dialog("container_applet_upload", {
            visible: true,
            context: [Y.one("#uploadImageFormClipboard"), "tl", "bl"],
            draggable: true,
            close: true
        });

        var myEd = Y.YUI2.widget.EditorInfo.getEditorById('msgEditor');

        var oButton = new Y.YUI2.widget.Button(
        {
            type: 'push',
            label: 'Upload Image From Clipboard',
            value: 'uploadImageFormClipboard',
            id: 'uploadImageFormClipboard'
        });


        myEd.on('toolbarLoaded', function() {
            this.toolbar.on('uploadImageFormClipboardClick', function(o) {
                  if (Y.one("#container_applet_upload_c")){
                    Y.one("#container_applet_upload_c").remove();
                  }
                  dialog.setBody("<iframe frameborder=0 scrolling='no'  src='/common/upload_screen_shot' style='height:400px;width:620px;'></iframe>");
                  dialog.setHeader('<%= t :upload_from_clipboard%>');
                  dialog.render(document.body);
                  dialog.center();
                  dialog.show();
            });
        }, myEd, true);

        myEd.toolbar.addButton(oButton);
        myEd.render();
    });
}

function addAttachScreen(file_path){
    alert("finishing attach");
    GY.use('yui2-editor', function(Y) {
        var myEd = Y.YUI2.widget.EditorInfo.getEditorById('msgEditor');
        alert("get editor done");
        if (myEd) {
        alert("into if");
        try {
            alert("into try");
            myEd.focus();
            myEd.execCommand('inserthtml', file_path);
        }
            catch (e) { alert("couldn't insert content" + e); }
        }
        alert("starting remove");
        Y.one("#container_applet_upload_c").remove();
        alert("remove done");

    });
}

function hideAttachScreen(){
    GY.use(function(Y) {
        Y.one("#container_applet_upload_c").remove();
    });
}




