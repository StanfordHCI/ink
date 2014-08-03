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
    var children = e.target.childNodes;
    if (children.length == 3) {
      var lastSelected = document.getElementById("selected");
      if (lastSelected) {
        var index = selected_tags.indexOf(lastSelected.children[1].innerHTML);
        lastSelected.id = "";
        if (index > -1) {
          selected_tags.splice(index, 1);
        }
      }

      var tag = children[1];
      selected = tag.innerHTML;
      selected_tags.push(selected);
      console.log(selected_tags);

      $('.service-block').css("background-color", "#D3D3D3");
      e.target.style.background = "#000000";
      e.target.id = "selected";
    }

  });
  $('.multi-select').on("click", function(e) {
    if (!e.target.firstChild) {
      var container = e.target.parentNode.parentNode;
      var selected = container.children[1].children[0].innerHTML;

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
  });
};

$(document).ready(function() {
  selected_tags = [];
});
