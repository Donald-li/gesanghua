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
#

class Task < ApplicationRecord
  belongs_to :major

  has_many :task_volunteers
  has_many :volunteers, through: :task_volunteers

  validates :name, :duration, :num, :content, presence: true

  enum state: {draft: 1, open: 2, doing: 3, done: 4} # 状态 1:创建 2:招募 3:进行 4:完成
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

end
