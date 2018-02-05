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
#  manager_id      :integer                                # 线下用户管理人id
#

FactoryBot.define do
  factory :user do
    openid "MyString"
    name "MyString"
    login {Faker::Name.name}
    password_digest "MyString"
    state 1
    team_id 1
    profile ""
    gender 1
    balance "9.99"
    auth_token Faker::Crypto.md5
    sequence(:phone) { |n| "18788#{n.to_s.rjust(6,'0')}" }
  end
end
