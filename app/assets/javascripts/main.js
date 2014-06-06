(function(){

  'use strict';

  $(document).ready(initialize);

  function initialize(){
    $('#upcoming_material').click(show1);
    $('#material_to_cover').click(show2);
    $('#material_covered').click(show3);
  }

  function show1(){
    $('#upcoming_material').css('background', 'none').css('border', 'none');
    $('#material_to_cover').css('border-bottom', '1px solid').css('border-right', '1px solid').css('border-left', '1px solid').css('border-top', 'none').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, #d6fbfc 0%, #94cbce 100%)');
    $('#material_covered').css('border-top', '1px solid').css('border-right', '1px solid').css('border-left', '1px solid').css('border-bottom', '1px solid').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, #d6fbfc 0%, #94cbce 100%)');
    $('#covered_materials').hide();
    $('#material_to_cover_yet').hide();
    $('#upcoming_materials').fadeIn(500).css('display', 'block');
  }

  function show2(){
    $('#material_to_cover').css('background', 'none').css('border', 'none');
    $('#upcoming_material').css('border-bottom', '1px solid').css('border-right', '1px solid').css('border-left', '1px solid').css('border-top', '1px solid').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, #d6fbfc 0%, #94cbce 100%)');
    $('#material_covered').css('border-top', '1px solid').css('border-right', '1px solid').css('border-left', '1px solid').css('border-bottom', '1px solid').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, #d6fbfc 0%, #94cbce 100%)');
    $('#upcoming_materials').hide();
    $('#covered_materials').hide();
    $('#material_to_cover_yet').fadeIn(500).css('display', 'block');
  }

  function show3(){
    $('#material_covered').css('background', 'none').css('border', 'none');
    $('#material_to_cover').css('border-bottom', 'none').css('border-right', '1px solid').css('border-left', '1px solid').css('border-top', '1px solid').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, #d6fbfc 0%, #94cbce 100%)');
    $('#upcoming_material').css('border-right', '1px solid').css('border-left', '1px solid').css('border-bottom', '1px solid').css('background', '-webkit-radial-gradient(50% 50%, ellipse cover, #d6fbfc 0%, #94cbce 100%)');
    $('#upcoming_materials').hide();
    $('#material_to_cover_yet').hide();
    $('#covered_materials').fadeIn(500).css('display', 'block');
  }

})();
