# == Schema Information
#
# Table name: income_records # 入帐记录表
#
#  id               :bigint(8)        not null, primary key
#  donor_id         :integer                                # 用户id
#  fund_id          :integer                                # 基金ID
#  income_source_id :integer                                # 来源id
#  amount           :decimal(14, 2)   default(0.0)          # 入账金额
#  balance          :decimal(14, 2)   default(0.0)          # 余额
#  agent_id         :integer                                # 汇款人id
#  promoter_id      :integer                                # 劝捐人
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  income_time      :datetime                               # 入账时间
#  remark           :text                                   # 备注
#  voucher_state    :integer                                # 开票状态
#  title            :string                                 # 收入名称
#  donation_id      :integer                                # 捐助id
#  kind             :integer                                # 来源: 1:线上 2:线下
#  team_id          :integer                                # 团队id
#  voucher_id       :integer                                # 捐赠收据ID
#  certificate_no   :string                                 # 捐赠证书编号
#  income_no        :string                                 # 收入编号
#  archive_data     :jsonb                                  # 归档旧数据
#  remitter         :string                                 # 汇款人（用于线下记录）
#

require 'rails_helper'

RSpec.describe IncomeRecord, type: :model do
  it '测试每日筹款金额统计功能' do
    user = create(:user)
    fc = FundCategory.find_or_create_by(name: '结对助学', describe: '结对助学')
    fund = fc.funds.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id, kind: fc.kind)
    income_source1 =  IncomeSource.find_or_create_by(name: '微信支付', description: '微信转账', kind: 1)
    income_source2 =  IncomeSource.find_or_create_by(name: '现金捐助', description: '行走吧格桑花线下募捐', kind: 2)
    IncomeRecord.create(donor_id: user.id, fund_id: fund.id, income_source_id: income_source1.id, amount: 200, income_time: Time.now)
    IncomeRecord.create(donor_id: user.id, fund_id: fund.id, income_source_id: income_source2.id, amount: 300, income_time: Time.now - 1.day)

    IncomeRecord.update_income_statistic_record

    expect(StatisticRecord.income_statistic.where(record_time: Time.now.beginning_of_day..Time.now.end_of_day).first.amount) === IncomeRecord.where(income_time: Time.now.beginning_of_day..Time.now.end_of_day).pluck(:amount).reduce(:+)
    expect(StatisticRecord.income_statistic.where(record_time: (Time.now - 1.day).beginning_of_day..(Time.now - 1.day).end_of_day).first.amount) === IncomeRecord.where(income_time: (Time.now - 1.day).beginning_of_day..(Time.now - 1.day).end_of_day).pluck(:amount).reduce(:+)

  end

  describe '测试捐赠编号和捐赠证书生成方法' do
    let (:record) {create(:income_record)}

    it '测试捐赠编号方法' do
      record.gen_certificate_no
      expect(record.certificate_no.present?).to eq true
      # pp record.donor_certificate_path
    end

    it '测试捐赠证书' do
      expect(record.donor_certificate_path).to eq "/images/certificates/#{record.created_at.strftime('%Y%m%d')}/#{record.id}/#{Encryption.md5(record.certificate_no.to_s)}.jpg"
    end
  end
end
