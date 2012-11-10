(function ($) {
    $.fn.extend({
        placeholder : function () {
            if ("placeholder" in document.createElement("input")) {
                return this;//如果浏览器本身支持placeholder属性，则返回对象本身
            } else {
                return this.each(function () {
                    var $this = $(this);
                    $this.val($this.attr("placeholder")).focus(function () {
                        if ($this.val() === $this.attr("placeholder")) {
                            $this.val("")
                        }
                        $this.removeClass('placeholder');
                    }).blur(function () {
                        if ($this.val().length === 0) {
                            $this.addClass('placeholder');  //灰色
                            $this.val($this.attr("placeholder"));
                        }
                    })
                })
            }
        }
    })
})(jQuery);