# == Schema Information
#
# Table name: funds
#
#  id               :integer          not null, primary key
#  name             :string                                 # 基金名
#  position         :integer                                # 排序
#  amount           :decimal(14, 2)   default(0.0)          # 金额
#  total            :decimal(14, 2)   default(0.0)          # 历史收入
#  management_rate  :integer          default(0)            # 管理费率
#  describe         :string                                 # 简介
#  fund_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Fund < ApplicationRecord
  has_many :donate_records
  has_many :income_records
  has_many :expenditure_records
  has_many :projects
  has_many :project_templates

  validates :name, :describe, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

end
