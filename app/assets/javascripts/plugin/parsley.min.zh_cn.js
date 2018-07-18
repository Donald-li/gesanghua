// Validation errors messages for Parsley
// Load this after Parsley

Parsley.addMessages('zh-cn', {
  defaultMessage: '<i class="fa fa-close"></i>' + " 不正确的值",
  type: {
    email:        '<i class="fa fa-close"></i>' + " 请输入一个有效的电子邮箱地址",
    url:          '<i class="fa fa-close"></i>' + " 请输入一个有效的链接",
    number:       '<i class="fa fa-close"></i>' + " 请输入正确的数字",
    integer:      '<i class="fa fa-close"></i>' + " 请输入正确的整数",
    digits:       '<i class="fa fa-close"></i>' + " 请输入正确的号码",
    alphanum:     '<i class="fa fa-close"></i>' + " 请输入字母或数字"
  },
  notblank:       '<i class="fa fa-close"></i>' + " 请输入值",
  required:       '<i class="fa fa-close"></i>' + " 必填项",
  pattern:        '<i class="fa fa-close"></i>' + " 格式不正确",
  min:            '<i class="fa fa-close"></i>' + " 输入值请大于或等于 %s",
  max:            '<i class="fa fa-close"></i>' + " 输入值请小于或等于 %s",u
  range:          '<i class="fa fa-close"></i>' + " 输入值应该在 %s 到 %s 之间",
  minlength:      '<i class="fa fa-close"></i>' + " 请输入至少 %s 个字符",
  maxlength:      '<i class="fa fa-close"></i>' + " 请输入至多 %s 个字符",
  length:         '<i class="fa fa-close"></i>' + " 字符长度应该在 %s 到 %s 之间",
  mincheck:       '<i class="fa fa-close"></i>' + " 请至少选择 %s 个选项",
  maxcheck:       '<i class="fa fa-close"></i>' + " 请选择不超过 %s 个选项",
  check:          '<i class="fa fa-close"></i>' + " 请选择 %s 到 %s 个选项",
  equalto:        '<i class="fa fa-close"></i>' + " 输入值不同"
});

Parsley.setLocale('zh-cn');

Parsley.options.excluded = 'input[type=button], input[type=submit], input[type=reset], input[type=hidden], :hidden'
