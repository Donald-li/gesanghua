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
#  state            :integer          default("show")       # 状态 1:显示 2:隐藏
#  fund_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Fund < ApplicationRecord
  belongs_to :fund_category
  has_many :donate_records
  has_many :income_records
  has_many :expenditure_records
  has_many :projects
  has_many :project_templates

  validates :name, :describe, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

  enum kind: {nondirectional: 1, directional: 2} # 类型 1:非定向 2:定向

  enum use_kind: {unrestricted: 1, restricted: 2} # 指定类型 1:非指定 2:指定

  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end

end