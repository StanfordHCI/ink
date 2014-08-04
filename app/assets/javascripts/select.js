window.onload = function() {
  $('body').click(function(e){  
    if (e.target.id == 'go') {
      console.log(document.body.children[4].id);
      var first = '#' + document.body.children[4].id;
      $('html,body').animate({scrollTop:$(first).offset().top}, 1000);
    }
  });
  $('.single-select').on("click", function(e) {
    var selected;
    var service_blocks = $(".service-block");
    var children = e.target.childNodes;
    
    //Debugging 
    console.log(e.target);
    console.log(children);
    console.log(children.length); 
   
    if (children.length == 7) {
      var lastSelected = document.getElementById("selected");
      console.log(lastSelected);
      if (lastSelected) {
        var index = selected_tags.indexOf(lastSelected.children[1].innerHTML);
        lastSelected.id = "";
        if (index > -1) {
          selected_tags.splice(index, 1);
        }
      }

      var tag = children[3];
      selected = tag.innerHTML;
      selected_tags.push(selected);
      console.log(selected_tags);

      $('.service-block').css("background-color", "#D3D3D3");
      e.target.style.background = "#000000";
      e.target.id = "selected";
    }
    display_panels();
  });
  $('.multi-select').on("click", function(e) {
    if (!e.target.firstChild) {
      var container = e.target.parentNode.parentNode;
      console.log(container);
      var selected = container.children[1].children[0].innerHTML;
      console.log(selected);

      if (e.target.style.background == "blue") {
        var index = selected_tags.indexOf(selected);
        if (index > -1) {
          selected_tags.splice(index, 1);
        }
        e.target.style.background = "#3598db";
      } else {
        selected_tags.push(selected);
        console.log(selected_tags);
        e.target.style.background = "blue";
      }
    }
    display_panels();
  });
};

$(document).ready(function() {
  selected_tags = [];
});

function display_panels() {
  var select_request = new XMLHttpRequest();
  var URL = "/sites/select?selected=" + selected_tags;
  select_request.open("GET", URL, true);
  select_request.send();
  select_request.onreadystatechange = function() {
    if (this.readyState==4 && this.status==200) {
      console.log(this.responseText);
      var display = JSON.parse(this.responseText);
      console.log(display);
      var count = Object.keys(display).length;
      console.log(count);
      var div = document.getElementById("panels");
      div.innerHTML = "";
      for(var i=0; i < count; i++) {
        if (display[i][1] == "TextPanel") {
          generate_text(div, display[i][0]);
        } else if (display[i][1] == "Picture") {
          generate_picture(div, display[i][0]);
        } else if (display[i][1] == "SSelectpanel") {
          generate_single(div, display[i]);
        } else {
          generate_multi(div, display[i]);
        }
      }
    }
  }
}

function generate_text(div, panel) {
  var name = panel.panel_name;
  if (panel.display == 0) {
    name = "";
  }
  div.innerHTML += "<section id='parallax-quote' class='parallax'><div class='parallax-background" + panel.id + "parallax-background'></div><div class='container'><div class='row'><div class='col-md-12'><div class='parallax-content'><blockquote>" + name + "<footer>" + panel.info + "</footer></blockquote></div></div></div></div></section>";
}

function generate_picture(div, panel) {
  var name = panel.panel_name;
  if (panel.display == 0) {
    name = "";
  }
  div.innerHTML += "<body><section id='parallax-quote' class='parallax'><div class='parallax-background" + panel.id + "parallax-background'></div><div class='container'><div class='row'><div class='col-md-12'><div class='parallax-content'><blockquote>" + name + "<footer>" + panel.info + "</footer></blockquote></div></div></div></div></section></body>";
}

function generate_single(div, single_select) {
  var panel = single_select[0];
  var options = single_select[2];
  var name = panel.panel_name;
  if (panel.display == 0) {
    name = "";
  }
  div.innerHTML += "<section id='page-services' class='page-services single-select'><div class='container'><header class='section-header'><h2 class='section-title'><span>" + name + "</span></h2><div class='spacer'></div><p class='section-subtitle'>" + panel.info + "</p></header>";
  var count = 0;
  var num_options = options.length;
  for(var i=0; i < num_options; i++) {
    var option = options[i];
    if ((count % 3) == 0) {
      div.innerHTML += "<div class='row'>";
    }
    div.innerHTML += "<div class='col-md-4'><div class='service-block'><div class='service-icon'><i class='fa fa-" + option.id + "'></i></div><h3>" + option.option_title + "</h3><p>'INSERT OPTION DESCRIPTION ATTRIBUTE HERE.'</p></div></div>";
    count++;
    if ((count % 3) == 0) {
      div.innerHTML += "</div>";
    }
  }
  if ((count % 3) != 0) {
    div.innerHTML += "</div>";
  }
  div.innerHTMLR += "</div></section>";    
}

function generate_multi(div, multi_select) {
  var panel = multi_select[0];
  var options = multi_select[2];
  var name = panel.panel_name;
  if (panel.display == 0) {
    name = "";
  }
  div.innerHTML += "<section id='page-about' class='page-about multi-select'><div class='container'><header class='section-header'><h2 class='section-title'>" + name + "</h2><div class='spacer'></div><p class='section-subtitle'>" + panel.info + "</p></header>";
  var count = 0;
  var num_options = options.length;
  for(var i=0; i < num_options; i++) {
    var option = options[i];
    if ((count % 3) == 0) {
      div.innerHTML += "<div class='row'>";
    }
    div.innerHTML += "<div class='col-md-4 text-center'><div class='research hi-icon-effect-1'><i class='hi-icon fa fa-" + option.id + "'></i></div><header class='process-header'><h3>" + option.option_title + "</h3><p>'INSERT OPTION DESCRIPTION ATTRIBUTE HERE.'</p></header></div>";
    count++;
    if ((count % 3) == 0) {
      div.innerHTML += "</div>";
    }
  }
  if ((count % 3) != 0) {
    div.innerHTML += "</div>";
  }
  div.innerHTML += "</div></section>";    
}
