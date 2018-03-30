# == Schema Information
#
# Table name: project_season_apply_camps # 探索营配额
#
#  id                      :integer          not null, primary key
#  project_season_apply_id :integer                                # 营立项id
#  camp_id                 :integer                                # 探索营id
#  school_id               :integer                                # 学校id
#  describe                :text                                   # 申请要求
#  student_number          :integer                                # 学生数量
#  teacher_number          :integer                                # 陪同老师数量
#  end_time                :datetime                               # 申请截止时间
#  time_limit              :integer                                # 是否设置截止时间
#  message_type            :integer                                # 通知方式
#  state                   :integer                                # 状态
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ProjectSeasonApplyCamp < ApplicationRecord

  belongs_to :school
  belongs_to :camp
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  has_many :project_season_apply_camp_students
  has_many :project_season_apply_camp_teachers

  enum time_limit: {restrict: 1, unrestrict: 2}
  default_value_for :time_limit, 1

  # enum message_type: {system: 1, note: 2}

  enum state: {to_submit: 1, to_approve: 2, approved: 3}
  default_value_for :state, 1

  validates :describe, presence: true

  scope :sorted, ->{ order(created_at: :asc) }

end
