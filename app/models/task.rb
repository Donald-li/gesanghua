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
#  apply_end_at     :datetime                               # 申请结束时间
#  principal_id     :integer                                # 任务负责人
#  task_no          :string                                 # 任务编号
#  ordinary_flag    :boolean          default(FALSE)        # 日常
#  intensive_flag   :boolean          default(FALSE)        # 重点
#  urgency_flag     :boolean          default(FALSE)        # 紧急
#  innovative_flag  :boolean          default(FALSE)        # 创新
#  difficult_flag   :boolean          default(FALSE)        # 难点
#

# 志愿者任务
class Task < ApplicationRecord

  before_create :gen_task_no

  # belongs_to :major, optional: true
  belongs_to :task_category
  belongs_to :workplace
  belongs_to :principal, class_name: 'User', foreign_key: 'principal_id'

  has_many :task_volunteers, dependent: :destroy
  has_many :volunteers, through: :task_volunteers

  validates :name, :duration, :content, presence: true

  include HasAsset
  has_one_asset :cover, class_name: 'Asset::TaskCover'

  enum state: {draft: 1, open: 2, picking: 3, pick_done: 4, doing: 5, done: 6, cancel: 7} # 状态 1:创建 2:报名 3:筛选 4:筛选完成 5:进行 6:完成, 7:已取消
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

  def gen_task_no
    time_string = Time.now.strftime("%y%m%d")
    self.task_no ||= Sequence.get_seq(kind: :task_no, prefix: time_string, length: 3)
  end

  def task_action(user)
    tv = self.task_volunteers.find_by(volunteer: user.volunteer)
    if self.open? && tv.doing?
      'can_cancel'
    elsif self.pick_done? || self.done? || self.cancel?
      'can_visit'
    elsif self.doing?
      if tv.doing?
        'can_finish'
      end
    end
  end

  def task_state(user)
    tv = self.task_volunteers.find_by(volunteer: user.volunteer)
    if self.open?
      if tv.cancel?
        '申请已取消'
      else
        '待审核'
      end
    elsif self.pick_done?
      if tv.reject?
        '审核未通过'
      else
        '任务未开始'
      end
    elsif self.doing?
      if tv.turn_over?
        '任务已移交'
      elsif tv.doing?
        '任务进行中'
      else
        '成果已提交'
      end
    elsif self.done?
      '任务已完成'
    elsif self.cancel?
      '任务已取消'
    end
  end

  def summary_builder(user=nil)
    Jbuilder.new do |json|
      json.(self, :id, :name, :num, :duration, :ordinary_flag, :intensive_flag, :urgency_flag, :innovative_flag, :difficult_flag)
      json.location self.workplace.try(:title)
      json.cover_mode self.cover.present?
      json.cover_url self.cover_url(:small)
      json.task_state self.task_state(user) if user.present?
      json.task_action self.task_action(user) if user.present?
    end.attributes!
  end

  def detail_builder(user=nil)
    Jbuilder.new do |json|
      json.(self, :id, :name, :num, :duration, :content, :ordinary_flag, :intensive_flag, :urgency_flag, :innovative_flag, :difficult_flag)
      json.location self.workplace.try(:title)
      json.principal self.principal.try(:name)
      json.avatar_mode self.principal.try(:avatar).present?
      json.avatar_url self.principal.try(:avatar).try(:file).try(:url)
      json.category self.task_category.try(:name)
      json.start_time self.start_time.strftime("%Y-%m-%d")
      json.end_time self.end_time.strftime("%Y-%m-%d")
      json.cover_mode self.cover.present?
      json.cover_url self.cover_url(:small)
      json.can_apply !self.task_volunteers.where(volunteer: user.volunteer).present?
    end.attributes!
  end

end
