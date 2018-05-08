# == Schema Information
#
# Table name: project_seasons # 项目执行年度表
#
#  id                   :integer          not null, primary key
#  project_id           :integer                                # 关联项目表id
#  name                 :string                                 # 执行年度名称
#  state                :integer                                # 状态 1:未执行 2:执行中
#  junior_term_amount   :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount   :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount   :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount   :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  bookshelf_univalence :decimal(14, 2)   default(0.0)          # 单个图书角金额
#

# 项目年度（批次）
class ProjectSeason < ApplicationRecord
  has_paper_trail only: [:project_id, :name, :state, :junior_term_amount, :junior_year_amount, :senior_term_amount, :senior_year_amount, :bookshelf_univalence]

  belongs_to :project

  has_many :goods, class_name: 'ProjectSeasonGoods', dependent: :restrict_with_error
  accepts_nested_attributes_for :goods, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }

  has_many :applies, class_name: 'ProjectSeasonApply', dependent: :restrict_with_error

  validates :name, presence: true

  enum state: {enable: 1, disable: 2}
  default_value_for :state, 1

  scope :sorted, -> { order(id: :desc)}
  scope :pair, -> { where(project_id: Project.pair_project.id) } # 一对一
  scope :read, -> { where(project_id: Project.read_project.id) } # 悦读
  scope :movie, -> { where(project_id: Project.movie_project.id) } # 观影
  scope :movie_care, -> { where(project_id: Project.movie_care_project.id) } # 观影
  scope :camp, -> { where(project_id: Project.camp_project.id) } # 探索营
  scope :radio, -> { where(project_id: Project.radio_project.id) } # 广播
  scope :flower, -> { where(project_id: Project.care_project.id) } # 护花

end
