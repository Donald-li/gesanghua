# == Schema Information
#
# Table name: tasks # 任务表
#
#  id               :integer          not null, primary key
#  name             :string                                 # 任务名
#  duration         :integer                                # 时长
#  content          :text                                   # 内容
#  num              :integer                                # 人数
#  state            :integer                                # 状态
#  major_id         :integer                                # 专业id
#  province         :string                                 # 省
#  city             :string                                 # 市
#  district         :string                                 # 区
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  start_time       :datetime                               # 任务开始时间
#  end_time         :datetime                               # 任务结束时间
#  kind             :integer
#  task_category_id :integer                                # 任务分类ID
#  workplace_id     :integer                                # 工作地点ID
#  types_mask       :integer                                # 任务类型
#  apply_end_at     :datetime                               # 申请结束时间
#  principal_id     :integer                                # 任务负责人
#

class Task < ApplicationRecord
  TaskTypes = %i[ordinary intensive urgency innovative difficult] # 日常 重点 紧急 创新 难点

  # belongs_to :major, optional: true
  belongs_to :task_category
  belongs_to :workplace
  belongs_to :principal, class_name: 'User', foreign_key: 'principal_id'

  has_many :task_volunteers, dependent: :destroy
  has_many :volunteers, through: :task_volunteers

  validates :name, :duration, :content, presence: true

  include HasAsset
  has_one_asset :cover, class_name: 'Asset::TaskCover'

  enum state: {draft: 1, open: 2, picking: 3, pick_done: 4, doing: 5, done: 6} # 状态 1:创建 2:报名 3:筛选 4:筛选完成 5:进行 6:完成
  default_value_for :state, 1

  enum kind: {normal: 1, appoint: 2} # 任务类型： 1:公开任务 2:指定任务
  default_value_for :kind, 1

  scope :sorted, ->{ order(created_at: :desc) }

  def task_types=(types)
    task_types = [*types].map { |r| r.to_sym }
    self.types_mask = (task_types & TaskTypes).map { |r| 2**TaskTypes.index(r) }.inject(0, :+)
  end

  def task_types
    TaskTypes.reject do |r|
      ((types_mask.to_i || 0) & 2**TaskTypes.index(r)).zero?
    end
  end

  def has_type?(type)
    task_types.include?(type)
  end

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def participant_number
    self.task_volunteers.count
  end

end
