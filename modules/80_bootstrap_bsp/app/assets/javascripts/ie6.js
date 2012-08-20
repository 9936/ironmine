$(function () {
    $('.row div[class^="span"]:last-child').addClass("last-child");
    $('[class="span"]').addClass("margin-left-20");
    $(':button[class="btn"], :reset[class="btn"], :submit[class="btn"], input[type="button"]').addClass("button-reset");
    $(":checkbox").addClass("input-checkbox");
    $('[class^="icon-"], [class=" icon-"]').addClass("icon-sprite");
});

