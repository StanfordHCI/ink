function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".panel_fields").hide();
}

function add_fields(link, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_panels", "g");
  $(link).parent().before(content.replace(regexp, new_id));
}

function add_existing_fields(content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_panels", "g");
  $("div").parent(".panels").before(content.replace(regexp, new_id));
}
