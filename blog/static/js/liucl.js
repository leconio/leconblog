$(function () {
    /*widgest 中卷起的js*/
    $('.panel-close').click(function () {
        $(this).parent().parent().parent().hide(300);
    });

    $('.collapse').on('hide.bs.collapse', function () {
        $(this).prev().find(".panel-collapse").removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
    });

    $('.collapse').on('show.bs.collapse', function () {
        $(this).prev().find(".panel-collapse").removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
    });


});

/*提示的js*/
//$(function () {
//    $("[data-toggle='tooltip']").tooltip();
//});
//$('#nav-login').tooltip('hide');

///* 回到顶部 */
//$('#toTop').click(function () {
//    $('html,body').animate({scrollTop: '0px'}, 1000);
//    return false;
//});