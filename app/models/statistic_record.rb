# == Schema Information
#
# Table name: statistic_records
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0)            # 今日更新数量
#  kind        :integer                                # 类型
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  record_time :datetime                               # 统计时间
#  owner_type  :string
#  owner_id    :integer
#

# 统计记录
class StatisticRecord < ApplicationRecord

  default_value_for :amount, 0
  enum kind: {user_register: 1, income_statistic: 2, expend_statistic: 3}

  belongs_to :owner, polymorphic: true, optional: true

  scope :record_sorted, -> { order(record_time: :asc) }

end
