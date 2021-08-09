 $('document').ready(function(){
   const node = $('.JS-certified-members')

   if(!node.length) { return; }

   const core = $('#report_core_id');
   const dateSelect = $('#report_use_date');
   const dateFrom = $('#report_from');
   const dateTo = $('#report_to');
   const btn = $('input[type=submit]');
   const email = $('#report_email');

   btn.attr({ disabled: true });

   email.on('change keyup', function () {
     const leng = $(this).val().length;

     if(leng > 0) {
       btn.attr({ disabled: false });
     } else  {
       btn.attr({ disabled: true });
     }
   });

   node.on('change', function() {
     const selected = node.find('option:selected').val();

     if(selected == 'Todos os núcleos') {
       core.attr({ disabled: true, readonly: 'readonly' });
       core.val('');
     } else {
       core.attr({ disabled: false, readonly: false })
     }
   });

   dateSelect.on('change', function() {
     const selected = dateSelect.find('option:selected').val();

     if(selected == 'Ano Passado') {
       dateFrom.attr({ disabled: true, readonly: 'readonly' });
       dateFrom.val('');
       dateTo.attr({ disabled: true, readonly: 'readonly' });
       dateTo.val('');
     } else {
       dateFrom.attr({ disabled: false, readonly: false })
       dateTo.attr({ disabled: false, readonly: false })
     }
   })
 });
