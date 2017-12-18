# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id         :integer          not null, primary key
#  level      :integer                                # 等级
#  major_id   :integer                                # 专业id
#  duration   :integer                                # 服务时长
#  user_id    :integer                                # 用户
#  job_state  :integer                                # 任务状态
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Volunteer < ApplicationRecord
  has_one :major
  belongs_to :user
  has_many :task_volunteers
  has_many :tasks, through: :task_volunteers

  validates :major_id, numericality: true
  validates :user_id, numericality: {only_integer: true}
  validates :job_state, numericality: {only_integer: true}
  validates :state, numericality: {only_integer: true}
end
