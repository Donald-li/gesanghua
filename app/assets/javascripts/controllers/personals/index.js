$(function () {

  //绑定手机号弹窗
  $('#ClickMe').click(function() {
    $('#code').center();
    $('#goodcover').show();
    $('#code').fadeIn();
  });
  $('#closebt').click(function () {
    $('#code').hide();
    $('#goodcover').hide();
  });
  $('.cancel-btn').click(function () {
    $('#code').hide();
    $('#goodcover').hide();
  });
  $('.save-btn').click(function () {
    $('#code').hide();
    $('#goodcover').hide();
  });

  //手机验证码
  var wait = 59;
  function time(o) {
    if (wait == 0) {
      o.removeAttribute("disabled");
      o.value = "获取验证码";
      wait = 59;
    } else { // www.jbxue.com
      o.setAttribute("disabled", true);
      o.value = wait + "秒";
      wait--;
      setTimeout(function () {
          time(o)
        },
        1000)
    }
  }
  document.getElementById("code_btn").onclick = function () {
    time(this);
    var mobile = $('#phonenumber').val()
    $.ajax({
      type: "post",
      url: "/api/v1/common/sms_codes",
      data: {kind: 'signup', mobile: mobile},
      success(data){
        alert(data.message)
      },
      error(){
      }
    })
  }
  $(".check_label").checkbox();
  <!--  $("canvas.flare").let_it_snow({-->
  <!--    windPower: 0,-->
  <!--    speed: 0,-->
  <!--    size: 110,-->
  <!--    count: 50,-->
  <!--    opacity: 0.1,-->
  <!--    interaction: false,-->
  <!--    image: '<%#= image_path('circle.png')%>'-->
  <!--  });-->

  $(function () {
    setHeight();
  });
  $(window).resize(function () {
    setHeight();
  });
  function setHeight() {
    var windowHeight = $(window).height();
    $('#first-screen').css('height', windowHeight + 'px');
  }

})
