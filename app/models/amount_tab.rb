# == Schema Information
#
# Table name: amount_tabs # 金额选项卡表
#
#  id             :bigint(8)        not null, primary key
#  amount         :decimal(14, 2)   default(0.0)          # 金额
#  alias          :string                                 # 别名
#  state          :integer          default("show")       # 状态 1:显示 2:隐藏
#  donate_item_id :integer                                # 可捐助id
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# 项目捐款时，金额选项
class AmountTab < ApplicationRecord

  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  belongs_to :donate_item, optional: true

  enum state: { show: 1, hidden: 2}# 状态 1:显示 2:隐藏
  default_value_for :state, 1

  validates :amount, presence: true

  scope :sorted, -> { order(amount: :asc) }

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :alias)
      json.amount format_money(self.amount)
    end.attributes!
  end

end
