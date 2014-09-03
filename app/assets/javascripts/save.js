$(document).on('nested:fieldAdded', function(event) {
  $('table').hide();
  $('#panel_button').show();
  var panel = event.field;

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
        var id = JSON.parse(data)[0]; //Get new panel's ID from controller
        panel_tags = JSON.parse(data)[1];
        panel.children()[0].id = "panel" + id; //Resetting ID of panel div
        panel_fields_id = panel.children()[0].id; //Store panel ID
        var fields = $(panel.children()[0]).children().children(); //Form fields for the panel
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
          tags = $(fields[i]).children();
          for (k=0; k<tags.length; k++) {
            tag_fields = $(tags[k]).children(); 
            for (j=0; j<tag_fields.length; j++) {
              relabel(tag_fields[j], id, panel_tags[k].id);
            }
            $(document.getElementById("tags")).children()[k].innerHTML += '<input id="page_'+panel_type+'_attributes_'+id+'_tags_attributes_'+panel_tags[k].id+'_id" name="page['+panel_type+'_attributes]['+id+'][tags_attributes]['+panel_tags[k].id+'][id]" type="hidden" value="'+panel_tags[k].id+'">';
          }
        }
        document.getElementById(panel_fields_id).innerHTML += '<input id="page_'+panel_type+'_attributes_'+id+'_id" name="page[' +panel_type+ '_attributes]['+id+'][id]" type="hidden" value="'+id+'">'; //Add hidden field for panel id
        console.log("Form submitted");
      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //Eliminates extra submit events
  });

  $("#pageform").submit(); //Calls above submit function
});

//Resets ID and name for tag form fields
function relabel(tag, id, tag_id) {
  tag.id = tag.id.replace(/\d{13}/g, id);
  tag.id = tag.id.replace(/\d{10}/g, tag_id);
  tag.name = tag.name.replace(/\d{13}/g, id);
  tag.name = tag.name.replace(/\d{10}/g, tag_id);
}
