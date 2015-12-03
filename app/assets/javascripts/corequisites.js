$('ul.corequisites').bonsai({
  expandAll: false
});

(function(){
  'use strict';

  $(document).ready(initialize);

  var $selectedCorequisites;
  function initialize(){
    var $checkboxes = $("fieldset.corequisites input[type=checkbox]")
    $checkboxes.filter(":checked").each(function(){
      processCheck($(this), "fast");
    });

    $checkboxes.change(function(){
      if(this.checked){
        processCheck($(this), "slow");
      } else {
        processUncheck($(this));
      }
    });
  }

  function processCheck($checkbox, speed){
      var $selectedCorequisites = $checkbox.closest("fieldset").find("ul.selected_corequisites");
      var $li = $checkbox.closest("li");
      $checkbox.data("originalLi", $li);
      var $inputDiv = $checkbox.closest("div.input");
      $li.fadeOut(speed, function(){
        var $newLi = $("<li></li>").append($inputDiv);
        $selectedCorequisites.append($newLi);
      });
  }

  function processUncheck($checkbox){
      var $currentLi = $checkbox.closest("li");
      var $originalLi = $checkbox.data("originalLi");
      var $inputDiv = $checkbox.closest("div.input");
      $currentLi.fadeOut("slow", function(){
        $currentLi.detach();
        $originalLi.append($inputDiv);
        $originalLi.fadeIn("slow");
      });
  }
})();
