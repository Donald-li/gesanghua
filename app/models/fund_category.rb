# == Schema Information
#
# Table name: fund_categories
#
#  id         :integer          not null, primary key
#  name       :string                                 # 分类名
#  position   :integer                                # 排序
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  total      :decimal(14, 2)   default(0.0)          # 历史收入
#  describe   :string                                 # 简介
#  state      :integer          default("show")       # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FundCategory < ApplicationRecord
  has_many :funds

  validates :name, :describe, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

  enum kind: {nondirectional: 1, directional: 2} # 类型 1:非定向 2:定向

end
