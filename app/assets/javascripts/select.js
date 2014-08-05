window.onload = function() {
  allow_select();
}

function allow_select() {
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

      display_panels();
    }
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
        display_panels();
      } else {
        selected_tags.push(selected);
        console.log(selected_tags);
        e.target.style.background = "blue";
        display_panels();
      }
    }
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
      var div = document.getElementById("panels");
      var display = JSON.parse(this.responseText);
      div.innerHTML = display.results; 

      var single_targets = $(".service-block");
      for (i=0; i < single_targets.length; i++) {
        block = single_targets[i];
        if ((selected_tags.indexOf(block.childNodes[3].innerHTML)) != -1) {
          block.id = "selected";
          //block.css("background-color", "#D3D3D3");
          block.style.background = "#000000";
        }
        allow_select();
      }
      var multi_targets = $(".hi-icon");
      for (i=0; i < multi_targets.length; i++) {
        icon = multi_targets[i];
        block = $(icon).parent().parent();
        title = block[0].children[1].children[0].innerHTML;
        if ((selected_tags.indexOf(title)) != -1) {
          icon.style.background = "blue";
        }
        allow_select();
      }
    }
  }
};
