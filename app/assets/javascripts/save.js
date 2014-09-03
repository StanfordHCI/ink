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
        var id = JSON.parse(data); //Get new panel's ID from controller
        panel.children()[0].id = "panel" + id; 
        panel_fields_id = panel.children()[0].id;
        var fields = $(panel.children()[0]).children().children();
        var panel_type = undefined;
        
        //Changes all temporarily generated IDs to actual panel ID
        for (i=0; i<fields.length; i++) {
          //Storing panel type if not yet defined
          if(fields[i].htmlFor != undefined) {
            if (panel_type == undefined) {
              if(fields[i].htmlFor.match('text_panels_attributes')){
                panel_type = 'text_panels';
              } else if(fields[i].htmlFor.match('pictures_attributes')){
                panel_type = 'pictures';
              } else if(fields[i].htmlFor.match('s_selectpanels_attributes')){
                panel_type = 's_selectpanels';
              } else if(fields[i].htmlFor.match('m_selectpanels_attributes')){
                panel_type = 'm_selectpanels';
              }
            }
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
        document.getElementById(panel_fields_id).innerHTML += '<input id="page_'+panel_type+'_attributes_'+id+'_id" name="page[' +panel_type+ '_attributes]['+id+'][id]" type="hidden" value="'+id+'">'; //Add hidden field for panel id
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
