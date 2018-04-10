
jQuery.fn.calculate = function() {
    return this.each(function () {
        var $objadd = $(this).find(".oversadd");//加
        var $objmin = $(this).find(".oversmin");//减
        var $objinput = $(this).find(".oversinputs");//input
        $objadd.on("click",function(){
            $objinput.val(parseInt(t.val())+1);
            $objmin.removeAttr("disabled");
        })
        $objmin.on("click",function(){
            if (parseInt($objinput.val())>1) {
                $objinput.val(parseInt(t.val())-1)
            }else{
                $objmin.attr("disabled","disabled")
            }
        })
    });
};
