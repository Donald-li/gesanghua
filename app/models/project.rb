# == Schema Information
#
# Table name: projects # 项目表
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 项目名称
#  type                :string                                 # 项目类型：1:结对 2:物资 3:悦读 4:营 5:观影
#  content             :text                                   # 项目内容
#  state               :integer          default("enabled")    # 项目状态：1:启用 2:禁用
#  fund_id             :integer                                # 基金ID
#  contribute_kind     :integer          default("entirety")   # 捐款类型：1:整捐 2:零捐
#  category_type       :string                                 # 具体项目分类
#  category_id         :integer                                # 分类ID
#  project_template_id :integer                                # 项目模板ID
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  junior_term_amount  :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount  :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount  :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount  :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
#

class Project < ApplicationRecord
  belongs_to :fund
  belongs_to :project_template

  has_many :campaigns
  has_many :donate_records
  has_many :project_applies
  has_many :goods_project_apply_items

  validates :name, :content, presence: true

  enum state: {enabled: 1, disabled: 2} # 状态：1:启用 2:禁用
  enum contribute_kind: { entirety: 1, scattered: 2 } # 捐款类型：1:整捐 2:零捐

  scope :sorted, ->{ order(created_at: :desc) }

  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end

end
