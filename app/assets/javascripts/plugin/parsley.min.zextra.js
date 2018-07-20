// gt, gte, lt, lte, notequalto extra validators
var parseRequirement = function (requirement) {
  if (isNaN(+requirement))
    return parseFloat(jQuery(requirement).val());
  else
    return +requirement;
};

// Greater than validator
window.Parsley.addValidator('gt', {
  validateString: function (value, requirement) {
    return parseFloat(value) > parseRequirement(requirement);
  },
  messages: {
    'zh-cn': '请输入大于 %s 的值'
  },
  priority: 32
});

// Greater than or equal to validator
window.Parsley.addValidator('gte', {
  validateString: function (value, requirement) {
    return parseFloat(value) >= parseRequirement(requirement);
  },
  messages: {
    'zh-cn': '请输入大于等于 %s 的值'
  },
  priority: 32
});

// Less than validator
window.Parsley.addValidator('lt', {
  validateString: function (value, requirement) {
    return parseFloat(value) < parseRequirement(requirement);
  },
  messages: {
    'zh-cn': '请输入小于 %s 的值'
  },
  priority: 32
});

// Less than or equal to validator
window.Parsley.addValidator('lte', {
  validateString: function (value, requirement) {
    return parseFloat(value) <= parseRequirement(requirement);
  },
  messages: {
    'zh-cn': '请输入小于等于 %s 的值'
  },
  priority: 32
});

//手机号码
window.Parsley.addValidator('mobile', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^1\d{10}$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的手机号码'
  },
  priority: 32
});

//座机
window.Parsley.addValidator('telephone', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^(0[0-9]{2,3}\-?)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的座机号码'
  },
  priority: 32
});
//手机或座机
window.Parsley.addValidator('phone', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^(\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的手机号码'
  },
  priority: 32
});

//身份证号
window.Parsley.addValidator('shenfen', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return getIdCardInfo(value).isTrue;
  },
  messages: {
    'zh-cn': '请输入正确的身份证号码'
  },
  priority: 32
});


//护照
window.Parsley.addValidator('huzhao', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^[a-zA-Z0-9]{5,21}$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的护照号码'
  },
  priority: 32
});

//回乡
window.Parsley.addValidator('huixiang', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^[a-zA-Z0-9]{5,21}$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的回乡证号码'
  },
  priority: 32
});

//姓名 data-parsley-name: true
window.Parsley.addValidator('name', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^(.{2,10})$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的姓名'
  },
  priority: 32
});

//邮编
window.Parsley.addValidator('zipcode', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^(\d+){6}$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的邮编'
  },
  priority: 32
});

//QQ号码
window.Parsley.addValidator('qq', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^\d{5,20}$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的QQ号码'
  },
  priority: 32
});

//组织机构代码证
window.Parsley.addValidator('org-card-no', {
  requirementType: 'string',
  validateString: function (value, requirement) {
    return /^[xX\-\d]{8,10}$/i.test(value);
    return /^(.{2,10})$/i.test(value);
  },
  messages: {
    'zh-cn': '请输入正确的组织机构代码证号码'
  },
  priority: 32
});

/**
 * 身份证号码验证
 *
 * @param cardNo
 *            {String} 证件号码
 * @returns info {Object} 身份证信息.
 *
 */
function getIdCardInfo(cardNo) {
  var info = {
		isTrue : false, // 身份证号是否有效。默认为 false
		year : null,// 出生年。默认为null
		month : null,// 出生月。默认为null
		day : null,// 出生日。默认为null
		isMale : false,// 是否为男性。默认false
		isFemale : false // 是否为女性。默认false
	};

	if (!cardNo || (15 != cardNo.length && 18 != cardNo.length) ) {
		info.isTrue = false;
		return info;
	}

	if (15 == cardNo.length) {
		var year = cardNo.substring(6, 8);
		var month = cardNo.substring(8, 10);
		var day = cardNo.substring(10, 12);
		var p = cardNo.substring(14, 15); // 性别位
		var birthday = new Date(year, parseFloat(month) - 1, parseFloat(day));
		// 对于老身份证中的年龄则不需考虑千年虫问题而使用getYear()方法
		if (birthday.getYear() != parseFloat(year)
				|| birthday.getMonth() != parseFloat(month) - 1
				|| birthday.getDate() != parseFloat(day)) {
			info.isTrue = false;
		} else {
			info.isTrue = true;
			info.year = birthday.getFullYear();
			info.month = birthday.getMonth() + 1;
			info.day = birthday.getDate();
			if (p % 2 == 0) {
				info.isFemale = true;
				info.isMale = false;
			} else {
				info.isFemale = false;
				info.isMale = true;
			}
		}
		return info;
	}

	if (18 == cardNo.length) {
		var year = cardNo.substring(6, 10);
		var month = cardNo.substring(10, 12);
		var day = cardNo.substring(12, 14);
		var p = cardNo.substring(14, 17);
		var birthday = new Date(year, parseFloat(month) - 1, parseFloat(day));
		// 这里用getFullYear()获取年份，避免千年虫问题
		if (birthday.getFullYear() != parseFloat(year)
				|| birthday.getMonth() != parseFloat(month) - 1
				|| birthday.getDate() != parseFloat(day)) {
			info.isTrue = false;
			return info;
		}

		var Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 ];// 加权因子
		var Y = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ];// 身份证验证位值.10代表X

		// 验证校验位
		var sum = 0; // 声明加权求和变量
		var _cardNo = cardNo.split("");

		if (_cardNo[17].toLowerCase() == 'x') {
			_cardNo[17] = 10;// 将最后位为x的验证码替换为10方便后续操作
		}
		for ( var i = 0; i < 17; i++) {
			sum += Wi[i] * _cardNo[i];// 加权求和
		}
		var i = sum % 11;// 得到验证码所位置

		if (_cardNo[17] != Y[i]) {
			return info.isTrue = false;
		}

		info.isTrue = true;
		info.year = birthday.getFullYear();
		info.month = birthday.getMonth() + 1;
		info.day = birthday.getDate();

		if (p % 2 == 0) {
			info.isFemale = true;
			info.isMale = false;
		} else {
			info.isFemale = false;
			info.isMale = true;
		}
		return info;
	}
	return info;
}
