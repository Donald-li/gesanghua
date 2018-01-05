# == Schema Information
#
# Table name: projects
#
#  id                 :integer          not null, primary key
#  type               :string                                 # 单表继承字段
#  kind               :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name               :string                                 # 项目名称
#  describe           :text                                   # 简介
#  protocol           :text                                   # 用户协议
#  fund               :integer                                # 关联财务分类id
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  junior_term_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
#

class Project < ApplicationRecord
  has_many :seasons, class_name: 'ProjectSeason', dependent: :destroy
  has_many :applies, class_name: 'ProjectSeasonApply', dependent: :destroy
  has_many :children, class_name: 'ProjectSeasonApplyChild', dependent: :destroy
  has_many :bookshelves, class_name: 'ProjectSeasonApplyBookshelf', dependent: :destroy
  has_many :goods, class_name: 'ProjectSeasonApplyGoods', dependent: :destroy
  has_many :volunteer, class_name: 'Volunteer', dependent: :destroy

  belongs_to :fund, optional: true

  validates :name, :protocol, presence: true

  enum kind: { normal: 1, goods: 2 } # 项目类型 1:基本类 2:物资类

  scope :sorted, ->{ order(created_at: :desc) }

  def sliced_describe
    self.describe.length > 90 ? self.describe.slice(0..90) : self.describe
  end

end
