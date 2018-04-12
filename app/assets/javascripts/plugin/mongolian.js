jQuery.fn.overs = function(obj) {
    var obj = obj
    return this.each(function () {
        var $objcont = $(this).find(".overspread-cont");//内容
        var $objbut = $(this).find(".overspread-but");//关闭按钮
        var $objshow = $(obj);//点击触发事件
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
//下拉多选
jQuery.fn.dropDwon = function(option){
    function drop(def) {
        this.name = def.id;
        this.init();
    };
    drop.prototype = {
        init: function () {
            this.list();
            this.myClick();
        },
        //添加下拉框到页面中
        list: function () {
            var id = '#' + this.name;
            var header = '<div class="drop-header" type="' + def.type + '"></div>';
            //默认下拉框选项
            $(id).append(header);
            if (def.type == 'single') {
                for (var key in def.myData) {
                    if (def.myData[key].selected == true) {
                        var headerTxt = def.myData[key].val;
                        $(id).find('.drop-header').text(headerTxt)
                    }
                    ;
                }
                ;
            }
            ;
            var newPo = $(id).offset();
            var newW = parseInt($(id).css('width'));
            var newH = parseInt($(id).css('height'));
            $('.drop-dwon').css({
                width: newW + 'px',
                top: newPo.top + newH + 'px',
                left: newPo.left + 'px'
            });
        },
        //下拉框点击事件
        myClick: function () {
            var self = this;
            var name = this.name;
            var id = '#' + this.name;
            $(id).click(function (e) {
                e.stopPropagation();
                $('.drop-dwon').remove();
                var _this = $(this);
                var lists, drop;
                lists = '';
                for (var key in def.myData) {
                    lists += '<li value="' + key + '" sel="">' + def.myData[key].val + '</li>';
                }
                ;
                var drop = '<ul class="drop-dwon" id="' + name + 'con">' + lists + '</ul>';
                $('body').append(drop);
                self.position('.drop-dwon');
                //改变屏幕宽度的时候，重新计算下拉框内容的位置
                window.onresize = function () {
                    self.position('.drop-dwon');
                };
                if (def.type == 'sigle') {
                    self.sinClick();
                } else if (def.type == 'multi') {
                    self.mltClick();
                }
            });
        },
        //计算下拉框内容的位置
        position: function (obj) {
            var id = '#' + this.name;
            var myPo = $(id).offset();
            var myW = parseInt($(id).css('width'));
            var myH = parseInt($(id).css('height')) - 1;
            $(obj).css({
                top: myPo.top + myH + 'px',
                left: myPo.left + 'px',
                width: myW + 'px',
            });
        },
        sinClick: function () {
            var name = this.name;
            var id = '#' + name + 'con';
            $(id).on('click', 'li', function (e) {
                e.stopPropagation();
                $('#' + name).find('.drop-header').text($(this).text())
                $(id).remove();
            });
            $(document).click(function () {
                $(id).remove();
            });
        },
        mltClick: function () {
            var self = this;
            var name = this.name;
            var id = '#' + name + 'con';
            var header = $('#' + name).find('.drop-header');
            $(id).on('click', 'li', function (e) {
                e.stopPropagation();
                var sel = $(this).attr('sel');
                if (sel == 'true') {
                    $(this).removeClass('active');
                    $(this).attr('sel', false);
                    var rem = $(this).attr('value');
                    header.find('span').each(function () {
                        if ($(this).attr('vel') == rem) {
                            $(this).remove();
                        }
                        ;
                    });
                } else {
                    $(this).addClass('active');
                    $(this).attr('sel', true);
                    var txt = '<span vel="' + $(this).attr('value') + '">' + $(this).text() + '<i class="iconfont icon-ico-delete"></i>' + '</span>';
                    header.append(txt);
                };
                self.position('.drop-dwon');
                self.mtlRemove();
            });
            $(document).click(function () {
                $(id).remove();
            });
        },
        mtlRemove: function () {
            var self = this;
            var name = this.name;
            var id = '#' + name;
            $(id + ' ' + 'span').click(function (e) {
                e.stopPropagation();
                var _this = $(this);
                var vle = _this.attr('vel');
                _this.remove();
                $(id + 'con li').each(function () {
                    var vleLi = $(this).attr('value');
                    if (vleLi == vle) {
                        $(this).removeClass('active');
                        $(this).attr('sel', false);
                    }
                    ;
                });
                self.position('.drop-dwon');
            });
        },
    };
    var def = {
        type: 'multi', //multi:多选；sigle：单选
        myData: {
            name1: {
                val: '默认选中',
                selected: true,
            },
            name2: {
                val: '下拉1',
            },
            name3: {
                val: '下拉2'
            },
            name4: {
                val: '下拉3'
            },
        },
    };
    def = $.extend(def, option);
    new drop(def);
}