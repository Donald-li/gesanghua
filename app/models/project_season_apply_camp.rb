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
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  execute_state           :integer
#  teacher_id              :integer                                # 联系老师id
#

class ProjectSeasonApplyCamp < ApplicationRecord

  belongs_to :school
  belongs_to :camp
  belongs_to :teacher, optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  has_many :project_season_apply_camp_members, dependent: :destroy

  enum time_limit: {restrict: 1, unrestrict: 2}
  default_value_for :time_limit, 1

  # enum message_type: {system: 1, note: 2}

  enum execute_state: {to_submit: 1, to_approve: 2, approved: 3}
  default_value_for :execute_state, 1

  validates :describe, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

end
