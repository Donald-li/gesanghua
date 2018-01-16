# == Schema Information
#
# Table name: project_season_applies # 项目执行年度申请表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联项目执行年度的id
#  school_id         :integer                                # 关联学校id
#  teacher_id        :integer                                # 负责项目的老师id
#  describe          :text                                   # 描述、申请要求
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  state             :integer          default("show")       # 状态：1:展示 2:隐藏
#  gsh_child_id      :integer                                # 关联格桑花孩子id
#  gsh_bookshelf_id  :integer                                # 关联格桑花书架(图书角)id
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#

class ProjectSeasonApply < ApplicationRecord
  belongs_to :project
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id'
  belongs_to :school, optional: true
  belongs_to :teacher, optional: true
  belongs_to :gsh_child, optional: true
  belongs_to :gsh_bookshelf, optional: true
  has_many :audits, as: :owner
  has_many :children, class_name: "ProjectSeasonApplyChild"

  validates :province, :city, :district, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏

  scope :sorted, ->{ order(created_at: :desc) }

end
