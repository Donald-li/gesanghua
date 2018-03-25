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
//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets
//= require bootstrap-switch
//= require 'plugin/vue.min'
//= require 'china_city/jquery.china_city'
//= require 'plugin/jquery.timeago'
//= require 'plugin/jquery.nested_attributes.js'
//= require 'plugin/webuploader'
//= require 'plugin/init_webuploader'
//= require 'plugin/paginate.js'
//= require 'plugin/jquery-html5Validate-pc.js'
//= require 'plugin/jquery.vticker-min.js'
//= require 'plugin/jqueryqr.js'
//= require 'plugin/qrcode.js'
//= require 'plugin/toTop.js'
//= require 'plugin/jquery.let_it_snow.js'
//= require 'plugin/checkbox.js'
//= require 'plugin/progresscircle.js'




$(function () {
  // head搜索
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
  $('.timeago').timeago();
    //判断屏幕高度
    if ($(window).height() <= $(document.body).height()){
        $('.bul-footer').css({'position':'static'})
    }else {
        $('.bul-footer').css({'position':'fixed','left':'0','bottom':'0'})
    }
    //导航标题
    $('#navshow').mouseenter(function(){
        $('.bul-nav-heide').css({'display':'block'})
    })
    $('#navshow').mouseleave(function(){
        $('.bul-nav-heide').css({'display':'none'})
    })
    $('.bul-nav-heide').mousedown(function(){
        $('.bul-nav-heide').css({'display':'none'})
    })

    //二维码设置
    $('#container2').erweima({
        label: '格桑花'
    });
    $('#container3').erweima({
        label: '微博'
    });
    $('#container4').erweima({
        label: '微博'
    });
    //二维码移入移除变化
    $('.bullet-tit-icon').click(function () {
        $('.bullet').css({'display': 'none'})
    })
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

});
