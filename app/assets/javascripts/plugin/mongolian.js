jQuery.fn.overs = function(obj) {
    var obj = obj
    return this.each(function () {
        var $objcont = $(this).find(".overspread-cont");//内容
        var $objbut = $(this).find(".overspread-but");//关闭按钮
        var $objshow = $(obj);//点击触发事件
        var $objover = $(this).find(".overspread-over");//蒙层
        $objshow.on("click",function(){
            $objover.show()
            $objcont.fadeIn()

        })
        $objbut.on("click",function(){
            $objover.hide()
            $objcont.hide()
        })
    });
};
jQuery.fn.overbooleans = function(Booleans) {
    var show = false
    return this.each(function () {
        var $objcont = $(this).find(".overspread-cont");//内容
        var $objover = $(this).find(".overspread-over");//蒙层
        if(Booleans = true){
            $objover.show()
            $objcont.fadeIn()
        }else if( Booleans = false){
            $objover.hide()
            $objcont.hide()
        }
    });
};
