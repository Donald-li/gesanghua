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
  enum kind: {user_register: 1, income_statistic: 2, finance_income_statistic: 3, finance_expend_statistic: 4, team_promote_statistic: 5}
  ##
  # kind:             #1       #2         #3            #4             #5
  # team:             #        #          #累计捐助      #              #成员劝捐
  # income_record:             #每日收入
  # user:             #每日注册
  # fund:                                 #每日收入      #每日支出
  # income_source:                        #每日收入      #每日支出

  belongs_to :owner, polymorphic: true, optional: true

  scope :record_sorted, -> { order(record_time: :asc) }

end
