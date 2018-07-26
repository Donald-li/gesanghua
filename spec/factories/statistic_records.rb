# == Schema Information
#
# Table name: statistic_records
#
#  id          :bigint(8)        not null, primary key
#  amount      :integer          default(0)            # 今日更新数量
#  kind        :integer                                # 类型
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  record_time :datetime                               # 统计时间
#  owner_type  :string
#  owner_id    :integer
#

FactoryBot.define do
  factory :statistic_record do
    amount 1
    kind 1
  end
end
