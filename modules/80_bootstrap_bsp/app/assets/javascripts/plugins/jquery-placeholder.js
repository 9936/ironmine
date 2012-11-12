//(function ($) {
//    $.fn.extend({
//        placeholder : function () {
//            if ("placeholder" in document.createElement("input")) {
//                return this;//如果浏览器本身支持placeholder属性，则返回对象本身
//            } else {
//                return this.each(function () {
//                    var $this = $(this);
//                    $this.val($this.attr("placeholder")).focus(function () {
//                        if ($this.val() === $this.attr("placeholder")) {
//                            $this.val("")
//                        }
//                        $this.removeClass('placeholder');
//                    }).blur(function () {
//                        if ($this.val().length === 0) {
//                            $this.addClass('placeholder');  //灰色
//                            $this.val($this.attr("placeholder"));
//                        }
//                    })
//                })
//            }
//        }
//    })
//})(jQuery);


(function($) {
    $.fn.placeholder = function(options) {
        var defaults = {
            labelAlpha: true,
            labelAcross: true
        };
        var params = $.extend({}, defaults, options || {});
        //方法
        var funLabelAlpha = function(elementEditable, elementCreateLabel) {
            if (elementEditable.val() === "") {
                elementCreateLabel.css("opacity", 0.4).html(elementEditable.data("placeholder"));
            } else {
                elementCreateLabel.html("");
            }
        };

        $(this).each(function() {
            var element = $(this), isPlaceholder = "placeholder" in document.createElement("input"), placeholder = element.attr("placeholder");
            if (!placeholder || (!params.labelMode && isPlaceholder) || (params.labelMode && !params.labelAcross && isPlaceholder)) { return; }
            // 存储，因为有时会清除placeholder属性
            element.data("placeholder", placeholder);

            // label模拟
            var idElement = element.attr("id"), elementLabel = null;
            if (!idElement) {
                idElement = "placeholder" + Math.random();
                element.attr("id", idElement);
            }

            // 状态初始化
            elementLabel = $('<label for="'+ idElement +'"></label>').css({
                lineHeight: "1.3",
                position: "absolute",
                fontWeight: "normal",
                fontSize: "100%",
                color: "#8c7e7e",
                cursor: "text",
                margin: "4px 0 0 3px",
                padding: "2px 4px"
            }).insertBefore(element);

            // 事件绑定
            if (params.labelAlpha) {
                // 如果是为空focus透明度改变交互
                element.bind({
                    "focus": function() {
                        funLabelAlpha($(this), elementLabel);
                    },"input": function() {
                        funLabelAlpha($(this), elementLabel);
                    },"blur": function() {
                        if (this.value === "") {
                            elementLabel.css("opacity", 1).html(placeholder);
                        }
                    }
                });

                //IE6~8不支持oninput事件，需要另行绑定
                if (!window.screenX) {
                    element.bind("keyup", function() {
                        funLabelAlpha($(this), elementLabel);
                    });
                    element.get(0).onpaste = function() {
                        setTimeout(function() {
                            funLabelAlpha(element, elementLabel);
                        }, 30);
                    }
                }

                // 右键事件
                elementLabel.get(0).oncontextmenu = function() {
                    element.trigger("focus");
                    return false;
                }
            } else {
                //如果是单纯的value交互
                element.bind({
                    "focus": function() {
                        elementLabel.html("");
                    },
                    "blur": function() {
                        if ($(this).val() === "") {
                            elementLabel.html(placeholder);
                        }
                    }
                });
            }

            // 内容初始化
            if (params.labelAcross) {
                element.removeAttr("placeholder");
            }

            if (element.val() === "") {
                elementLabel.html(placeholder);
            }
        });
    };
})(jQuery);