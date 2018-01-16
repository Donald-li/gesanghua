# == Schema Information
#
# Table name: statistic_records
#
#  id         :integer          not null, primary key
#  amount     :integer          default(0)            # 今日更新数量
#  kind       :integer                                # 类型
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :statistic_record do
    amount 1
    kind 1
  end
end
