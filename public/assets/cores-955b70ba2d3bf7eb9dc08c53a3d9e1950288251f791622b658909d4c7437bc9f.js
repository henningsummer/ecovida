$(document).ready(function () {
  var hidden = true;
  $(".search").hide();
   $(".showhide").click(function(){
    if(hidden == true){
      $(".search").show();
      hidden = false;
      $(".showhide").text("Ocultar pesquisa");
    }else{
      $(".search").hide();
      $(".showhide").text("Pesquisar");
      hidden = true;
    }
  });
});
