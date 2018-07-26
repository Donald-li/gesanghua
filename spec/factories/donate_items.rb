# == Schema Information
#
# Table name: donate_items # 可捐助项目表
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 说明
#  state      :integer                                # 状态： 1：显示 2：隐藏
#  position   :integer                                # 排序
#  fund_id    :integer                                # 基金id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :donate_item do
    name {Faker::Name.name}
    describe {Faker::Name.name}
    fund
  end
end
