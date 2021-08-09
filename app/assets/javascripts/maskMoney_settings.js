$(document).ready(function () {
  $('.currency')
    .maskMoney({
      prefix:'R$ ',
      allowNegative: false,
      decimal:',',
      thousands:'.',
      affixesStay: false
    })
});
