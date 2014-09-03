$(document).on('nested:fieldAdded', function(event) {
  var panel = event.field;
  console.log(panel);
  $("#pageform").submit(function(e) {
    var form = $(this);
    var formURL = form.attr("action");
    var formData = new FormData(this); 
    var toParse = $(this).serializeArray();

    $.ajax({
      type: "POST",
      url: formURL,
      data: formData,
      mimeType: "multipart/form-data",
      datatype: "json",
      contentType: false,
      cache: false,
      processData: false,
      success: function(data){
        console.log("Form submitted");
        var id = JSON.parse(data);
        console.log(id);
        panel.children()[0].id = "panel" + id; 
        var fields = $(panel.children()[0]).children().children();
        for (i=0; i<fields.length; i++) {
          if(fields[i].htmlFor != undefined) {
            fields[i].htmlFor = fields[i].htmlFor.replace(/\d{13}/g, id);
          }
          if (fields[i].id != undefined) {
            fields[i].id = fields[i].id.replace(/\d{13}/g, id);
          }
          if (fields[i].name != undefined) {
            fields[i].name = fields[i].name.replace(/\d{13}/g, id);
          }
          tags = $($(fields[i]).children()[0]).children();
          for (j=0; j<tags.length; j++) {
            relabel(tags[j], id);
          }
          console.log(fields[i]);
        }

      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //eliminates extra submit events
  });

  $("#pageform").submit(); //Calls above submit function
});

function relabel(tag, id ) {
  tag.id = tag.id.replace(/\d{13}/g, id);
  tag.name = tag.name.replace(/\d{13}/g, id);
  console.log(tag);
}
