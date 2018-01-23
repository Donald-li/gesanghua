# == Schema Information
#
# Table name: offline_donors # 代捐人表
#
#  id         :integer          not null, primary key
#  user_id    :integer                                # 用户ID
#  name       :string                                 # 姓名
#  state      :integer                                # 状态
#  gender     :integer                                # 性别，1：男 2：女
#  email      :string                                 # 邮箱
#  phone      :string                                 # 联系方式
#  address    :string                                 # 详细地址
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  nickname   :string                                 # 昵称
#  salutation :string                                 # 孩子们如何称呼我
#

FactoryBot.define do
  factory :offline_donor do
    name {FFaker::NameCN.name}
    province '630000'
    city '630100'
    district '630123'
    sequence(:phone) { |n| "18788#{n.to_s.rjust(6,'0')}" }
  end
end
