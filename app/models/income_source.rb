# == Schema Information
#
# Table name: income_sources # 收入来源
#
#  id          :integer          not null, primary key
#  name        :string                                 # 名称
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string                                 # 描述
#  position    :integer                                # 位置
#  kind        :integer                                # 类型： 1:线上（online） 2:线下（offline）
#  amount      :decimal(14, 2)   default(0.0)          # 累计收入
#  in_total    :decimal(14, 2)   default(0.0)          # 历史收入
#  out_total   :decimal(14, 2)   default(0.0)          # 历史支出
#

# 收入来源
class IncomeSource < ApplicationRecord
  has_many :income_records
  has_many :expenditure_records

  has_many :campaign_enlists

  has_many :adjust_records, as: :form_item, foreign_key: :from_item_id
  has_many :adjust_records, as: :to_item, foreign_key: :to_item_id
  has_many :statistic_records, as: :owner

  validates :name, presence: true

  enum kind: {online: 1, offline: 2} # 类型：  1:线上（online） 2:线下（offline）
  default_value_for :kind, 2

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  def self.wechat_id
    2
  end

  def self.alipay_id
    3
  end

  # 跨分类调整
  def self.platform_adjust(from_source, to_source, amount, user)
    amount = amount.to_f
    return false if amount < 1

    from = self.find(from_source)
    to = self.find(to_source)

    return false if from.amount < amount

    from.amount = from.amount - amount
    to.amount = to.amount + amount

    if from.save && to.save
      AdjustRecord.create(from_item: from, to_item: to, amount: amount, user: user)
    end
  end

end
