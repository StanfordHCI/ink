// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require jquery_nested_form

//Print each file_field in the console
$(function() {
  $('.directUpload').find("input:file").each(function(i, elem) {
    var fileInput    = $(elem);
    console.log(fileInput);
  });
});

//Creates progress bar for each file
$(function() {
  $('.directUpload').find("input:file").each(function(i, elem) {
    var fileInput    = $(elem);
    var form         = fileInput.parents('form:first');
    var submitButton = form.find('input[type="submit"]');
    var progressBar  = $("<div class='bar'></div>");
    var barContainer = $("<div class='progress'></div>").append(progressBar);
    fileInput.after(barContainer);
  });
});

$(document).on('nested:fieldAdded:pictures'), function(e) {

  var field = e.field;
  alert(field);
  console.log('Added a field');

  //function Save() {
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
          /*
             var isId = name.search("id");
             var isTag = name.search("tags_attributes");
             var isOption = name.search("options_attributes");
             if (isId != -1 && isTag == -1 && isOption == -1) {
             console.log(name + ": " + isId);
             }
           */
        } 
        //Refresh panels and preview here
      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //eliminates extra submit events
  });

  $("#pageform").submit();
}
