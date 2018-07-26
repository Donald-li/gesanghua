# == Schema Information
#
# Table name: camps # 探索营
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区、县
#  fund_id    :integer                                # 资金id
#  state      :integer                                # 状态：1:启用 2:禁用）
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  manager    :string                                 # 负责人
#

FactoryBot.define do
  factory :camp do
    name "MyString"
    province '630000'
    city '630100'
    district '630123'
    fund_id 1
    manager_id 1
    state 1
  end
end
