$(document).ready(function(){
  $(".datatable a").each(function(){
    if(!$(this).hasClass('btn')) {
      $(this).parent().html($(this).text());
    }
  });
  //去除table中的操作列
  $(".datatable").each(function(){
//    var table = $(this).find("table:first");
//    if(table.find("thead th:first").attr("key") == "id"){
//      table.find("thead th:first").remove();
//      table.find("tbody tr:nth-child(0)").remove();
//    }
  });
});

function number_pages(){
  var vars = {};
  var x = document.location.search.substring(1).split('&');
  for(var i in x) {
    var z=x[i].split('=',2);
    vars[z[0]] = unescape(z[1]);
  }
  var x=['frompage','topage','page','webpage','section','subsection','subsubsection'];
  for(var i in x) {
    var y = document.getElementsByClassName(x[i]);
    for(var j=0; j<y.length; ++j) y[j].textContent = vars[x[i]];
  }
}

//$(document).load(function(){
//   number_pages();
//});

