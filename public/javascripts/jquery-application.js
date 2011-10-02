$('form a[type=submit]').live('click', function(e) {
  parent_forms = $(this).parents("form");
  e.preventDefault()
  if(parent_forms[0])
    parent_forms[0].submit();
});

$('form a.submit').live('click', function(e) {
    href = $(this).attr("href");
    parent_forms = $(this).parents("form");
    e.preventDefault()
    if(parent_forms[0]){
        $(parent_forms[0]).attr("action",href);
        parent_forms[0].submit();
    }
});