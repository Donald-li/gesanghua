$(function () {

  //     右tab切换二级
  $(".donations1 li").on("click", function () {
    $(".donations1 li").removeClass("selectedDo")
    $(this).addClass("selectedDo")
    $(".bottomline").css("left", parseFloat($(this)[0].offsetLeft) + 31 + "px")

  })
  if ($('.donation .donation-cont').length === 0) {
    $('.donation-cont-no').css('display', 'block')
    $('.project-foot').css('display', 'none')
  } else {
    $('.donation-cont-no').css('display', 'none')
    $('.project-foot').css('display', 'block')
  }

  // document.getElementById("code_btn").onclick = function () {
  //   time(this);
  //   var mobile = $('#phonenumber').val()
  //   $.ajax({
  //     type: "post",
  //     url: "/api/v1/common/sms_codes",
  //     data: {kind: 'signup', mobile: mobile},
  //     success(data){
  //       alert(data.message)
  //     },
  //     error(){
  //     }
  //   })
  // }

})
