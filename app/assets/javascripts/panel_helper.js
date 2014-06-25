function remove_fields(link) {
  $("destroy").value = "1";
  $(link).closest(".panel_fields").hide();
}

function add_fields(content) {
  var obj = document.getElementById("panels");
  obj.innerHTML += content;
}
