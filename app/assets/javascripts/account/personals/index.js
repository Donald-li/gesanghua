$(function () {

  //新建弹窗
  $("#account").delegate(".binding-phone", "click", function (e) {
    var $modal = $("#popup-container");
    var url;
    url = Routes.new_binding_account_personals_path();
    e.preventDefault();
    return $modal.load(url, function () {
      $(".panel-title").text("绑定手机号")
      return $modal.modal({
        keyboard: false,
        backdrop: "static",
        attentionAnimation: false
      });
    });
  });


  //创建、编辑仓库
  $("#popup-container1111111").delegate("#save_form_btn", "click", function (e) {
    // var action_name = $("#action_name").val()
    // var name        = $("#storage_name").val()
    // var team_id     = $("#hidden_team_id").val()
    // var desc        = $("#storage_desc").val()
    //
    // if (!$.trim(name)) {
    //   toastr.error("仓库名称不能为空")
    //   return false;
    // }else if (name.length >= 20){
    //   toastr.error("仓库名称请输入20个字符之内")
    //   return false;
    // }
    // if (!$.trim(team_id)) {
    //   toastr.error("所属部门不能为空")
    //   return false;
    // }
    // if (!!$.trim(desc) && desc.length >= 100) {
    //   toastr.error("描述请输入100个字符之内")
    //   return false;
    // }
    //
    // $("#save_form_btn").attr("style", "background:#999").val("操作中...");
    // $("#save_form_btn").attr("disabled", "disabled")
    $.ajax({
      type: $("#storage_form").attr("method"),
      dataType: "html",
      url: $("#storage_form").attr("action"),
      data: $("#storage_form").serialize(), // serializes the form"s elements.
      success: function (msg) {
        if (JSON.parse(msg).code === 0) {
          //创建或者是编辑
          if (action_name === "new") {
            window.location.href = "/storages/"
          } else {
            window.location.href = "/storages/" + $("#storage_id").val()
          }
        } else {
          toastr.error(JSON.parse(msg).msg)
          $("#save_form_btn").removeAttr("style");
          $("#save_form_btn").removeAttr("disabled")
          $("#save_form_btn").val("确定");
          return false;
        }
      },
    });

  })

})
