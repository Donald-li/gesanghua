// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require js-routes
//= require jquery
//= require rails-ujs
//= require 'china_city/jquery.china_city'
//= require 'plugin/jquery.timeago'
//= require 'plugin/jquery.nested_attributes.js'
//= require 'plugin/webuploader'
//= require 'plugin/init_webuploader'
//= require 'plugin/paginate.js'
//= require 'plugin/jquery-html5Validate-pc.js'
//= require 'plugin/jquery.vticker-min.js'
//= require 'plugin/jqueryqr.js'
//= require 'plugin/toTop.js'
//= require 'plugin/jquery.let_it_snow.js'
//= require 'plugin/checkbox.js'
//= require 'plugin/progresscircle.js'
//= require 'plugin/tab-nav.js'
//= require 'plugin/timeago.js'
//= require 'plugin/jquery.mCustomScrollbar.concat.min.js'
//= require 'plugin/jquery.share.min.js'
//= require 'plugin/ui-choose.js'
//= require 'plugin/mongolian.js'
//= require 'plugin/jquery.magnify.js'
//= require 'plugin/calculate.js'
//= require toastr
// = require 'plugin/popper.min.js'
//= require 'plugin/parsley.min.js'
//= require 'plugin/parsley.min.zextra.js'
//= require 'plugin/parsley.min.zh_cn.js'
//= require 'plugin/jquery.placeholder.min.js'
//= require 'plugin/full-screen-slide.min.js'
//= require 'plugin/changeImg.js'
//= require 'plugin/scroll.1.3.js'
//= require 'plugin/owl.carousel.js'
//= require 'plugin/browser.js'
//= require 'plugin/select2.min.js'
//= require 'plugin/select2.zh-CN.js'

$(function () {
    $("body").css("font-family", "'PingFang SC', '????????????', 'Microsoft YaHei', Helvetica, 'Helvetica Neue', Tahoma, Arial, sans-serif")
    // head??????
    $('.search-box .form-control').focus(function () {
        $(this).closest('.search-box').addClass('focus');
    }).blur(function () {
        if ($(this).val() === '') {
            $(this).closest('.search-box').removeClass('focus');
        }
    })

    var windowInnerHeight = $(window).innerHeight();

    $('.min-wrap').css('min-height', windowInnerHeight - 198);

    //timeago
    // $('.timeago').timeago();
    var timeagoInstance = new timeago();
    $('.timeago').each(function (index, el) {
        $(el).html(timeagoInstance.format($(el).data('timeago'), 'zh_CN'))
    })
    // timeagoInstance.format('2016-06-12', 'zh_CN');

    //??????????????????
    if ($(window).height() <= $(document.body).height()) {
        $('.bul-footer').css({'position': 'static'})
    } else {
        $('.bul-footer').css({'position': 'fixed', 'left': '0', 'bottom': '0'})
    }
    //????????????
    $('#navshow').mouseenter(function () {
        $('.bul-nav-heide').css({'display': 'block'})
    })
    $('#navshow').mouseleave(function () {
        $('.bul-nav-heide').css({'display': 'none'})
    })

    //???????????????????????????
    $('.bul-top-2').mousemove(function () {
        $('.bul-pos4').css({'display': 'block'})

    });
    $('.bul-top-2').mouseout(function () {
        $('.bul-pos4').css({'display': 'none'})

    });
    $('.right-foot-1').mousemove(function () {
        $('.bul-pos1').css({'display': 'block'})
        $('.right-foot-1').css({'background': '#fff', 'color': '#3b3b3b'})
    });
    $('.right-foot-1').mouseout(function () {
        $('.bul-pos1').css({'display': 'none'})
        $('.right-foot-1').css({'background': '#3b3b3b', 'color': '#fff'})
    });
    $('.right-foot-2').mousemove(function () {
        $('.bul-pos2').css({'display': 'block'})
        $('.right-foot-2').css({'background': '#fff', 'color': '#3b3b3b'})
    });
    $('.right-foot-2').mouseout(function () {
        $('.bul-pos2').css({'display': 'none'})
        $('.right-foot-2').css({'background': '#3b3b3b', 'color': '#fff'})
    });
    // //????????????????????????
    // $(document).ready(function () {
    //     var navHeight = $("#navHeight").offset().top;
    //     var navFix = $("#navHeight");
    //     $(window).scroll(function () {
    //         if ($(this).scrollTop() > navHeight) {
    //             navFix.addClass("navFix");
    //         }
    //         else {
    //             navFix.removeClass("navFix");
    //         }
    //     })
    // })

    if ($('.school-apply-pair-tables').length > 8) {
        $('.posscroll').css('height', '800px')
    }
//    ??????
//     jQuery.fn.center = function (loaded) {
//         var obj = this;
//         body_width = parseInt($(window).width());
//         body_height = parseInt($(window).height());
//         block_width = parseInt(obj.width());
//         block_height = parseInt(obj.height());
//
//         left_position = parseInt((body_width / 2) - (block_width / 2) + $(window).scrollLeft());
//         if (body_width < block_width) {
//             left_position = 0 + $(window).scrollLeft();
//         }
//         ;
//
//         top_position = parseInt((body_height / 2) - (block_height / 2) + $(window).scrollTop());
//         if (body_height < block_height) {
//             top_position = 0 + $(window).scrollTop();
//         }
//         ;
//         if (!loaded) {
//             $(window).bind('resize', function () {
//                 obj.center(!loaded);
//             });
//             $(window).bind('scroll', function () {
//                 obj.center(!loaded);
//             });
//         }
//     }
})


