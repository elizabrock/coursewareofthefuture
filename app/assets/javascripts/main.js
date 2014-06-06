(function(){

  'use strict';

  $(document).ready(initialize);

  function initialize(){
    $('#upcoming_material').click(show1);
    $('#material_to_cover').click(show2);
    $('#material_covered').click(show3);
  }

  function show1(){
    $('#upcoming_material').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, rgb(214, 251, 252) 0%, rgb(148, 203, 206) 100%)').css('border-top', '1px solid').css('border-bottom', '1px solid').css('border-left', '1px solid');
    $('#material_to_cover').css('background', 'none').css('border', 'none');
    $('#material_covered').css('background', 'none').css('border', 'none');
    $('#covered_materials').hide();
    $('#material_to_cover_yet').hide();
    $('#upcoming_materials').css('display', 'block').css('background', '-webkit-radial-gradient(center, ellipse, rgba(214,251,252,1) 0%,rgba(148,203,206,1) 100%)');//.css('background', '-webkit-linear-gradient(-45deg, #e4f5fc 0%,#bfe8f9 50%,#9fd8ef 96%,#9fd8ef 96%,#2ab0ed 100%)').css('background-size', 'cover');
  }

  function show2(){
    $('#material_to_cover').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, rgb(214, 251, 252) 0%, rgb(148, 203, 206) 100%)').css('border-top', '1px solid').css('border-bottom', '1px solid').css('border-left', '1px solid');
    $('#upcoming_material').css('background', 'none').css('border', 'none');
    $('#material_covered').css('background', 'none').css('border', 'none');
    $('#upcoming_materials').hide();
    $('#covered_materials').hide();
    $('#material_to_cover_yet').css('display', 'block').css('background', '-webkit-radial-gradient(center, ellipse, rgba(214,251,252,1) 0%,rgba(148,203,206,1) 100%)');//.css('background', '-webkit-linear-gradient(-45deg, #e4f5fc 0%,#bfe8f9 50%,#9fd8ef 96%,#9fd8ef 96%,#2ab0ed 100%)').css('background-size', 'cover');
  }

  function show3(){
    $('#material_covered').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, rgb(214, 251, 252) 0%, rgb(148, 203, 206) 100%)').css('border-top', '1px solid').css('border-bottom', '1px solid').css('border-left', '1px solid');
    $('#upcoming_material').css('background', 'none').css('border', 'none');
    $('#material_to_cover').css('background', 'none').css('border', 'none');
    $('#upcoming_materials').hide();
    $('#material_to_cover_yet').hide();
    $('#covered_materials').css('display', 'block').css('background', '-webkit-radial-gradient(center, ellipse, rgba(214,251,252,1) 0%,rgba(148,203,206,1) 100%)');//.css('background', '-webkit-linear-gradient(-45deg, #e4f5fc 0%,#bfe8f9 50%,#9fd8ef 96%,#9fd8ef 96%,#2ab0ed 100%)').css('background-size', 'cover');
  }

})();
