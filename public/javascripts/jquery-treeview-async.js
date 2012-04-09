;(function($) {

function load(settings, root, child, container) {
	$.getJSON(settings.url, {root: root}, function(response) {
        response = [{id:"root", text:settings.root_text,expanded:true, children:response,classes:"active"}];
		function createNode(parent) {
            var a_span = $("<a/>").attr("href", "javascript:void(0);").html("<span class='folder'>" + this.text + "</span>");
			var current = $("<li/>").attr("id", this.id || "").html(a_span).appendTo(parent);
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
                var params = {};
                params[settings.param_name] = $(this).parent().attr(settings.param_value);
                var current_target = $("#"+settings.target_table).data("datatable").target;
                current_target.data.options.searchOptions = params;
                current_target.loadPage(1);
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