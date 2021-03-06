namespace :demo do
  task init: [:environment] do
    # 财务分类 - 非定向
    fc_gesanghua = FundCategory.find_or_create_by(name: '格桑花', describe: '捐助给格桑花')
    fc_expense = FundCategory.find_or_create_by(name: '办公经费', describe: '办公经费')

    # 非定向 - 基金池
    fc_gesanghua.funds.create(name: "格桑花", management_rate: 0, describe: '格桑花非定向基金池')
    fc_expense.funds.create(name: "行政费用", management_rate: 0, describe: '办公室租用、办公用品')
    fc_expense.funds.create(name: "人员工资", management_rate: 0, describe: '仅用于人员工资、社保费用')

    # 基金类型
    fc1 = FundCategory.find_or_create_by(name: '一对一', describe: '一对一')
    fc2 = FundCategory.find_or_create_by(name: '悦读', describe: '悦读')
    fc3 = FundCategory.find_or_create_by(name: '观影', describe: '观影')
    fc4 = FundCategory.find_or_create_by(name: '探索营', describe: '探索营')
    fc5 = FundCategory.find_or_create_by(name: '广播', describe: '广播')
    fc6 = FundCategory.find_or_create_by(name: '护花', describe: '护花')
    FundCategory.each do |fc|
      Fund.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id)
      Fund.find_or_create_by(name: "指定", management_rate: 5, describe: '定向指定', fund_category_id: fc.id)
    end

    # 定向 - 营基金池
    fc4.funds.create(name: "苏州营", management_rate: 10, describe: '格桑花苏州营')
    fc4.funds.create(name: "常州营", management_rate: 10, describe: '格桑花常州营')
    fc4.funds.create(name: "合肥营", management_rate: 10, describe: '格桑花合肥营')

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
    Project.find_or_create_by(name: '一对一', protocol: content, describe: description, kind: 1, fund: fc1.funds.first)
    Project.find_or_create_by(name: '悦读', protocol: content, describe: description, kind: 1, fund: fc2.funds.first)
    Project.find_or_create_by(name: '观影', protocol: content, describe: description, kind: 1, fund: fc3.funds.first)
    Project.find_or_create_by(name: '探索营', protocol: content, describe: description, kind: 1, fund: fc4.funds.first)
    Project.find_or_create_by(name: '广播', protocol: content, describe: description, kind: 2, fund: fc5.funds.second)
    Project.find_or_create_by(name: '护花', protocol: content, describe: description, kind: 2, fund: fc5.funds.second)
  end

  task user_donate: :environment do
    # 新增用户
    user1 = User.last
    donate_record1 = user1.donate_records.build(donor: '刘阿四', remitter_name: '阿四', amount: '8.88', pay_state: 2, project_id: 1)
    donate_record2 = user1.donate_records.build(donor: '阮小五', remitter_name: '小五', amount: '9.99', pay_state: 2, project_id: 1)
    donate_record1.save(validate: false)
    donate_record2.save(validate: false)
  end

  task local: [:environment] do
    # 财务分类 - 非定向
    fc_gesanghua = FundCategory.find_or_create_by(name: '格桑花', describe: '捐助给格桑花')
    fc_expense = FundCategory.find_or_create_by(name: '办公经费', describe: '办公经费')

    # 非定向 - 基金池
    fc_gesanghua.funds.create(name: "格桑花", management_rate: 0, describe: '格桑花非定向基金池')
    fc_expense.funds.create(name: "行政费用", management_rate: 0, describe: '办公室租用、办公用品')
    fc_expense.funds.create(name: "人员工资", management_rate: 0, describe: '仅用于人员工资、社保费用')

    # 基金类型
    fc1 = FundCategory.find_or_create_by(name: '一对一', describe: '一对一')
    fc2 = FundCategory.find_or_create_by(name: '悦读', describe: '悦读')
    fc3 = FundCategory.find_or_create_by(name: '观影', describe: '观影')
    fc4 = FundCategory.find_or_create_by(name: '探索营', describe: '探索营')
    fc5 = FundCategory.find_or_create_by(name: '广播', describe: '广播')
    fc6 = FundCategory.find_or_create_by(name: '护花', describe: '护花')
    FundCategory.each do |fc|
      Fund.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id)
      Fund.find_or_create_by(name: "指定", management_rate: 5, describe: '定向指定', fund_category_id: fc.id)
    end

    # 定向 - 营基金池
    fc4.funds.create(name: "苏州营", management_rate: 10, describe: '格桑花苏州营')
    fc4.funds.create(name: "常州营", management_rate: 10, describe: '格桑花常州营')
    fc4.funds.create(name: "合肥营", management_rate: 10, describe: '格桑花合肥营')

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
    Project.find_or_create_by(name: '一对一', protocol: content, describe: description, kind: 1, fund: fc1.funds.first)
    Project.find_or_create_by(name: '悦读', protocol: content, describe: description, kind: 1, fund: fc2.funds.first)
    Project.find_or_create_by(name: '观影', protocol: content, describe: description, kind: 1, fund: fc3.funds.first)
    Project.find_or_create_by(name: '探索营', protocol: content, describe: description, kind: 1, fund: fc4.funds.first)
    Project.find_or_create_by(name: '广播', protocol: content, describe: description, kind: 2, fund: fc5.funds.second)
    Project.find_or_create_by(name: '护花', protocol: content, describe: description, kind: 2, fund: fc5.funds.second)

    # 生成一对一项目可用年度
    ProjectSeason.find_or_create_by(name: '2017年一对一一对一助学项目', junior_term_amount: 1200, junior_year_amount: 2400, senior_term_amount: 2000, senior_year_amount: 4000, project: Project.first)
    # 生成学校
    School.find_or_create_by(name: '西宁第一实验中学', address: '某街', approve_state: 2, province: '630000', city: '630100', district: '630101', number: '600', describe: '优秀中学', level: 1, contact_name: '陈俊生', contact_phone: '17866548888', user: User.last)
    # 生成申请
    ProjectSeasonApply.find_or_create_by(name: '2017年西宁第一实验中学-一对一一对一助学项目', number: 10, project_id: Project.first.id, project_season_id: ProjectSeason.first.id, school_id: School.first.id, describe: '品学兼优，家境贫寒', province: '630000', city: '630100', district: '630101', state: 1)
    # 生成格桑花孩子
    10.times do
      gc = GshChild.find_or_create_by(school_id: School.first.id, name: Faker::Name.name, phone: '1866965' + rand(1000..9999).to_s, province: '630000', city: '630100', district: '630101')
      ProjectSeasonApplyChild.find_or_create_by(project_id: Project.first.id, project_season_id: ProjectSeason.first.id, project_season_apply_id: ProjectSeasonApply.first.id, gsh_child_id: gc.id, school_id: School.first.id, name: gc.name, phone: gc.phone, id_card: '37130219980723' + rand(1997..9999).to_s, province: '630000', city: '630100', district: '630101')
    end
    # 生成志愿者和任务
    v = Volunteer.find_or_create_by(level: 0, duration: 200, user_id: User.first.id, approve_state: 2)
    5.times do
      t = Task.find_or_create_by(name: Faker::Name.name, duration: 15, content: '做任务', num: 6, state: rand(2..5), province: '630000', city: '630100', district: '630101', start_time: Time.now - 10.days, end_time: Time.now + 20.days)
      t.task_volunteers.find_or_create_by(volunteer_id: v.id)
    end

    # 生成统计数据
    time = Time.now - 56.day
    55.times do
      StatisticRecord.create(amount: rand(10...100), kind: 1, record_time: time.strftime("%Y-%m-%d"))
      StatisticRecord.create(amount: rand(1000...9999), kind: 2, record_time: time.strftime("%Y-%m-%d"))
      time = time + 1.day
    end

    # 生成收入来源
    IncomeSource.find_or_create_by(name: '微信支付', description: '微信转账', kind: 1)
    IncomeSource.find_or_create_by(name: '现金捐助', description: '行走吧格桑花线下募捐', kind: 2)

    # 生成入账记录（格桑花非指定）
    # IncomeRecord.create(user_id: 2, fund_id: 4, income_source_id: 1, amount: 777.7, remitter_name: '可爱的人', remitter_id: 2, donor: '可爱的人', income_time: Time.now)

  end

  task income_source: :environment do
    IncomeSource.where(kind: [1, 2, 3]).update(kind: 1)
    IncomeSource.where(kind: 4).update(kind: 2)
  end

end
