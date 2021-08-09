$(document).ready(function () {
  var hidden = true;
  $(".infos").hide();
   $(".showhide").click(function(){
    if(hidden == true){
      $(".infos").show();
      hidden = false;
      $(".showhide").text("Ocultar informações");
    }else{
      $(".infos").hide();
      $(".showhide").text("Mostrar todas informações");
      hidden = true;
    }
  });
});
