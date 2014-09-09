$(document).on('nested:fieldAdded:text_panels', function(event) {
  update_form(event, false);
});

$(document).on('nested:fieldAdded:pictures', function(event) {
  update_form(event, false);
});

$(document).on('nested:fieldAdded:m_selectpanels', function(event) {
  update_form(event, false);
});

$(document).on('nested:fieldAdded:s_selectpanels', function(event) {
  update_form(event, false);
});

$(document).on('nested:fieldAdded:options', function(event) {
  update_form(event, true);
});

function update_form(event, isOption) {
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
        var id = JSON.parse(data)[0]; //Get newest panel's ID from controller
        var panel_tags = JSON.parse(data)[1];
        var panel_fields_id;
        if (panel.children()[0].id == "panel") { //Consider changing this to !isOption
          panel.children()[0].id = "panel" + id; //Resetting ID of panel div
          panel_fields_id = panel.children()[0].id; //Store panel ID
        }
        var fields = $(panel.children()[0]).children().children(); //Form fields for the panel
        var panel_type = undefined;

        //Changes all temporarily generated IDs to actual panel ID
        for (i=0; i<fields.length; i++) {
          if(fields[i].htmlFor != undefined) {
            if (panel_type == undefined) { //Storing panel type if not yet defined
              panel_type = get_panel_type(fields[i].htmlFor);
            }
            fields[i].htmlFor = fields[i].htmlFor.replace(/\d{13}/g, id);
          }
          if (fields[i].id != undefined) {
            if (fields[i].id == "tags") {
              fields[i].id = "tags" + id;
            }
            fields[i].id = fields[i].id.replace(/\d{13}/g, id);
          }
          if (fields[i].name != undefined) {
            fields[i].name = fields[i].name.replace(/\d{13}/g, id);
          }
          if (fields[i].type == "file" ) {
            file_upload(fields[i]);
          }

          //Relabel a panel's tags
          tags = $(fields[i]).children();
          for (k=0; k<tags.length; k++) {
            tag_fields = $(tags[k]).children(); 
            for (j=0; j<tag_fields.length; j++) {
              relabel_tags(tag_fields[j], id, panel_tags[k].id);
            }
            $(document.getElementById("tags"+id)).children()[k].innerHTML += '<input id="page_'+panel_type+'_attributes_'+id+'_tags_attributes_'+panel_tags[k].id+'_id" name="page['+panel_type+'_attributes]['+id+'][tags_attributes]['+panel_tags[k].id+'][id]" type="hidden" value="'+panel_tags[k].id+'">'; //Add hidden field for tag id
          }
        }
        if (panel_fields_id != undefined) { //Check that update_form is being called on a panel and not an option; consider changing to !isOption
          document.getElementById(panel_fields_id).innerHTML += '<input id="page_'+panel_type+'_attributes_'+id+'_id" name="page[' +panel_type+ '_attributes]['+id+'][id]" type="hidden" value="'+id+'">'; //Add hidden field for panel id
          $(document.getElementById(panel_fields_id)).children()[0].innerHTML += '<div class="preview">'+JSON.parse(data)[2]+'</div>'; //Add panel preview
          $("nav").find("ul")[0].innerHTML += '<li><a href="#panel' + id + '">[New Panel]</a></li>'; 
        }
        console.log("Form submitted");
        if (isOption) {
          var panel_var = $(event.field).parent().parent();
          var panel_id = (panel_var[0].id).match(/\d+/);
          relabel_options(event, panel_id);
          console.log("Added an option");
        }
      }
    });
    e.preventDefault();
    $("#pageform").off('submit'); //Eliminates extra submit events
  });

  $("#pageform").submit(); //Calls above submit function
  delete_panels();
  delete_options();
};

//Returns the panel type based on form label field
function get_panel_type(label) {
  if(label.match('text_panels_attributes')){return 'text_panels';}
  if(label.match('pictures_attributes')){return 'pictures';}
  if(label.match('s_selectpanels_attributes')){return 's_selectpanels';}
  if(label.match('m_selectpanels_attributes')){return 'm_selectpanels';}
  return undefined; //Should never reach here
}

//Resets ID and name for tag form fields
function relabel_tags(tag, id, tag_id) {
  tag.id = tag.id.replace(/\d{13}/g, id);
  tag.id = tag.id.replace(/\d{10}/g, tag_id);
  tag.name = tag.name.replace(/\d{13}/g, id);
  tag.name = tag.name.replace(/\d{10}/g, tag_id);
}

//Deletes hidden panels that have been destroyed in the database
function delete_panels() {
  var destroy_fields = $(".destroy");
  for (i=0; i<destroy_fields.length; i++) {
    if (destroy_fields[i].value == 1) {
      $(destroy_fields[i]).parent().parent().parent().remove();
    } 
  }
}

//Deletes hidden option fields that have been destroyed in the database
function delete_options() {
  var destroy_fields = $(".destroy_option");
  for (i=0; i<destroy_fields.length; i++) {
    if (destroy_fields[i].value == 1) {
      $(destroy_fields[i]).parent().parent().remove();
    }
  }
}

//Resets ID and name for option form fields and adds hidden field
function relabel_options(event, panel_id) {
  option_fields = event.field;
  $.ajax({
    type: "GET",
    url: "/pages/option?panelid="+panel_id,
    datatype: "json",
    success: function(data){
      fields = $(option_fields).children().children();
      var panel_type = undefined;
      option_fields.children()[0].id = "options" + data.id;
      for (i=0; i<fields.length; i++) {
        if(fields[i].htmlFor != undefined) {
          if (panel_type == undefined) { //Storing panel type if not yet defined
            panel_type = get_panel_type(fields[i].htmlFor);
          }
          fields[i].htmlFor = fields[i].htmlFor.replace(/\d{13}/g, data.id);
        }
        if (fields[i].name != undefined) {
          fields[i].name = fields[i].name.replace(/\d{13}/g, data.id); 
        }
        if (fields[i].id!= undefined) {
          if (fields[i].id != fields[i].id.match(/\d+/)) {
            fields[i].id = fields[i].id.replace(/\d{13}/g, data.id); 
          }
        }
      }
      $(document.getElementById("options"+data.id)).parent()[0].innerHTML += '<input id="page_' + panel_type +'_attributes_' + panel_id +'_options_attributes_' + data.id +'" name="page['+ panel_type + '_attributes][' + panel_id +'][options_attributes][' + data.id + '][id]" type="hidden" value="'+ data.id + '">'; //Add hidden fields to the option
    }
  });
}
