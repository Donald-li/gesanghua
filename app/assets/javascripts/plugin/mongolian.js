
jQuery.fn.overs = function() {
    return this.each(function () {
        var $objcont = $(this).find(".overspread-cont");//内容
        var $objbut = $(this).find(".overspread-but");//关闭按钮
        var $objshow = $(".overspread-show");//点击触发事件
        var $objover = $(this).find(".overspread-over");//蒙层
        $objshow.on("click",function(){
            $objover.show()
            $objcont.center()
            $objcont.fadeIn()

        })
        $objbut.on("click",function(){
            $objover.hide()
            $objcont.hide()
        })
    });
};
