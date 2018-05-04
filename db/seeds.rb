# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 超级管理员
u = User.find_or_initialize_by(login: 'admin')
u.update(login: 'admin', password: 'admin!', name: 'Administrator', phone: '13300000000', roles: :superadmin, nickname: '超级管理员', kind: :platform_user, phone_verify: :phone_verified)

# 一级财务分类
fc_gesanghua = FundCategory.find_or_create_by(name: '格桑花', describe: '捐助给格桑花', kind: 'nondirectional')
fc_expense = FundCategory.find_or_create_by(name: '办公经费', describe: '办公经费', kind: 'nondirectional')
fc1 = FundCategory.find_or_create_by(name: '结对助学', describe: '结对助学', kind: 'directional')
fc2 = FundCategory.find_or_create_by(name: '悦读', describe: '悦读', kind: 'directional')
fc3 = FundCategory.find_or_create_by(name: '观影', describe: '观影', kind: 'directional')
fc4 = FundCategory.find_or_create_by(name: '探索营', describe: '探索营', kind: 'directional')
fc5 = FundCategory.find_or_create_by(name: '广播', describe: '广播', kind: 'directional')
fc6 = FundCategory.find_or_create_by(name: '护花', describe: '护花', kind: 'directional')
fc7 = FundCategory.find_or_create_by(name: '活动', describe: '活动', kind: 'directional')

# 二级财务分类
fc_gesanghua.funds.find_or_create_by(name: "格桑花", management_rate: 0, describe: '格桑花非定向基金池', kind: fc_gesanghua.kind, use_kind: 'unrestricted')
fc_expense.funds.find_or_create_by(name: "行政费用", management_rate: 0, describe: '办公室租用、办公用品', kind: fc_gesanghua.kind, use_kind: 'unrestricted')
fc_expense.funds.find_or_create_by(name: "人员工资", management_rate: 0, describe: '仅用于人员工资、社保费用', kind: fc_gesanghua.kind, use_kind: 'unrestricted')

FundCategory.directional.each do |fc|
  Fund.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'unrestricted')
  Fund.find_or_create_by(name: "指定", management_rate: 5, describe: '定向指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'restricted')
end

# 探索营 - 二级财务分类
fc4.funds.find_or_create_by(name: "苏州营", management_rate: 10, describe: '格桑花苏州营', kind: fc4.kind, use_kind: 'restricted')
fc4.funds.find_or_create_by(name: "常州营", management_rate: 10, describe: '格桑花常州营', kind: fc4.kind, use_kind: 'restricted')
fc4.funds.find_or_create_by(name: "合肥营", management_rate: 10, describe: '格桑花合肥营', kind: fc4.kind, use_kind: 'restricted')

# 捐助项
di_gsh = DonateItem.find_or_create_by(name: '格桑花', describe: '不限制使用途径', fund: Fund.gsh, state: :show)
di_pair = DonateItem.find_or_create_by(name: '结对助学', describe: '用于结对助学项目', fund: fc1.funds.unrestricted.first, state: :show)
di_read = DonateItem.find_or_create_by(name: '悦读', describe: '用于图书角建设', fund: fc2.funds.unrestricted.first, state: :show)
di_camp = DonateItem.find_or_create_by(name: '探索营', describe: '用于探索营相关项目', fund: fc4.funds.unrestricted.first, state: :show)
di_care = DonateItem.find_or_create_by(name: '护花', describe: '用于护花包购买', fund: fc6.funds.unrestricted.first, state: :show)
di_radio = DonateItem.find_or_create_by(name: '广播', describe: '用于广播设备购买', fund: fc5.funds.unrestricted.first, state: :show)

# 项目模板一级分类
content = '用户协议'

p = Project.find_or_initialize_by(name: '结对助学')
p.update(name: '结对助学', alias: 'pair', protocol: content, describe: '项目介绍', kind: :fixed,
  fund: fc1.funds.unrestricted.first, appoint_fund: fc1.funds.restricted.first, donate_item: di_pair,
  accept_feedback_state: 'close_feedback', apply_kind: 'platform_assign')

p = Project.find_or_initialize_by(name: '悦读')
p.update(name: '悦读', alias: 'read', protocol: content, describe: '项目介绍', kind: :fixed,
  fund: fc2.funds.unrestricted.first, appoint_fund: fc2.funds.restricted.first, donate_item: di_read,
  accept_feedback_state: 'open_feedback', feedback_period: 4, apply_kind: 'user_apply',
  form: [{"key"=>"books_count", "type"=>"number", "label"=>"现有图书", "options"=>["0"], "placeholder"=>"", "required"=>true},
  {"key"=>"suit_count", "type"=>"number", "label"=>"适合阅读", "options"=>["0"], "placeholder"=>"", "required"=>true}]
)

p = Project.find_or_initialize_by(name: '探索营')
p.update(name: '探索营', alias: 'camp', protocol: content, describe: '项目介绍', kind: :fixed,
  fund: fc4.funds.unrestricted.first, appoint_fund: fc4.funds.restricted.first, donate_item: di_camp,
  accept_feedback_state: 'close_feedback', apply_kind: 'platform_assign')

p = Project.find_or_initialize_by(name: '观影')
p.update(name: '观影', alias: 'movie', protocol: content, describe: '项目介绍', kind: :apply,
  fund: nil, appoint_fund: nil, accept_feedback_state: 'open_feedback', feedback_period: 4, apply_kind: 'user_apply', feedback_format: 'complex')

p = Project.find_or_initialize_by(name: '护花课程')
p.update(name: '护花课程', alias: 'movie_care', protocol: content, describe: '项目介绍', kind: :apply,
  fund: nil, appoint_fund: nil, accept_feedback_state: 'open_feedback', feedback_period: 4, apply_kind: 'user_apply', feedback_format: 'complex')

p = Project.find_or_initialize_by(name: '广播')
p.update(name: '广播', alias: 'radio', protocol: content, describe: '项目介绍', kind: :goods,
  fund: fc5.funds.unrestricted.first, appoint_fund: fc5.funds.restricted.first, donate_item: di_radio,
  accept_feedback_state: 'open_feedback', feedback_period: 4, apply_kind: 'user_apply',
  form: [{"key"=>"building_count", "type"=>"number", "label"=>"宿舍栋数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"room_count", "type"=>"number", "label"=>"宿舍数量", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"grade1", "type"=>"number", "label"=>"一年级住宿人数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"grade2", "type"=>"number", "label"=>"二年级住宿人数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"grade3", "type"=>"number", "label"=>"三年级住宿人数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"grade4", "type"=>"number", "label"=>"四年级住宿人数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"grade5", "type"=>"number", "label"=>"五年级住宿人数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"grade6", "type"=>"number", "label"=>"六年级住宿人数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"amp_count", "type"=>"number", "label"=>"现有功放", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"speaker_count", "type"=>"number", "label"=>"现有喇叭", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true}]
  )

p = Project.find_or_initialize_by(name: '护花')
p.update(name: '护花', alias: 'care', protocol: content, describe: '项目介绍', kind: :goods,
  fund: fc6.funds.unrestricted.first, appoint_fund: fc6.funds.restricted.first, donate_item: di_care,
  accept_feedback_state: 'open_feedback', feedback_period: 4, apply_kind: 'user_apply',
  form: [{"key"=>"girls_count", "type"=>"number", "label"=>"女生数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true},
   {"key"=>"boys_count", "type"=>"number", "label"=>"男生数", "options"=>["0", "9999"], "placeholder"=>"", "required"=>true}]
)

# 入账渠道
IncomeSource.find_or_create_by(name: '微信支付', description: '微信支付', kind: 'weixin')
IncomeSource.find_or_create_by(name: '线下汇款', description: '线下汇款', kind: 'offline')

# 默认徽章
BadgeLevel.options_for_select(:kinds).each do |kind|
  BadgeLevel.create( kind: kind.second, title: "#{kind.first}默认徽章", rank: '', value: 0, default_level: true)
end

#关于我们
Page.find_or_create_by(title: '关于我们', alias: 'about-us', content: '关于我们', position: 1)


#捐助协议
Page.find_or_create_by(title: '《格桑花用户捐助协议》', alias: 'donation_protocol', content: '捐助协议', position: 2)
Page.find_or_create_by(title: '《格桑花志愿者申请协议》', alias: 'volunteer_apply_protocol', content: '志愿者申请协议', position: 3)
