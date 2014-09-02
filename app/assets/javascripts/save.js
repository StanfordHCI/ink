$(document).on('nested:fieldAdded', function(event) {
  var field = event.field;
  console.log(field);
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

      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //eliminates extra submit events
  });

  $("#pageform").submit(); //Calls above submit function
});
