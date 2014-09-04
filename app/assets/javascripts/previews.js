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
