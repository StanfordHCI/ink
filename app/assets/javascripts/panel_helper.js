function remove_fields(link) {
  $("destroy").value = "1";
  $(link).closest(".panel_fields").hide();
}

function add_fields(link, content) {
  var obj = document.getElementById("panels");
  obj.innerHTML += content;

  /*
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_panel", "g");
  $(link).closest().insertBefore();
    ({
    before: content.replace(regexp, new_id)
  });
  */
}
