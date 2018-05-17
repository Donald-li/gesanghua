$(function(){
    //判断浏览器
    if (window.ActiveXObject || "ActiveXObject" in window) {
        $('.read-more').css({"white-space": "nowrap"})
        $('#owl-article .owl-item .item .gsh-cont-2').css({"white-space": "nowrap"})
        $('.redundance').css({"white-space": "nowrap"})
        $('.project-cont-con').css({"white-space": "nowrap"})
        $('.recommend-cont .gsh-cont-2').css({"white-space": "nowrap"})
        $('.camps-body-conts .camps-cont-1').css({"white-space": "nowrap"})
        $('.pairs-body-conts .pairs-body-c-p').css({"white-space": "nowrap"})
        $('.gsh-cont-3').css({"white-space": "nowrap"})
        $('.detail-con-font').css({"white-space": "nowrap"})
        $('.speciais .speciais-con .speciais-con-con .gsh-cont-3').css({"white-space": "nowrap"})
        $('.items-container .item .gsh-cont-2').css({"white-space": "nowrap"})
        $('.speciais .speciais-right .speciais-con-con .gsh-cont-2').css({"white-space": "nowrap"})
        $('.speciais .speciais-con .speciais-con-con .gsh-cont-2').css({"white-space": "nowrap"})
        $('.speciais-right .speciais-right-pos .speciais-con-con > div').css({"height": "38px"})
    }
    if (navigator.userAgent.indexOf('Firefox') >= 0) {
        $('.read-more').css({"white-space": "nowrap","display":"block"})
        $('#owl-article .owl-item .item .gsh-cont-2').css({"white-space": "nowrap","display":"block"})
        $('.redundance').css({"white-space": "nowrap","display":"block"})
        $('.project-cont-con').css({"white-space": "nowrap","display":"block"})
        $('.recommend-cont .gsh-cont-2').css({"white-space": "nowrap","display":"block"})
        $('.camps-body-conts .camps-cont-1').css({"white-space": "nowrap","height":"30px","display":"block"})
        $('.pairs-body-conts .pairs-body-c-p').css({"white-space": "nowrap","display":"block"})
        $('.gsh-cont-3').css({"white-space": "nowrap","display":"block"})
        $('.detail-con-font').css({"white-space": "nowrap","display":"block"})
        $('.speciais .speciais-con .speciais-con-con .gsh-cont-3').css({"white-space": "nowrap","display":"block"})
        $('.items-container .item .gsh-cont-2').css({"white-space": "nowrap","display":"block"})
        $('.speciais .speciais-right .speciais-con-con .gsh-cont-2').css({"white-space": "nowrap","display":"block"})
        $('.speciais .speciais-con .speciais-con-con .gsh-cont-2').css({"white-space": "nowrap","display":"block"})
        $('.speciais-right .speciais-right-pos .speciais-con-con > div').css({"height": "38px"})

}
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1; //判断是否IE<11浏览器
    if (isIE) {
        var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
        reIE.test(userAgent);
        var fIEVersion = parseFloat(RegExp["$1"]);
        if (fIEVersion < 9) {
            window.location = '/information'
        }


    }

})
