# == Schema Information
#
# Table name: project_season_apply_periods # 项目申请时长
#
#  id                :integer          not null, primary key
#  name              :string                                 # 名称
#  kind              :integer                                # 类型
#  state             :integer                                # 状态
#  desciption        :string                                 # 描述
#  start_at          :datetime                               # 开始时间
#  end_at            :datetime                               # 结束时间
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_season_id :integer                                # 年度ID
#  position          :integer                                # 位置
#  grade             :integer                                # 一对一对应年级
#  semester          :integer                                # 一对一对应学期
#

# TODO:废弃：一对一项目申请期间学期
class ProjectSeasonApplyPeriod < ApplicationRecord

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  has_many :period_child_ships, dependent: :destroy
  has_many :project_season_apply_children, through: :period_child_ships

  validates :name, presence: true

  enum level: {primary: 0, junior: 1, senior: 2, abbreviation: 4} # 学校等级：0小学 1:初中 2:高中 4职高
  default_value_for :kind, 1

  enum grade: {one: 1, two: 2, three: 3}

  enum semester: {last_term: 1, next_term: 2}

  enum state: {enable: 1, disable: 2}
  default_value_for :state, 1

  def start_at_format
    return self.start_at.present? ? self.start_at.strftime("%Y-%m-%d %H:%M") : '' #"%Y-%m-%d %H:%M:%S"
  end

  def end_at_format
    return self.end_at.present? ? self.end_at.strftime("%Y-%m-%d %H:%M") : '' #"%Y-%m-%d %H:%M:%S"
  end

end
