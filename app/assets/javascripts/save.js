function Save() {
  $("#pageform").submit(function(e) {
    var form = $(this);
    var formURL = form.attr("action");
    var formData = new FormData(this); 
    var toParse = $(this).serialize();

    $.ajax({
      type: "POST",
      url: formURL,
      data: formData,
      mimeType: "multipart/form-data",
      contentType: false,
      cache: false,
      processData: false,
      success: function(data){
        console.log(toParse);
        //console.log("Saved form: " + data);
        //Refresh panels and preview here
      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //eliminates extra submit events
  });

  $("#pageform").submit();
}
