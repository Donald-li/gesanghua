//= require jquery_ujs
//= require action_cable
//= require_tree ./plugin
// require Chart.bundle
// require chartkick
//= require ckeditor/init
//= require 'china_city/jquery.china_city'
//= require_self
//= require echarts.common

//判断是否是IE浏览器，包括Edge浏览器
function IEVersion() {
  var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
  var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器
  var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE浏览器
  var isEdge = userAgent.indexOf("Windows NT 6.1; Trident/7.0;") > -1 && !isIE; //判断是否IE的Edge浏览器
  if (isIE) {
    var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
    reIE.test(userAgent);
    var fIEVersion = parseFloat(RegExp["$1"]);
    if (fIEVersion == 7) {
      return "IE7";
    } else if (fIEVersion == 8) {
      return "IE8";
    } else if (fIEVersion == 9) {
      return "IE9";
    } else if (fIEVersion == 10) {
      return "IE10";
    } else if (fIEVersion == 11) {
      return "IE11";
    } else {
      return "0"
    } //IE版本过低
  } else if (isEdge) {
    return "Edge";
  } else {
    return "-1"; //非IE
  }
}

// IE浏览器版本小于IE8给出提示
if(IEVersion() === 'IE7' || IEVersion() === '0') {
  alert('检测到您使用的浏览器版本过低，为了正常使用本站的全部功能，建议您升级IE浏览器或使用360极速浏览器访问本平台。')
}

function refreshCaptcha(){
  $('.rucaptcha-image').attr('src', '/rucaptcha');
}

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

function toggleInputOther(el, value, c_el){
  var hash = {};
  hash[value] = c_el;
  toggleRadioInput(el, hash);
}

function toggleRadioInput(el, hash){
  for(at in hash){
    $(hash[at]).hide();
  }
  var c_el = $(el+':checked').val();
  if(c_el){
    $(hash[c_el]).show();
  }
}

function sumStrings(a,b){
    var res='', c=0;
    a = a.split('');
    b = b.split('');
    while (a.length || b.length || c){
        c += ~~a.pop() + ~~b.pop();
        res = c % 10 + res;
        c = c>9;
    }
    return res.replace(/^0+/,'');
}

$(function(){
  $('.datepicker').datepicker({
    language: 'zh-CN',
    format: 'yyyy-mm-dd',
    showClear: true,
    dayViewHeaderFormat: 'yyyy mm'
  });

  $('.datepicker').each(function(){
    if(this.value.length == 0) return
    var date = moment(this.value, 'YYYY-MM-DD').format('YYYY-MM-DD')
    $(this).val(date)
  });

})
