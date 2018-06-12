# == Schema Information
#
# Table name: funds
#
#  id               :integer          not null, primary key
#  name             :string                                     # 基金名
#  position         :integer                                    # 排序
#  balance          :decimal(14, 2)   default(0.0)              # 金额
#  total            :decimal(14, 2)   default(0.0)              # 历史收入
#  management_rate  :integer          default(0)                # 管理费率
#  describe         :string                                     # 简介
#  state            :integer          default("show")           # 状态 1:显示 2:隐藏
#  fund_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  kind             :integer          default("nondirectional") # 类型 1:非定向 2:定向
#  use_kind         :integer          default("unrestricted")   # 指定类型 1:非指定 2:指定
#  out_total        :decimal(14, 2)   default(0.0)              # 历史支出
#

# 二级财务分类
class Fund < ApplicationRecord
  belongs_to :fund_category
  has_many :donate_records, dependent: :restrict_with_error
  has_many :income_records, dependent: :restrict_with_error
  has_many :expenditure_records, dependent: :restrict_with_error
  has_many :projects, dependent: :restrict_with_error
  has_many :month_donates, dependent: :restrict_with_error
  has_many :adjust_records, as: :form_item, foreign_key: :from_item_id
  has_many :adjust_records, as: :to_item, foreign_key: :to_item_id
  has_many :statistic_records, as: :owner

  validates :name, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  attr_accessor :amount

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

  enum kind: {nondirectional: 1, directional: 2} # 类型 1:非定向 2:定向

  enum use_kind: {unrestricted: 1, restricted: 2} # 指定类型 1:非指定 2:指定

  default_value_for :management_rate, 0

  # 返回格桑花财务分类
  def self.gsh
    self.find 1
  end

  # 跨分类调整
  def self.platform_adjust(from_fund, to_fund, amount, user)
    amount = amount.to_f
    return false if amount < 1

    from = Fund.find(from_fund)
    to = Fund.find(to_fund)

    return false if from.balance < amount

    from.balance = from.balance - amount
    to.balance = to.balance + amount

    if from.save && to.save
      AdjustRecord.create(from_item: from, to_item: to, amount: amount, user: user)
    end
  end
end
