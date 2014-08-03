function Tag(tag_name) {
  this.tag_name = tag_name;

  var tag_request = new XMLHttpRequest();
  var URL = "/pages/tag?tagname=" + tag_name;
  tag_request.open("GET", URL, true);
  tag_request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  tag_request.send(); 
  tag_request.onreadystatechange = function() {
    if (this.readyState==4 && this.status==200) {

      console.log(this.responseText);
      var tags = JSON.parse(this.responseText);
      console.log(tags);
      var count = Object.keys(tags).length;
      console.log(count);
      for(var i=0; i < count; i++) {
        display_tag(tags[i]); 
      } 
    }
  }
}

function display_tag(tag) {
  //find the correct div for the tag
  //insert the tag into the div
  var tag_div = document.getElementById("tags" + tag[0].panel_id);
 
  var tag_id = 1234567891234; //temporary value; should be randomly generated?

  var panel_type = "text_panels";
  if (tag[1] == "Picture") {
    panel_type = "pictures";
  } else if (tag[1] == "SSelectpanel") {
    panel_type = "s_selectpanels";
  } else if (tag[1] == "MSelectpanel") {
    panel_type = "m_selectpanels";
  }

  tag_div.innerHTML += '<input id="page_' + panel_type + '_attributes_' + tag[0].panel_id + '_tags_attributes_' + tag_id + '_name" name="page[' + panel_type + '_attributes][' + tag[0].panel_id + '][tags_attributes][' + tag_id + '][name]" type="hidden">';
  tag_div.innerHTML += '<input id="page_' + panel_type + '_attributes_' + tag[0].panel_id + '_tags_attributes_' + tag_id + '_destroy" name="page[' + panel_type + '_attributes][' + tag[0].panel_id + '][tags_attributes][' + tag_id + '][_destroy]" type="hidden" value="false">';
  tag_div.innerHTML += '<input name=page[' + panel_type + '_attributes][' + tag[0].panel_id + '[tags_attributes][' + tag_id + '][value]" type="hidden" value="0">';
  tag_div.innerHTML += '<input id="page_' + panel_type + '_attributes_' + tag[0].panel_id + '_tags_attributes_' + tag_id + '_value" name="page[' + panel_type + '_attributes][' + tag[0].panel_id + '][tags_attributes][' + tag_id + '][value]" type="checkbox" value = "1">';


  tag_div.innerHTML += tag[0].name; //Figure out how to make the HTML for the form fields

  //var divs = document.getElementsByTagName('*'), i;
  //for (i in divs) {
  //  if ((' ' + divs[i].className + ' ' ).indexOf(' ' + div_class + ' ') > -1) {
  //    divs[i].innerHTML += "<%= add_tags f, :tags, " + tag_name + "%>";
  //  }
  //}
} 