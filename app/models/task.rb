# == Schema Information
#
# Table name: tasks # 任务表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 任务名
#  duration   :integer                                # 时长
#  content    :text                                   # 内容
#  num        :integer                                # 人数
#  state      :integer                                # 状态
#  major_id   :integer                                # 专业id
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_time :datetime                               # 任务开始时间
#  end_time   :datetime                               # 任务结束时间
#  kind       :integer
#

class Task < ApplicationRecord
  belongs_to :major, optional: true

  has_many :task_volunteers, dependent: :destroy
  has_many :volunteers, through: :task_volunteers

  validates :name, :duration, :content, presence: true

  enum state: {draft: 1, open: 2, picking: 3, pick_done: 4, doing: 5, done: 6} # 状态 1:创建 2:报名 3:筛选 4:筛选完成 5:进行 6:完成
  default_value_for :state, 1

  enum kind: {normal: 1, appoint: 2} # 任务类型： 1:公开任务 2:指定任务
  default_value_for :kind, 1

  scope :sorted, ->{ order(created_at: :desc) }

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def participant_number
    self.task_volunteers.count
  end

end
