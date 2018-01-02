# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  openid          :string                                 # 微信openid
#  name            :string                                 # 姓名
#  login           :string                                 # 登录账号
#  password_digest :string                                 # 密码
#  state           :integer          default("enabled")    # 状态 1:启用 2:禁用
#  team_id         :integer                                # 团队ID
#  profile         :jsonb                                  # 微信profile
#  gender          :integer                                # 性别，1：男 2：女
#  balance         :decimal(14, 2)   default(0.0)          # 账户余额
#  phone           :string                                 # 联系方式
#  email           :string                                 # 电子邮箱地址
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user do
    openid "MyString"
    name {Faker::Name.name}
    login {Faker::Name.first_name}
    password_digest "111111"
    profile ""
    balance "0"
    phone {"18888#{rand(899999)+100000}"}
  end
end
