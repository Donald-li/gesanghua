
function sendSms(type,mobile){
  if(mobile.length==0){
    alert('请先输入手机号码');
    return false;
  }

  $.ajax({
    url: '/sms_code',
    type: 'POST',
    data: {
      mobile: mobile,
      type: type
    },
    success: function(data){
      setTimeout(function(){
        $('#send_code').html('重新获取');
      }, 180000)
    }
  })
}

function refreshCaptcha(){
  $('.rucaptcha-image').attr('src', '/rucaptcha');
}

function smsTimeout(){
  $('#send_code').attr('disabled', 'disabled');

  intervalid = setInterval("timer()", 1000);
}

function timer(){
  var s = parseInt($('#timeout').html());
  if(s == 0){
    $('#send_code').removeAttr('disabled');
    clearInterval(intervalid);
    $('#send_code').html('获取验证码');
    return;
  }
  s--;
  $('#timeout').html(s);
}
