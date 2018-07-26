# == Schema Information
#
# Table name: fund_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                     # 分类名
#  position   :integer                                    # 排序
#  amount     :decimal(14, 2)   default(0.0)              # 金额
#  total      :decimal(14, 2)   default(0.0)              # 历史收入
#  describe   :string                                     # 简介
#  state      :integer          default("show")           # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :integer          default("nondirectional") # 类型 1:非定向 2:定向
#

# 一级财务分类
class FundCategory < ApplicationRecord
  has_many :funds, dependent: :restrict_with_error

  validates :name, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }
  scope :reverse_sorted, ->{ sorted.reverse_order }

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

  enum kind: {nondirectional: 1, directional: 2} # 类型 1:非定向 2:定项

end
