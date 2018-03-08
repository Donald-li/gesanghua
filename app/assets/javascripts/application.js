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

});
