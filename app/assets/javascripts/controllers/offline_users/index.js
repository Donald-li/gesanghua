$(function () {

  //编辑弹窗
  $(".index-topbar").delegate(".edit_button", "click", function (e) {
    var $modal = $("#popup-container");
    var url;
    e.preventDefault();
    url = Routes.edit_account_offline_user_path({
      id: $(this).attr("offlineUserId")
    });
    console.log(35)
    return $modal.load(url, function (response, status, xhr) {
       $(".panel-title").text("编辑捐助人信息")
      return $modal.modal({
        keyboard: false,
        backdrop: "static",
        attentionAnimation: false
      });
    });
  });

  //新建弹窗
  $(".index-topbar").delegate("#ClickMe", "click", function (e) {
    var $modal = $("#popup-container");
    var url;
    e.preventDefault();
    url = Routes.new_account_offline_user_path({});
    console.log(35)
    return $modal.load(url, function (response, status, xhr) {
       $(".panel-title").text("新增捐助人信息")
      return $modal.modal({
        keyboard: false,
        backdrop: "static",
        attentionAnimation: false
      });
    });
  });

  //创建、编辑
  $("#popup-container").delegate("#save_form_btn", "click", function (e) {

    var btn_name = $("#save_form_btn").text()

    $("#save_form_btn").attr("style", "background:#999").val("操作中...");
    $("#save_form_btn").attr("disabled", "disabled")
    $.ajax({
      type: $("#offline_user_form").attr("method_way"),
      dataType: "html",
      url: $("#offline_user_form").attr("action"),
      data: $("#offline_user_form").serialize(), // serializes the form"s elements.
      success: function (msg) {
        console.log(msg)
        if (JSON.parse(msg).code === 0) {
          window.location.href = "/account/offline_users"
        } else {
          toastr.error(JSON.parse(msg).msg)
          $("#save_form_btn").removeAttr("style");
          $("#save_form_btn").removeAttr("disabled")
          $("#save_form_btn").val(btn_name);
          return false;
        }
      },
    });

  })

  //
  // //     右tab切换二级
  // $(".donations1 li").on("click", function () {
  //   $(".donations1 li").removeClass("selectedDo")
  //   $(this).addClass("selectedDo")
  //   $(".bottomline").css("left", parseFloat($(this)[0].offsetLeft) +31 +  "px")
  // })
  // if($('.donation .donation-cont').length===0){
  //   $('.donation-cont-no').css('display', 'block')
  //   $('.project-foot').css('display', 'none')
  // }else{
  //   $('.donation-cont-no').css('display', 'none')
  //   $('.project-foot').css('display', 'block')
  // }

  //
  // $('#ClickMe').click(function() {
  //   $('#code').center();
  //   $('#goodcover').show();
  //   $('#code').fadeIn();
  // });
  // $('#closebt').click(function() {
  //   $('#code').hide();
  //   $('#goodcover').hide();
  // });
  // $('.goodbut').click(function() {
  //   $('#code').hide();
  //   $('#goodcover').hide();
  // });
  // $('.delete-offline-user').click(function() {
  //   var id = $(this).attr("offlineUserId");
  //   $('#isDelete').attr("offlineUserId", id);
  //   $('#remove').center();
  //   $('#goodcover').show();
  //   $('#remove').fadeIn();
  // });
  // $('.edit-offline-user').click(function() {
  //   var id = $(this).attr("offlineUserId");
  //   alert(id)
  //   $.ajax({
  //     type: "get",
  //     url: "/account/offline_users",
  //     data: {id: id},
  //     success(){},
  //     error(){}
  //   })
  //   $('#code').center();
  //   $('#goodcover').show();
  //   $('#code').fadeIn();
  // });
  // $('#remove-but').click(function() {
  //   $('#remove').hide();
  //   $('#goodcover').hide();
  // });
  // $('#cancel').click(function() {
  //   $('#isDelete').removeAttr("offlineUserId");
  //   $('#remove').hide();
  //   $('#goodcover').hide();
  // });
  // $('#isDelete').click(function() {
  //   var id = $(this).attr("offlineUserId");
  //   $.ajax({
  //     type: "delete",
  //     url: "offline_users/" + id,
  //     data: {},
  //     success(){},
  //     error(){}
  //   })
  //   $('#isDelete').removeAttr("offlineUserId");
  //   $('#remove').hide();
  //   $('#goodcover').hide();
  //   window.location.reload();
  // });


})
