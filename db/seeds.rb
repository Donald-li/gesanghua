# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 超级管理员
admin = User.new(login: 'admin', password: 'admin!', name: 'Administrator', phone: '18888888888')
admin.build_administrator(nickname: '超级管理员', kind: 1)
admin.save

# 财务分类 - 非定向
fc_gesanghua = FundCategory.find_or_create_by(name: '格桑花', describe: '捐助给格桑花', kind: 'nondirectional')
fc_expense = FundCategory.find_or_create_by(name: '办公经费', describe: '办公经费', kind: 'nondirectional')

# 非定向 - 基金池
fc_gesanghua.funds.create(name: "格桑花", management_rate: 0, describe: '格桑花非定向基金池', kind: fc_gesanghua.kind, use_kind: 'unrestricted')
fc_expense.funds.create(name: "行政费用", management_rate: 0, describe: '办公室租用、办公用品', kind: fc_gesanghua.kind, use_kind: 'unrestricted')
fc_expense.funds.create(name: "人员工资", management_rate: 0, describe: '仅用于人员工资、社保费用', kind: fc_gesanghua.kind, use_kind: 'unrestricted')

# 基金类型
fc1 = FundCategory.find_or_create_by(name: '结对', describe: '结对', kind: 'directional')
fc2 = FundCategory.find_or_create_by(name: '悦读', describe: '悦读', kind: 'directional')
fc3 = FundCategory.find_or_create_by(name: '观影', describe: '观影', kind: 'directional')
fc4 = FundCategory.find_or_create_by(name: '探索营', describe: '探索营', kind: 'directional')
fc5 = FundCategory.find_or_create_by(name: '广播', describe: '广播', kind: 'directional')
fc6 = FundCategory.find_or_create_by(name: '护花', describe: '护花', kind: 'directional')
FundCategory.directional.each do |fc|
  Fund.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'unrestricted')
  Fund.find_or_create_by(name: "指定", management_rate: 5, describe: '定向指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'restricted')
end

# 定向 - 营基金池
fc4.funds.create(name: "苏州营", management_rate: 10, describe: '格桑花苏州营', kind: fc4.kind, use_kind: 'restricted')
fc4.funds.create(name: "常州营", management_rate: 10, describe: '格桑花常州营', kind: fc4.kind, use_kind: 'restricted')
fc4.funds.create(name: "合肥营", management_rate: 10, describe: '格桑花合肥营', kind: fc4.kind, use_kind: 'restricted')

# 项目模板一级分类
content = '用户协议'
Project.find_or_create_by(name: '结对', protocol: content, describe: '项目介绍', kind: 'pair', fund: fc1.funds.unrestricted.first, appoint_fund: fc1.funds.restricted.first)
Project.find_or_create_by(name: '悦读', protocol: content, describe: '项目介绍', kind: 'book', fund: fc2.funds.unrestricted.first, appoint_fund: fc2.funds.restricted.first)
Project.find_or_create_by(name: '悦读补书', protocol: content, describe: '项目介绍', kind: 'book', fund: fc2.funds.unrestricted.first, appoint_fund: fc2.funds.restricted.first)
Project.find_or_create_by(name: '观影', protocol: content, describe: '项目介绍', kind: 'movie', fund: fc3.funds.unrestricted.first, appoint_fund: fc3.funds.restricted.first)
Project.find_or_create_by(name: '护花课程', protocol: content, describe: '项目介绍', kind: 'movie', fund: fc3.funds.unrestricted.first, appoint_fund: fc3.funds.restricted.first)
Project.find_or_create_by(name: '探索营', protocol: content, describe: '项目介绍', kind: 'camp', fund: fc4.funds.unrestricted.first, appoint_fund: fc4.funds.restricted.first)
Project.find_or_create_by(name: '广播', protocol: content, describe: '项目介绍', kind: 'radio', fund: fc5.funds.unrestricted.second, appoint_fund: fc5.funds.restricted.first)
Project.find_or_create_by(name: '护花', protocol: content, describe: '项目介绍', kind: 'care', fund: fc5.funds.unrestricted.second, appoint_fund: fc6.funds.restricted.first)
