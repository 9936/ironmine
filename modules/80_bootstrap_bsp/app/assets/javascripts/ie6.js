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
    $(":checkbox").addClass("input-checkbox");
    $('[class^="icon-"], [class=" icon-"]').addClass("icon-sprite");
    //为input[type="text"]
    $('input[type="text"]').addClass("input-text");
    $(".lov-btn").each(function(){
       $(this).addClass("add-on");
       $(this).text("查找");
    });


    var zIndexNumber = 1000;
    $(".chzn-container").each(function() {
        $(this).css('zIndex', zIndexNumber);
        zIndexNumber -= 10;
    });

    //修复IE6下select样式无法生效
//    $("select").each(function(){
//       $(this).css("margin", "-2px").css("overflow","hidden");
//       var w = ($(this).width() -3) + 'px';
//       alert($(this).outerHTML());
//       var select_box = $("<div>"+$(this).outerHTML()+"</div>");
//       select_box.css("width",w).css("position","relative").css("height","20px").css("border","1px solid #ccc");
//       $(this).parent().append(select_box);
//       $(this).remove();
//    });
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
