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
      //datatype: "json",
      contentType: false,
      cache: false,
      processData: false,
      success: function(data){
        /*
           console.log(data); 
           var panels = JSON.parse(data);
           console.log(panels);
           console.log(toParse);
           for (i=0; i < toParse.length; i++) {
           var name = toParse[i].name;
           var id = /\d{13}/g;
           var result = name.match(id);
           console.log(name + ": " + result);
           if (result != null) {
        //Find panel in data with largest id and render its view
        //Delete toParse[i]  
        }
        var isId = name.search("id");
        var isTag = name.search("tags_attributes");
        var isOption = name.search("options_attributes");
        if (isId != -1 && isTag == -1 && isOption == -1) {
        console.log(name + ": " + isId);
        }
        } 
         */
        //Refresh panels and preview here
      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //eliminates extra submit events
  });

  $("#pageform").submit();
});
