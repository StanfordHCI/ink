function get_options(panel_id) {
  //Get all options from current page's panels
  $.ajax({
    type: "GET",
    url: "/pages/options?panelid=" + panel_id,
    datatype: "json",
    success: function(data) {
      console.log(data);
      for (i=0; i<data.length; i++) {
        Tag(data[i].option_title, data[i].selectpanel_id, panel_id);
      }
    }
  });
}

function Tag(tag_name, panel_id, newpanel_id) {
  console.log("Tag called with " + tag_name);
  this.tag_name = tag_name;
  var tag_request = new XMLHttpRequest();
  var URL = "/pages/tag?tagname=" + tag_name + "&panelid=" + panel_id +"&newpanelid=" + newpanel_id;
  tag_request.open("GET", URL, true);
  tag_request.send(); 
  tag_request.onreadystatechange = function() {
    if (this.readyState==4 && this.status==200) {
      var tags = JSON.parse(this.responseText); //This may not be necessary
      var count = Object.keys(tags).length;
      for(var i=0; i < count; i++) {
        display_tag(tags[i]); 
      } 
    }
  }
}

function display_tag(tag) {
  //Find the correct div for the tag
  var tag_div = document.getElementById("tags" + tag.panel_id);
  if (tag_div.innerHTML == "") {
    $(tag_div).before('<div>Panel present when user selects...</div>');
  }
  var panel_type = 'text_panel';

  if (tag.panel_type == 'Picture') {
    panel_type = 'picture';
  } else if (tag.panel_type == 'MSelectpanel') {
    panel_type = 'm_selectpanel';
  } else if (tag.panel_type == 'SSelectpanel') {
    panel_type = 's_selectpanel';
  } else if (tag.panel_type == 'LeftPicTextpanel') {
    panel_type = 'left_pic_textpanel';
  } else if (tag.panel_type == 'PicCaptionPanel') {
    panel_type = 'pic_caption_panel';
  }

  //Insert the tag into the div
  tag_div.innerHTML += '<input id="page_' + panel_type + 's_attributes_' + tag.panel_id + '_tags_attributes_' + tag.id + '_name" name="page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][name]" type="hidden" value="' + tag.name + '">';
  tag_div.innerHTML += '<input id="page_' + panel_type + 's_attributes_' + tag.panel_id + '_tags_attributes_' + tag.id + '_destroy" name="page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][_destroy]" type="hidden" value="false">';
  tag_div.innerHTML += '<input id="page_' + panel_type + 's_attributes_' + tag.panel_id + '_tags_attributes_' + tag.id + '_page_id" name="page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][page_id]" type="hidden" value="' + tag.page_id +'">';
  tag_div.innerHTML += '<input id="page_' + panel_type + 's_attributes_' + tag.panel_id + '_tags_attributes_' + tag.id + '_panel_type" name="page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][panel_type]" type="hidden" value="' + tag.panel_type + '">';
  tag_div.innerHTML += '<input name=page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][value]" type="hidden" value="0">';
  tag_div.innerHTML += '<input id="page_' + panel_type + 's_attributes_' + tag.panel_id + '_tags_attributes_' + tag.id + '_value" name="page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][value]" type="checkbox" value="1">';
  tag_div.innerHTML += tag.name;
  tag_div.innerHTML +='<br/>';
  tag_div.innerHTML += '<input id="page_' + panel_type + 's_attributes_' + tag.panel_id + '_tags_attributes_' + tag.id + '_id" name="page[' + panel_type + 's_attributes][' + tag.panel_id + '][tags_attributes][' + tag.id + '][id]" type="hidden" value="' + tag.id + '">';
} 
