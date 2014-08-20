function Save() {
  $("#pageform").one("submit", function(e) {
    $(".add_panel").off("submit"); //not doing anything
    var form = $(this);
    var formURL = form.attr("action");
    var formData = new FormData(this); 

    $.ajax({
      type: "POST",
      url: formURL,
      data: formData,
      mimeType: "multipart/form-data",
      contentType: false,
      cache: false,
      processData: false,
      success: function(data){
        console.log("Saved form: " + data);
      }
    });
    e.preventDefault();
  });

  $("#pageform").submit();
}
