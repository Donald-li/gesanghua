//点击加减
jQuery.fn.calculate = function() {
    return this.each(function () {
        var $objadd = $(this).find(".oversadd");//加
        var $objmin = $(this).find(".oversmin");//减
        var $objinput = $(this).find(".oversinputs");//input
        $objadd.on("click",function(){
            var num = $objinput.val() ? parseInt($objinput.val()) : 0
            $objinput.val(num+1);
            $objmin.removeAttr("disabled");
        })
        $objmin.on("click",function(){
            var num = $objinput.val() ? parseInt($objinput.val()) : 0

            if (num > 0) {
                $objinput.val(num-1)
            }else{
                $objmin.attr("disabled","disabled")
            }
        })
    });
};
