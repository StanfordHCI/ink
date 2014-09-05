function update_previews() {
  $.ajax({
    type: "GET",
  url: "/pages/previews",
  datatype: "json",
  success: function(data){
    //console.log(data);
    //var panels = JSON.parse(data);
    var previews = $(".preview");
    for (i=0; i<data.length; i++) {
      previews[i].innerHTML = data[i];
    }
  }
  });
}

//Called :onblur on panel title fields
function update_panel_menu(panel_name, panel_id) {
  var links = $("nav").find("a");
  console.log(links);
  for (i=0; i<links.length; i++) {
    if (links[i].href.match(panel_id)) { //Find link for corresponding panel
      links[i].innerHTML = panel_name; //Change link text to panel_name
    } 
  }
}
