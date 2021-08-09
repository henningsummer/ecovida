// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui
//= require maskmoney
//= require moment
//= require bootstrap-datetimepicker
//= require clipboard
//= require turbolinks
//= require selectize
//= require chosen-jquery
//= require jquery.mask
//= require_tree .

$(function () {
  $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'Nenhum resultado encontrado',
    width: '260px'
  });
});

$(function () {
  $('.form_datetime').datetimepicker({
    locale: 'pt-br',
    sideBySide: true
  });
});

$(function () {
  $('.form_date').datetimepicker({
    locale: 'pt-br',
    format: 'L',
  });
});

$(document).ready(function(){
    // Add minus icon for collapse element which is open by default
    $(".collapse.in").each(function(){
      $(this).siblings(".panel-heading").find(".glyphicon-folder-close").addClass("glyphicon-folder-open").removeClass("glyphicon-folder-close");
    });

    // Toggle plus minus icon on show hide of collapse element
    $(".collapse").on('show.bs.collapse', function(){
      $(this).parent().find(".glyphicon-folder-close").removeClass("glyphicon-folder-close").addClass("glyphicon-folder-open");
    }).on('hide.bs.collapse', function(){
      $(this).parent().find(".glyphicon-folder-open").removeClass("glyphicon-folder-open").addClass("glyphicon-folder-close");
    });
});

// Tooltip



// Clipboard

$(document).ready(function(){
  $('.clipboard-btn').tooltip({
    trigger: 'click',
    placement: 'bottom'
  });

  function setTooltip(btn, message) {
    $(btn).tooltip('hide')
    .attr('data-original-title', message)
    .tooltip('show');
  }

  function hideTooltip(btn) {
    setTimeout(function() {
      $(btn).tooltip('hide');
    }, 1000);
  }

  var clipboard = new Clipboard('.clipboard-btn');
  console.log(clipboard);

});
