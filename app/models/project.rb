# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  describe   :text                                   # 简介
#  protocol   :text                                   # 用户协议
#  fund_id    :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord
  has_many :seasons, class_name: 'ProjectSeason', dependent: :destroy
  has_many :applies, class_name: 'ProjectSeasonApply', dependent: :destroy
  has_many :children, class_name: 'ProjectSeasonApplyChild', dependent: :destroy
  has_many :bookshelves, class_name: 'ProjectSeasonApplyBookshelf', dependent: :destroy
  has_many :goods, class_name: 'ProjectSeasonApplyGoods', dependent: :destroy
  has_many :volunteer, class_name: 'Volunteer', dependent: :destroy
  has_many :teacher_projects
  has_many :teacher, through: :teacher_projects

  belongs_to :fund, optional: true

  validates :name, :protocol, presence: true

  enum kind: { normal: 1, goods: 2 } # 项目类型 1:固定项目 2:物资类项目

  scope :sorted, ->{ order(created_at: :asc) }

  def sliced_describe
    self.describe.length > 90 ? self.describe.slice(0..90) : self.describe
  end

end
