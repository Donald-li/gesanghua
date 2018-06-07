require 'axlsx'
class ExcelOutput

  def self.school_output
    p = Axlsx::Package.new
    wb = p.workbook
    schools = School.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["学校名称", "申请时间", "所在地区", "负责人", "联系电话"]
      schools.each do |school|
        sheet.add_row [school.name,
                       school.created_at.strftime("%Y-%m-%d %H:%M"),
                       school.full_address,
                       school.contact_name,
                       school.contact_phone]
      end
    end
    FileUtils.mkdir_p(Rails.root.join("public/files"))
    path = Rails.root.join("public/files/学校" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
    p.serialize path
    return path
  end

  def self.donate_statistics_output
    p = Axlsx::Package.new
    wb = p.workbook
    users = User.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["用户ID", "昵称", "姓名", "手机号码", "捐助金额", "线上捐助", "线下捐助"]
      users.each do |user|
        sheet.add_row [user.id,
                       user.nickname,
                       user.show_name,
                       user.phone,
                       user.donate_amount,
                       user.online_amount,
                       user.offline_amount]
      end
    end
    FileUtils.mkdir_p(Rails.root.join("public/files"))
    path = Rails.root.join("public/files/用户捐助统计" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
    p.serialize path
    return path
  end

  # def self.pair_grants_output
  #   p = Axlsx::Package.new
  #   wb = p.workbook
  #   grants = GshChildGrant.sorted
  #   wb.add_worksheet(:name => "表") do |sheet|
  #     sheet.add_row ["编号", "姓名", "年龄", "发放日期", "学校", "发放说明", "发放金额", "筹款状态", "发放状态"]
  #     grants.each do |grant|
  #       sheet.add_row [grant.grant_no,
  #                      grant.try(:gsh_child).try(:name),
  #                      grant.try(:gsh_child).try(:age),
  #                      (grant.granted_at.strftime("%Y-%m-%d %H:%M") if grant.granted_at),
  #                      grant.try(:school).try(:name),
  #                      grant.grant_remark,
  #                      grant.amount,
  #                      grant.enum_name(:donate_state),
  #                      grant.enum_name(:state)]
  #     end
  #   end
  #   p.serialize "public/files/一对一发放" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx"
  # end

  def self.campaign_enlist_output(campaign)
    p = Axlsx::Package.new
    wb = p.workbook
    campaign_enlists = campaign.campaign_enlists.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      if campaign.price == 0
        sheet.add_row ["报名用户", "用户昵称", "报名时间"] | campaign.form.map {|i| i['label']} | ["报名人数", "联系人", "联系电话"]
        campaign_enlists.each do |campaign_enlist|
          sheet.add_row [campaign_enlist.user.try(:nickname),
                         campaign_enlist.created_at.strftime("%Y-%m-%d %H:%M")] |
                            campaign.form.map {|i| campaign_enlist.form[i['key']]} |
                            [campaign_enlist.number,
                             campaign_enlist.contact_name,
                             campaign_enlist.contact_phone]
        end
      else
        sheet.add_row ["报名用户", "用户昵称", "报名时间"] | campaign.form.map {|i| i['label']} | ["报名人数", "联系人", "联系电话", '金额', '支付状态']
        campaign_enlists.each do |campaign_enlist|
          sheet.add_row [campaign_enlist.user.try(:nickname),
                         campaign_enlist.created_at.strftime("%Y-%m-%d %H:%M")] |
                            campaign.form.map {|i| campaign_enlist.form[i['key']]} |
                            [campaign_enlist.number,
                             campaign_enlist.contact_name,
                             campaign_enlist.contact_phone,
                             campaign_enlist.total,
                             campaign_enlist.enum_name(:payment_state)]
        end
      end
      FileUtils.mkdir_p(Rails.root.join("public/files"))
      path = Rails.root.join("public/files/活动" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
      p.serialize path
      return path
    end
  end

  def self.generate_income_template
    p = Axlsx::Package.new
    wb = p.workbook
    funds = Fund.sorted
    income_sources = IncomeSource.sorted

    header = wb.styles.add_style :sz => 16, :b => true, :alignment => {:horizontal => :center}
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["收入名称", "财务分类", "捐助时间", "捐助金额", "捐助渠道", "捐助人", "手机号码", "代捐人", "代捐人手机号", "备注"], :style => header
      sheet.add_row ["爱心人士捐助结对助学非指定款项", "结对助学-非指定", "2018/1/17 12:30", "2000", "微信支付", "爱心人士", "13800888888", "爱心人士", "18399998888", "好好学习", "请按照模板格式填写"], types: [:string] * 9
      3.times do
        sheet.add_row []
      end
      sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "录入数据以后，请删除以下数据"], :style => header
      sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "财务分类名称模板", "请按照财务分类名称模板填写财务分类"], :style => header
      funds.each do |fund|
        sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "#{fund.fund_category.name}-#{fund.name}"]
      end
      sheet.add_row []
      sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "捐助渠道名称模板", "请按照捐助渠道名称模板填写捐助渠道"], :style => header
      income_sources.each do |source|
        sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, source.name]
      end
      FileUtils.mkdir_p(Rails.root.join("public/files"))
      path = Rails.root.join("public/收入导入模板" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
      p.serialize path
      return path
    end
  end

  def self.generate_expenditure_template
    p = Axlsx::Package.new
    wb = p.workbook
    ledgers = ExpenditureLedger.sorted

    header = wb.styles.add_style :sz => 16, :b => true, :alignment => {:horizontal => :center}
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["支出名称", "支出时间", "财务分类", "支出金额", "备注", "经办人"], :style => header
      sheet.add_row ["结对助学孩子支出", "2018/1/17 12:30", "办公经费", "2000", "好好学习", "李阿姨", "请按照模板格式填写"], types: [:string] * 6
      3.times do
        sheet.add_row []
      end
      sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, "录入数据以后，请删除以下数据"], :style => header
      sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, "财务分类名称模板", "请按照财务分类名称模板填写财务分类"], :style => header
      ledgers.each do |ledger|
        sheet.add_row [nil, nil, nil, nil, nil, nil, nil, nil, ledger.name]
      end
      FileUtils.mkdir_p(Rails.root.join("public/files"))
      path = Rails.root.join("public/支出导入模板" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
      p.serialize path
      return path
    end
  end

  # def self.grant_batch_output(batch)
  #   p = Axlsx::Package.new
  #   wb = p.workbook
  #   grants = batch.grants.all.sorted
  #   wb.add_worksheet(:name => "表") do |sheet|
  #     sheet.add_row ["申请批次", "格桑花编号", "姓名", "年龄", "学校", "捐助学年", "发放金额", "筹款状态", "发放状态", "捐助人姓名", "捐助人称呼"]
  #     grants.each do |grant|
  #       sheet.add_row [grant.apply_child.try(:season).try(:name),
  #                      grant.apply_child.gsh_no,
  #                      grant.apply_child.try(:name),
  #                      grant.apply_child.age,
  #                      grant.school.try(:name),
  #                      grant.title,
  #                      grant.amount,
  #                      grant.apply_child.raise_condition,
  #                      grant.enum_name(:state),
  #                      grant.user.try(:name),
  #                      grant.user.try(:salutation)]
  #     end
  #   end
  #   FileUtils.mkdir_p(Rails.root.join("public/files"))
  #   path = Rails.root.join("public/files/发放批次" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
  #   p.serialize path
  #   return path
  # end

end
