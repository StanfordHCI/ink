$(function() {
  $(document).on('change', function() {
    Tag(

function Tag(tag_name, div_class) {
  this.div_class = div_class;
  this.tag_name = tag_name;
  var tag_request = new XMLHttpRequest();
  var divs = document.getElementsByTagName('*'), i;
  tag_request.onreadystatechange = function() {
    for (i in divs) {
      if ((' ' + divs[i].className + ' ' ).indexOf(' ' + div_class + ' ') > -1) {
        divs[i].innerHTML += tag_name;
      }
    }
  }
  var URL = "/pages/<%=page.id%>/tag?tagname=" + this.tag_name;
  tag_request.open("GET", URL, true);
}
