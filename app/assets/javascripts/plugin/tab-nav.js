
jQuery.fn.myTab = function () {
    return this.each(function () {
        var $navLis = $(this).find(".nav >li");//获取导航菜单的li数组
        var $conLis = $(this).find(".detail-body>.contentab");
        $navLis.eq(0).addClass("active");
        $conLis.css('display', 'none');
        $conLis.eq(0).css('display', 'block');

        $navLis.on('click', function () {
            $navLis.removeClass('selectedNav');
            $(this).addClass('selectedNav');
            $(".bottomLine").css("left", parseFloat($(this)[0].offsetLeft) + "px")
            var ind = $(this).index();
            $conLis.css('display', 'none');
            $conLis.eq(ind).css('display', 'block');
        });
    });
};

