# == Schema Information
#
# Table name: amount_tabs # 金额选项卡表
#
#  id             :integer          not null, primary key
#  amount         :decimal(14, 2)   default(0.0)          # 金额
#  alias          :string                                 # 别名
#  state          :integer          default("show")       # 状态 1:显示 2:隐藏
#  donate_item_id :integer                                # 可捐助id
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class AmountTab < ApplicationRecord
  belongs_to :donate_item, optional: true

  enum state: { show: 1, hidden: 2}# 状态 1:显示 2:隐藏
  default_value_for :state, 1

  validates :amount, presence: true

  scope :sorted, -> { order(amount: :asc) }

end
