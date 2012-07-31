;(function($) {

function load(settings, root, child, container) {
	$.getJSON(settings.url, {root: root}, function(response) {
        //是否需要初始化根信息
        if(settings.root_text) {
            response = [{id:"root", text:settings.root_text,expanded:true, children:response,classes:"active"}];
        }
		function createNode(parent) {
            //配置是否显示checkbox
            var a_span = '';
            if(settings.show_checkbox) {
                if(this.checked) {
                    a_span = $("<a/>").attr("href", "javascript:void(0);").html("<input type='checkbox' checked='checked' name='ids' value='"+this.id+"'/><span class='folder'>" + this.text + "</span>");
                }else{
                    a_span = $("<a/>").attr("href", "javascript:void(0);").html("<input type='checkbox' name='ids' value='"+this.id+"'/><span class='folder'>" + this.text + "</span>");
                }

            }else{
                a_span = $("<a/>").attr("href", "javascript:void(0);").html("<span class='folder'>" + this.text + "</span>");
            }

            //当前的li需要配置的属性以及值
            var attr_arr = settings.li_attrs.split(',');
			var current = $("<li/>").attr("id", this.id || "").html(a_span).appendTo(parent);
            for(var i=0;i<attr_arr.length;i++) {
                current.attr(attr_arr[i],this[attr_arr[i]]);
            }
			if (this.expanded) {
				current.addClass("open");
			}
            if(this.classes) {
                a_span.addClass(this.classes);
            }
            if (this.column_description) {
                current.attr('title', this.column_description);
            }
			if (this.hasChildren || this.children && this.children.length) {
				var branch = $("<ul/>").appendTo(current);
				if (this.hasChildren) {
					current.addClass("hasChildren");
					createNode.call({
						text:"placeholder",
						id:"placeholder",
						children:[]
					}, branch);
				}
				if (this.children && this.children.length) {
					$.each(this.children, createNode, [branch])
				}
			}
            //添加onclick 事件
            a_span.bind("click",function(event) {
                event.stopPropagation()||(event.cancelBubble = true);
                //设置选中的突出显示
                $(".filetree").find('li >a').each(function(){
                   if ($(this).hasClass('active')) {
                       $(this).removeClass('active');
                   }
                });
                $(this).addClass('active');
                //触发外部监听的事件
                $(container).trigger('nodeListener', [current]);
            });
		}
		$.each(response, createNode, [child]);
        $(container).treeview({add: child});
    });
}

var proxied = $.fn.treeview;
$.fn.treeview = function(settings) {
	if (!settings.url) {
		return proxied.apply(this, arguments);
	}
	var container = this;
	load(settings, "source", this, container);
	var userToggle = settings.toggle;
	return proxied.call(this, $.extend({}, settings, {
		collapsed: true,
		toggle: function() {
			var $this = $(this);
			if ($this.hasClass("hasChildren")) {
				var childList = $this.removeClass("hasChildren").find("ul");
				childList.empty();
				load(settings, this.id, childList, container);
			}
			if (userToggle) {
				userToggle.apply(this, arguments);
			}
		}
	}));
};

})(jQuery);