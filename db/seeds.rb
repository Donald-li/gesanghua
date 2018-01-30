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
content = %{<p>
为构建社会主义和谐社会，弘扬人道主义精神，促进社会主义公益事业发展，支持贫困学生福利事业，甲方自愿向乙方捐赠，并经双方友好协商，就合作内容、甲乙双方权利与义务等事项，达成以下协议。</br>
一、合作内容</br>
  双方本着平等的原则进行合作，甲方在此自愿向乙方捐赠 ，用于帮助乙方学习进步。</br>
二、甲方的权利与义务</br>
  1、甲方应在签约之日起 日内，负责将捐赠资金或捐赠物品移交于乙方。</br>
  2、甲方捐赠如需分期分批完成的，甲方应在其所承诺的每次捐赠移交期限届满前五日内将捐赠资金或捐赠物品移交于乙方。</br>
  3、甲方有权参与乙方开展的与所捐赠项目有关的社会公益活动，并可以对每期社会公益活动进行实地考察与评估。</br>
  4、甲方有权向乙方查询捐赠资金或捐赠物品的使用、管理情况，并可就相关工作的改进完善提出意见和建议。</br>
  5、甲方有权就所捐赠资金或捐赠物品相关企业所得税或个人所得税税额扣除事宜，要求乙方给予有关协助。</br>
  6、甲方因乙方未按照协议约定用途使用捐赠款物的，甲方有权单方终止本协议的执行。</br>
  7、甲方在本合同第一条项下的捐赠义务为不可撤消之义务，甲方应在其承诺的数额及期限内向乙方移交相关捐赠资金或捐赠物品;甲方如无法依约移交捐赠资金或捐赠物品(因不可抗力之原因导致无法履行其移交义务的除外)又不向乙方及时通报无法移交的客观原因的，甲方应承担该捐赠义务20%的违约责任。</br>
三、乙方的权利与义务</br>
  1、乙方应在收到甲方捐赠 后的五日内向甲方颁发捐赠证书，并出具财政部、国家税务总局关于向中国福利基金会，准予在缴纳企业所得税和个人所得税前全额扣除的文件和财政部监制的公益捐赠收据。乙方并应协助甲方办理相关税额抵扣所需事宜。</br>
  2、乙方有权在基金会章程规定的公益事业活动范围内合理使用捐赠的 。</br>
  3、乙方有权确定捐赠项目所需费用的5%-10%为项目配套资金，并有权为项目履行之目的使用该配套资金。</br>
  4、乙方对于甲方就捐赠资金或捐赠物品的使用和管理等方面所提查询，应当给予积极配合，并应及时给予客观全面的说明。</br>
  5、乙方于每期公益活动活动结束后的三十日内向甲方提交该公益捐赠项目的专项报告。</br>
  6、甲方捐赠资金或捐赠物品的接收处理如需有权机关批准方可办理的，乙方应协助甲方向有权机关办理相关捐赠资金或捐赠物品的批准事宜，乙方所承担的协助办理义务以不违反国家强制性法律的禁止性规定为限。</br>
</p>
}
description = "为了使资助者与受助人保持长久的联系，同时保证资助款发挥真正的助学之用，请资助双方认真阅读填写本协议书以作书面凭证。在签定本协议之前，请资助者仔细阅读以下条款，并请严格遵守"
Project.find_or_create_by(name: '结对', protocol: content, describe: description, kind: 'pair', fund: fc1.funds.first)
Project.find_or_create_by(name: '悦读', protocol: content, describe: description, kind: 'book', fund: fc2.funds.first)
Project.find_or_create_by(name: '观影', protocol: content, describe: description, kind: 'movie', fund: fc3.funds.first)
Project.find_or_create_by(name: '探索营', protocol: content, describe: description, kind: 'camp', fund: fc4.funds.first)
Project.find_or_create_by(name: '广播', protocol: content, describe: description, kind: 'radio', fund: fc5.funds.second)
Project.find_or_create_by(name: '护花', protocol: content, describe: description, kind: 'care', fund: fc5.funds.second)
