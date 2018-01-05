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
#

class ProjectSeasonApplyPeriod < ApplicationRecord

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  has_many :period_child_ships
  has_many :project_season_apply_children, through: :period_child_ships

  validates :name, presence: true

  enum state: {enabled: 1, disabled: 2}
  default_value_for :state, 1

  def start_at_format
    return self.start_at.present? ? self.start_at.strftime("%Y-%m-%d %H:%M") : '' #"%Y-%m-%d %H:%M:%S"
  end

end
