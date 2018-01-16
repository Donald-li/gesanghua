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

class StatisticRecord < ApplicationRecord
  default_value_for :amount, 0
  enum kind: {user_register: 1, income_statistic: 2}

  scope :reverse_sorted, -> { order(created_at: :asc) }

end
