# == Schema Information
#
# Table name: finance_categories # 财务分类表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 分类名称
#  position   :integer                                # 排序
#  fund_name  :string                                 # 基金名称
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  describe   :string                                 # 简介
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FinanceCategory < ApplicationRecord
  has_many :donate_records
  has_many :income_records
  has_many :expenditure_records
  has_many :projects
  has_many :project_templates

  validates :name, :describe, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end
end
