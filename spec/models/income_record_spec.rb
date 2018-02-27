# == Schema Information
#
# Table name: income_records # 入帐记录表
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户id
#  fund_id          :integer                                # 基金ID
#  appoint_type     :string                                 # 指定类型
#  appoint_id       :integer                                # 指定类型id
#  state            :integer                                # 状态
#  income_source_id :integer                                # 来源id
#  amount           :decimal(14, 2)   default(0.0)          # 入账金额
#  balance          :decimal(14, 2)   default(0.0)          # 余额
#  remitter_name    :string                                 # 汇款人姓名
#  remitter_id      :integer                                # 汇款人id
#  donor            :string                                 # 捐赠者
#  promoter_id      :integer                                # 劝捐人
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  income_time      :datetime                               # 入账时间
#  remark           :text                                   # 备注
#  voucher_state    :integer                                # 开票状态
#  title            :string                                 # 收入名称
#

require 'rails_helper'

RSpec.describe IncomeRecord, type: :model do
  it '测试每日筹款金额统计功能' do
    user = create(:user)
    fc = FundCategory.find_or_create_by(name: '一对一', describe: '一对一', kind: 'directional')
    fund = fc.funds.find_or_create_by(name: "非指定", management_rate: 0, describe: '定向非指定', fund_category_id: fc.id, kind: fc.kind, use_kind: 'unrestricted')
    income_source1 =  IncomeSource.find_or_create_by(name: '微信支付', description: '微信转账', kind: 1)
    income_source2 =  IncomeSource.find_or_create_by(name: '现金捐助', description: '行走吧格桑花线下募捐', kind: 2)
    IncomeRecord.create(user_id: user.id, fund_id: fund.id, income_source_id: income_source1.id, amount: 200, remitter_name: '爱心人士', remitter_id: user.id, donor: '爱心人士', income_time: Time.now)
    IncomeRecord.create(user_id: user.id, fund_id: fund.id, income_source_id: income_source2.id, amount: 300, remitter_name: '爱心人士', remitter_id: user.id, donor: '爱心人士', income_time: Time.now - 1.day)

    IncomeRecord.update_income_statistic_record

    expect(StatisticRecord.income_statistic.where(record_time: Time.now.beginning_of_day..Time.now.end_of_day).first.amount).to eq 200
    expect(StatisticRecord.income_statistic.where(record_time: (Time.now - 1.day).beginning_of_day..(Time.now - 1.day).end_of_day).first.amount).to eq 300

  end
end
