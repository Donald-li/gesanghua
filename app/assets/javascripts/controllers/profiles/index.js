$(function () {

  //创建、编辑
  $('#save_form_btn').click(function () {

    var btn_name = $("#save_form_btn").text()

    $("#save_form_btn").attr("style", "background:#999").val("操作中...");
    $("#save_form_btn").attr("disabled", "disabled")
    $.ajax({
      type: $("#profile_form").attr("method_way"),
      dataType: "html",
      url: $("#profile_form").attr("action"),
      data: $("#profile_form").serialize(), // serializes the form"s elements.
      success: function (msg) {
        console.log(msg)
        if (JSON.parse(msg).code === 0) {
          window.location.href = "/platform/school/profile/edit"
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



})
