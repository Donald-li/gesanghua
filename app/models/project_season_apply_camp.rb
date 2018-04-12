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
#  contact_name            :string
#  contact_phone           :string
#

class ProjectSeasonApplyCamp < ApplicationRecord

  belongs_to :school
  belongs_to :camp, optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  has_many :camp_members, class_name: 'ProjectSeasonApplyCampMember', dependent: :destroy

  enum time_limit: {restrict: 1, unrestrict: 2}
  default_value_for :time_limit, 1

  # enum message_type: {system: 1, note: 2}

  enum execute_state: {to_submit: 1, to_approve: 2, approved: 3}
  default_value_for :execute_state, 1

  validates :describe, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :student_number, :execute_state, :teacher_number, :time_limit, :describe)
      json.name self.apply.try(:apply_name)
      json.apply_no self.apply.try(:apply_no)
      json.school_name self.school.try(:name)
      json.end_time self.end_time.strftime("%Y-%m-%d %H:%M") if self.restrict?
    end.attributes!
  end

  # 探索营
  def camp_applies_builder
    Jbuilder.new do |json|
      json.(self, :id, :execute_state, :student_number, :teacher_number)
      json.name self.apply.try(:apply_name)
    end.attributes!
  end

end
