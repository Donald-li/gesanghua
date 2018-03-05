# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 超级管理员
superadmin = User.create(login: 'admin', password: 'admin!', name: 'Administrator', phone: '13300000000', roles: :superadmin, nickname: '超级管理员', kind: :platform_user, phone_verify: :phone_verified)

# 一级财务分类
fc_gesanghua = FundCategory.find_or_create_by(name: '格桑花', describe: '捐助给格桑花', kind: 'nondirectional')
fc_expense = FundCategory.find_or_create_by(name: '办公经费', describe: '办公经费', kind: 'nondirectional')
fc1 = FundCategory.find_or_create_by(name: '一对一', describe: '一对一', kind: 'directional')
fc2 = FundCategory.find_or_create_by(name: '悦读', describe: '悦读', kind: 'directional')
fc3 = FundCategory.find_or_create_by(name: '观影', describe: '观影', kind: 'directional')
fc4 = FundCategory.find_or_create_by(name: '探索营', describe: '探索营', kind: 'directional')
fc5 = FundCategory.find_or_create_by(name: '广播', describe: '广播', kind: 'directional')
fc6 = FundCategory.find_or_create_by(name: '护花', describe: '护花', kind: 'directional')

# 二级财务分类
fc_gesanghua.funds.create(name: "格桑花", management_rate: 0, describe: '格桑花非定向基金池', kind: fc_gesanghua.kind, use_kind: 'unrestricted')
fc_expense.funds.create(name: "行政费用", management_rate: 0, describe: '办公室租用、办公用品', kind: fc_gesanghua.kind, use_kind: 'unrestricted')
fc_expense.funds.create(name: "人员工资", management_rate: 0, describe: '仅用于人员工资、社保费用', kind: fc_gesanghua.kind, use_kind: 'unrestricted')

FundCategory.directional.each do |fc|
  Fund.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'unrestricted')
  Fund.find_or_create_by(name: "指定", management_rate: 5, describe: '定向指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'restricted')
end

# 探索营 - 二级财务分类
fc4.funds.create(name: "苏州营", management_rate: 10, describe: '格桑花苏州营', kind: fc4.kind, use_kind: 'restricted')
fc4.funds.create(name: "常州营", management_rate: 10, describe: '格桑花常州营', kind: fc4.kind, use_kind: 'restricted')
fc4.funds.create(name: "合肥营", management_rate: 10, describe: '格桑花合肥营', kind: fc4.kind, use_kind: 'restricted')

# 项目模板一级分类
content = '用户协议'
Project.find_or_create_by(name: '一对一', alias: 'pair', protocol: content, describe: '项目介绍', kind: :fixed, fund: fc1.funds.unrestricted.first, appoint_fund: fc1.funds.restricted.first)
Project.find_or_create_by(name: '悦读', alias: 'book', protocol: content, describe: '项目介绍', kind: :fixed, fund: fc2.funds.unrestricted.first, appoint_fund: fc2.funds.restricted.first)
Project.find_or_create_by(name: '探索营', alias: 'camp', protocol: content, describe: '项目介绍', kind: :fixed, fund: fc4.funds.unrestricted.first, appoint_fund: fc4.funds.restricted.first)
Project.find_or_create_by(name: '观影', alias: 'movie', protocol: content, describe: '项目介绍', kind: :apply, fund: nil, appoint_fund: nil)
Project.find_or_create_by(name: '护花课程', alias: 'movie_care', protocol: content, describe: '项目介绍', kind: :apply, fund: nil, appoint_fund: nil)
Project.find_or_create_by(name: '广播', alias: 'radio', protocol: content, describe: '项目介绍', kind: :goods, fund: fc5.funds.unrestricted.first, appoint_fund: fc5.funds.restricted.first)
Project.find_or_create_by(name: '护花', alias: 'care', protocol: content, describe: '项目介绍', kind: :goods, fund: fc6.funds.unrestricted.first, appoint_fund: fc6.funds.restricted.first)

# 入账渠道
IncomeSource.find_or_create_by(name: '微信支付', description: '微信支付', kind: 'weixin')
IncomeSource.find_or_create_by(name: '线下汇款', description: '线下汇款', kind: 'offline')

# 捐助项
DonateItem.find_or_create_by(name: '格桑花', describe: '不限制使用途径', fund: Fund.gsh, state: :show)
DonateItem.find_or_create_by(name: '一对一', describe: '用于一对一助学项目', fund: Project.pair_project.fund, state: :show)
DonateItem.find_or_create_by(name: '悦读', describe: '用于图书角建设', fund: Project.book_project.fund, state: :show)
DonateItem.find_or_create_by(name: '探索营', describe: '用于探索营相关项目', fund: Project.camp_project.fund, state: :show)
DonateItem.find_or_create_by(name: '护花', describe: '用于护花包购买', fund: Fund.find(14), state: :show)
DonateItem.find_or_create_by(name: '广播', describe: '用于广播设备购买', fund: Fund.find(12), state: :show)
