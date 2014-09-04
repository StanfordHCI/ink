function update_previews() {
  $.ajax({
    type: "GET",
  url: "/pages/previews",
  datatype: "json",
  success: function(data){
    console.log(data);
    //Check if data is empty first
    //var panels = JSON.parse(data);
    var previews = $(".preview");
    console.log(previews);
    for (i=0; i<previews.length; i++) {
      console.log(data[i]);
      console.log(previews[i].innerHTML);
      previews[i].innerHTML = data[i];
    }
  }
  });
}
