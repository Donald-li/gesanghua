# == Schema Information
#
# Table name: income_sources # 收入来源
#
#  id          :integer          not null, primary key
#  name        :string                                 # 名称
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string                                 # 描述
#  position    :integer                                # 位置
#  kind        :integer                                # 类型： 1:线上（online） 2:线下（offline）
#  amount      :decimal(14, 2)   default(0.0)          # 累计收入
#

FactoryBot.define do
  factory :income_source do
    name {FFaker::NameCN.name}
    description {FFaker::LoremCN.sentence}
  end
end
