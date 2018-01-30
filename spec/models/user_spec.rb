# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  openid          :string                                 # 微信openid
#  name            :string                                 # 姓名
#  login           :string                                 # 登录账号
#  password_digest :string                                 # 密码
#  state           :integer          default("enable")     # 状态 1:启用 2:禁用
#  team_id         :integer                                # 团队ID
#  profile         :jsonb                                  # 微信profile
#  gender          :integer                                # 性别，1：男 2：女
#  balance         :decimal(14, 2)   default(0.0)          # 账户余额
#  phone           :string                                 # 联系方式
#  email           :string                                 # 电子邮箱地址
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  nickname        :string                                 # 昵称
#  salutation      :string                                 # 孩子们如何称呼我
#  consignee       :string                                 # 收货人
#  province        :string                                 # 省
#  city            :string                                 # 市
#  district        :string                                 # 区/县
#  address         :string                                 # 详细地址
#  qq              :string                                 # qq号
#  idcard          :string                                 # 身份证
#  donate_count    :decimal(14, 2)   default(0.0)          # 捐助金额
#  online_count    :decimal(14, 2)   default(0.0)          # 线上捐助金额
#  offline_count   :decimal(14, 2)   default(0.0)          # 线下捐助金额
#  auth_token      :string                                 # Token
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:promoter) { create(:user) }

  it '测试每日注册用户统计功能' do

    User.update_user_statistic_record

    expect(StatisticRecord.user_register.where(record_time: Time.now.beginning_of_day..Time.now.end_of_day).first.amount).to eq User.count

  end

  it '测试用户捐给格桑花' do
    amount = 100000.01
    user.donate_gsh(amount: amount)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq Fund.gsh.id
  end

  it '测试有劝捐人的用户捐给格桑花' do
    amount = 999
    user.donate_gsh(amount: amount, promoter: promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq Fund.gsh.id
  end

  it '测试用户捐给一对一项目' do
    amount = 313213
    project = Project.pair_project
    user.donate_project(amount: amount, project: project)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.fund.id
  end
end
