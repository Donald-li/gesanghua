# == Schema Information
#
# Table name: project_seasons # 项目执行年度表
#
#  id                 :integer          not null, primary key
#  project_id         :integer                                # 关联项目表id
#  name               :string                                 # 执行年度名称
#  state              :integer                                # 状态 1:未执行 2:执行中
#  junior_term_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ProjectSeason < ApplicationRecord
  belongs_to :project
  has_many :project_season_applies, dependent: :destroy

  validates :name, presence: true

  enum state: {enabled: 1, disabled: 2}

  scope :sorted, -> { order(created_at: :desc)}

  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end

  scope :pair, -> { where(project_id: 1) } # 结对
  scope :book, -> { where(project_id: 2) } # 悦读
  scope :movie, -> { where(project_id: 3) } # 观影
  scope :camp, -> { where(project_id: 4) } # 探索营
  scope :radio, -> { where(project_id: 5) } # 广播
  scope :flower, -> { where(project_id: 6) } # 护花

  def self.pair_project_id
    1 # TODO: 约定为1
  end

end
