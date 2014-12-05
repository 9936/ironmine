/* http://keith-wood.name/maxlength.html
   Textarea Max Length for jQuery v2.0.0.
   Written by Keith Wood (kwood{at}iinet.com.au) May 2009.
   Licensed under the MIT (https://github.com/jquery/jquery/blob/master/MIT-LICENSE.txt) license. 
   Please attribute the author if you use it. */
(function($){var h='maxlength';$.JQPlugin.createPlugin({name:h,defaultOptions:{max:200,truncate:true,showFeedback:true,feedbackTarget:null,onFull:null},regionalOptions:{'':{feedbackText:'{r} characters remaining ({m} maximum)',overflowText:'{o} characters too many ({m} maximum)'}},_getters:['curLength'],_feedbackClass:h+'-feedback',_fullClass:h+'-full',_overflowClass:h+'-overflow',_disabledClass:h+'-disabled',_instSettings:function(a,b){return{feedbackTarget:$([])}},_postAttach:function(c,d){c.on('keypress.'+d.name,function(a){if(!d.options.truncate){return true}var b=String.fromCharCode(a.charCode==undefined?a.keyCode:a.charCode);return(a.ctrlKey||a.metaKey||b=='\u0000'||$(this).val().length<d.options.max)}).on('keyup.'+d.name,function(){$.maxlength._checkLength(c)})},_optionsChanged:function(a,b,c){$.extend(b.options,c);if(b.feedbackTarget.length>0){if(b.hadFeedbackTarget){b.feedbackTarget.empty().val('').removeClass(this._feedbackClass+' '+this._fullClass+' '+this._overflowClass)}else{b.feedbackTarget.remove()}b.feedbackTarget=$([])}if(b.options.showFeedback){b.hadFeedbackTarget=!!b.options.feedbackTarget;if($.isFunction(b.options.feedbackTarget)){b.feedbackTarget=b.options.feedbackTarget.apply(a[0],[])}else if(b.options.feedbackTarget){b.feedbackTarget=$(b.options.feedbackTarget)}else{b.feedbackTarget=$('<span></span>').insertAfter(a)}b.feedbackTarget.addClass(this._feedbackClass)}a.off('mouseover.'+b.name+' focus.'+b.name+'mouseout.'+b.name+' blur.'+b.name);if(b.options.showFeedback=='active'){a.on('mouseover.'+b.name,function(){b.feedbackTarget.css('visibility','visible')}).on('mouseout.'+b.name,function(){if(!b.focussed){b.feedbackTarget.css('visibility','hidden')}}).on('focus.'+b.name,function(){b.focussed=true;b.feedbackTarget.css('visibility','visible')}).on('blur.'+b.name,function(){b.focussed=false;b.feedbackTarget.css('visibility','hidden')});b.feedbackTarget.css('visibility','hidden')}this._checkLength(a)},curLength:function(a){var b=this._getInst(a);var c=a.val();var d=c.replace(/\r\n/g,'~~').replace(/\n/g,'~~').length;return{used:d,remaining:b.options.max-d}},_checkLength:function(a){var b=this._getInst(a);var c=a.val();var d=c.replace(/\r\n/g,'~~').replace(/\n/g,'~~').length;a.toggleClass(this._fullClass,d>=b.options.max).toggleClass(this._overflowClass,d>b.options.max);if(d>b.options.max&&b.options.truncate){var f=a.val().split(/\r\n|\n/);c='';var i=0;while(c.length<b.options.max&&i<f.length){c+=f[i].substring(0,b.options.max-c.length)+'\r\n';i++}a.val(c.substring(0,b.options.max));a[0].scrollTop=a[0].scrollHeight;d=b.options.max}b.feedbackTarget.toggleClass(this._fullClass,d>=b.options.max).toggleClass(this._overflowClass,d>b.options.max);var g=(d>b.options.max?b.options.overflowText:b.options.feedbackText).replace(/\{c\}/,d).replace(/\{m\}/,b.options.max).replace(/\{r\}/,b.options.max-d).replace(/\{o\}/,d-b.options.max);try{b.feedbackTarget.text(g)}catch(e){}try{b.feedbackTarget.val(g)}catch(e){}if(d>=b.options.max&&$.isFunction(b.options.onFull)){b.options.onFull.apply(a,[d>b.options.max])}},enable:function(a){a=$(a);if(!a.hasClass(this._getMarker())){return}var b=this._getInst(a);a.prop('disabled',false).removeClass(b.name+'-disabled');b.feedbackTarget.removeClass(b.name+'-disabled')},disable:function(a){a=$(a);if(!a.hasClass(this._getMarker())){return}var b=this._getInst(a);a.prop('disabled',true).addClass(b.name+'-disabled');b.feedbackTarget.addClass(b.name+'-disabled')},_preDestroy:function(a,b){if(b.feedbackTarget.length>0){if(b.hadFeedbackTarget){b.feedbackTarget.empty().val('').css('visibility','visible').removeClass(this._feedbackClass+' '+this._fullClass+' '+this._overflowClass)}else{b.feedbackTarget.remove()}}a.removeClass(this._fullClass+' '+this._overflowClass).off('.'+b.name)}})})(jQuery);