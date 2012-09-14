//(function($) {
//    $.fn.outerHTML = function(s) {
//        return (s)
//            ? this.before(s).remove() : $('<p>').append(this.eq(0).clone()).html();
//    }
//})(jQuery);

$(function () {
    $('.row div[class^="span"]:last-child').addClass("last-child");
    $('[class="span"]').addClass("margin-left-20");
    $(':button[class="btn"], :reset[class="btn"], :submit[class="btn"], input[type="button"]').addClass("button-reset");
//    $(":checkbox").addClass("input-checkbox");
    $('[class^="icon-"], [class=" icon-"]').addClass("icon-sprite");
    //为input[type="text"]
    $('input[type="text"]').addClass("input-text");
    $(".lov-btn").each(function(){
       $(this).addClass("add-on");
       $(this).text("查找");
    });


    var zIndexNumber = 1000;
    $("div").each(function() {
        if($(this).css("position") != "absolute") {
            $(this).css('zIndex', zIndexNumber);
            zIndexNumber -= 10;
        }
    });
});

//处理IE中的select
function select_for_ie6(show){
    //隐藏select
    if(show){
        $("select:visible").each(function(){
            $(this).attr("show_select",true);
            $(this).hide();
        })
    }else{
        $("select").each(function(){
            if($(this).attr("show_select")){
              $(this).removeAttr("show_select");
              $(this).show();
            }
        })
    }
}
