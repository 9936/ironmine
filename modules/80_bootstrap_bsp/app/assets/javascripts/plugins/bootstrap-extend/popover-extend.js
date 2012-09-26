/* ===========================================================
 * bootstrap-popover.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#popovers
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */


!function ($) {

    "use strict"; // jshint ;_;


    /* POPOVER PUBLIC CLASS DEFINITION
     * =============================== */

    var Popover = function (element, options) {
        this.init('popover', element, options)
    }


    /* NOTE: POPOVER EXTENDS BOOTSTRAP-TOOLTIP.js
     ========================================== */

    Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype, {

        constructor: Popover

        , leave: function (e) {
            var self = $(e.currentTarget)[this.type](this._options).data(this.type);
            if (!self.tip().hasClass('mouseover')) {
                if (this.timeout) clearTimeout(this.timeout)
                if (!self.options.delay || !self.options.delay.hide) return self.hide()

                self.hoverState = 'out'
                this.timeout = setTimeout(function() {
                    if (self.hoverState == 'out') self.hide()
                }, self.options.delay.hide)
            }
        }

        , show: function () {
            var $tip, inside, pos , actualWidth, actualHeight, placement, tp
            if (this.hasContent() && this.enabled) {
                $tip = this.tip();
                this.setContent();
                if (this.options.animation) {
                    $tip.addClass('fade')
                }
                placement = typeof this.options.placement == 'function' ? this.options.placement.call(this, $tip[0], this.$element[0]) : this.options.placement

                inside = /in/.test(placement)

                $tip.remove().css({ top: 0, left: 0, display: 'block' }).appendTo(inside ? this.$element : document.body)

                pos = this.getPosition(inside)

                actualWidth = $tip[0].offsetWidth
                actualHeight = $tip[0].offsetHeight

                if(placement == 'left' && actualWidth > pos.left){
                    placement = 'right';
                }else if(placement == 'right' && actualWidth >($(window).width() - (pos.left+pos.width))){
                    placement = 'left';
                }else if(placement == 'top' && actualHeight > pos.top) {
                    placement = 'bottom'
                }else if(placement == 'bottom' && actualHeight > ($(window).height() - (pos.top+pos.height))){
                    placement = 'top';
                }

                switch (inside ? placement.split(' ')[1] : placement) {
                    case 'bottom':
                        tp = {top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2}
                        break
                    case 'top':
                        tp = {top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}
                        break
                    case 'left':
                        tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth}
                        break
                    case 'right':
                        tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width}
                        break
                }
                $tip.css(tp).addClass(placement).addClass('in')
            }
        }
        , hide: function () {
            var that = this, $tip = this.tip()
            if($tip.hasClass("mouseover")) return false;
            $tip.removeClass('in')

            function removeWithAnimation() {
                var timeout = setTimeout(function () {
                    $tip.off($.support.transition.end).remove()
                }, 500)

                $tip.one($.support.transition.end, function () {
                    clearTimeout(timeout)
                    $tip.remove()
                })
            }

            $.support.transition && this.$tip.hasClass('fade') ? removeWithAnimation() : $tip.remove()
            return this
        }
        , setContent: function () {
            var $tip = this.tip() , title = this.getTitle() , content = this.getContent()

            $tip.find('.popover-title')[this.options.html ? 'html' : 'text'](title)
            $tip.find('.popover-content > *')[this.options.html ? 'html' : 'text'](content)

            $tip.removeClass('fade top bottom left right in')
        }

        , hasContent: function () {
            return this.getTitle() || this.getContent()
        }

        , getContent: function () {
            var content
                , $e = this.$element
                , o = this.options

            content = $e.attr('data-content')
                || (typeof o.content == 'function' ? o.content.call($e[0]) :  o.content)

            return content
        }

        , tip: function () {
            var that = this;
            if (!this.$tip) {
                this.$tip = $(this.options.template)
            }
            this.$tip.mouseenter(function(){
                $(this).addClass('mouseover');
            }).mouseleave(function(){
                    $(this).removeClass('mouseover');
                    that.hide();
                });
            return this.$tip
        }

    })


    /* POPOVER PLUGIN DEFINITION
     * ======================= */

    $.fn.popover = function (option) {
        return this.each(function () {
            var $this = $(this)
                , data = $this.data('popover')
                , options = typeof option == 'object' && option
            if (!data) $this.data('popover', (data = new Popover(this, options)))
            if (typeof option == 'string') data[option]()
        })
    }

    $.fn.popover.Constructor = Popover

    $.fn.popover.defaults = $.extend({} , $.fn.tooltip.defaults, {
        placement: 'right'
        , content: ''
        , delay: 300
        , template: '<div class="popover"><div class="arrow"></div><div class="popover-inner-no"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
    })

}(window.jQuery);